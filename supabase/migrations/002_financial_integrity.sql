-- REGRAS DE INTEGRIDADE: executar APÓS 001_schema.sql.
-- Cálculo exato de parcelas no próprio PostgreSQL para impedir excesso de pagamentos.
create or replace function public.card_invoice_total(p_card_id uuid,p_month text)
returns numeric language sql stable security invoker set search_path='' as $$
select coalesce(sum((floor(p.amount*100/p.installments) +
 case when s.n < mod(round(p.amount*100)::bigint,p.installments) then 1 else 0 end)/100),0)::numeric(16,2)
from public.card_purchases p
join public.cards c on c.id=p.card_id and c.user_id=p.user_id and c.workspace_id=p.workspace_id
cross join lateral generate_series(0,p.installments-1) as s(n)
where p.card_id=p_card_id
 and to_char((date_trunc('month',p.purchase_date)::date +
 (((case when extract(day from p.purchase_date)>c.closing_day then 1 else 0 end) +
 (case when c.due_day<=c.closing_day then 1 else 0 end) + s.n)::text || ' months')::interval),'YYYY-MM')=p_month;
$$;
create or replace function public.validate_card_payment() returns trigger
language plpgsql security invoker set search_path='' as $$
declare total numeric; already numeric;
begin
 select public.card_invoice_total(new.card_id,new.month_key) into total;
 select coalesce(sum(amount),0) into already from public.card_payments
 where card_id=new.card_id and month_key=new.month_key and id<>new.id;
 if new.amount+already>total+0.001 then raise exception 'Pagamento de fatura maior que o valor em aberto (%).',total-already;end if;
 return new;
end $$;
create trigger prevent_invoice_overpayment before insert or update on public.card_payments
for each row execute function public.validate_card_payment();

-- Aportes/resgates alteram saldo declarado do investimento; desfazer/editar reverte o delta.
create or replace function public.apply_investment_event() returns trigger
language plpgsql security invoker set search_path='' as $$
declare delta numeric;
begin
 if tg_op in ('DELETE','UPDATE') then
  delta:=case when old.kind='contribution' then -old.amount else old.amount end;
  update public.investments set current_value=current_value+delta where id=old.investment_id and user_id=old.user_id;
 end if;
 if tg_op in ('INSERT','UPDATE') then
  delta:=case when new.kind='contribution' then new.amount else -new.amount end;
  update public.investments set current_value=current_value+delta where id=new.investment_id and user_id=new.user_id;
 end if;
 if tg_op='DELETE' then return old;else return new;end if;
end $$;
create trigger investment_balance_effect after insert or update or delete on public.investment_events
for each row execute function public.apply_investment_event();

create unique index if not exists unique_recurring_tx
on public.transactions(user_id,recurrence_parent_id,event_date) where recurrence_parent_id is not null;
create unique index if not exists unique_recurring_task
on public.tasks(user_id,recurrence_parent_id,due_at) where recurrence_parent_id is not null;

-- Gera parcelas de pagamentos recorrentes após login/atualização; idempotente.
-- Cria no máximo 60 por origem para evitar crescimento descontrolado.
create or replace function public.sync_recurring_transactions() returns int
language plpgsql security invoker set search_path='' as $$
declare t record; next_date date; max_date date:=current_date+interval '30 days'; created int:=0; attempts int;
begin
 if auth.uid() is null then raise exception 'Login exigido'; end if;
 for t in select * from public.transactions where user_id=auth.uid() and recurrence<>'none' and recurrence_parent_id is null and status<>'cancelled' loop
  next_date:=t.event_date;attempts:=0;
  loop
   attempts:=attempts+1;
   exit when attempts>60;
   next_date:=case t.recurrence
    when 'daily' then next_date+1
    when 'weekly' then next_date+7
    when 'monthly' then (next_date+interval '1 month')::date
    when 'yearly' then (next_date+interval '1 year')::date
    else max_date+1 end;
   exit when next_date>max_date;
   insert into public.transactions(user_id,workspace_id,description,amount,kind,status,event_date,due_date,account_id,category_id,payment_method,recurrence,recurrence_parent_id,notes)
   values(t.user_id,t.workspace_id,t.description,t.amount,t.kind,'pending',next_date,
    case when t.due_date is not null then next_date + (t.due_date-t.event_date) else null end,
    t.account_id,t.category_id,t.payment_method,'none',t.id,t.notes)
   on conflict do nothing;
   if found then created:=created+1;end if;
  end loop;
 end loop;
 return created;
end $$;
revoke all on function public.sync_recurring_transactions() from public,anon;
grant execute on function public.sync_recurring_transactions() to authenticated;

-- Impede editar/remover compras já pagas se isso fizer a fatura ficar menor que pagamentos registrados.
create or replace function public.validate_invoice_after_purchase_change() returns trigger
language plpgsql security invoker set search_path='' as $$
declare r record;
begin
 for r in
  select card_id,month_key,sum(amount) as paid from public.card_payments
  where card_id in (case when tg_op='INSERT' then new.card_id else old.card_id end,
                    case when tg_op='DELETE' then old.card_id else new.card_id end)
  group by card_id,month_key
 loop
  if r.paid>public.card_invoice_total(r.card_id,r.month_key)+0.001 then
   raise exception 'Alteração de compra deixaria a fatura % paga acima do valor devido.',r.month_key;
  end if;
 end loop;
 if tg_op='DELETE' then return old;else return new;end if;
end $$;
create trigger validate_purchases_and_invoices after insert or update or delete on public.card_purchases
for each row execute function public.validate_invoice_after_purchase_change();
