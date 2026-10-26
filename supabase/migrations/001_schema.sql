-- OrbisOS 1.0 • Execute integralmente no SQL Editor (uma única vez).
-- NÃO use service_role no frontend. Todas as tabelas de usuário possuem RLS.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 full_name text not null default '', theme text not null default 'dark' check(theme in ('dark','light')),
 accent text not null default '#00d6a0', avatar_url text,
 widget_visibility jsonb not null default '{}'::jsonb,
 notification_settings jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.workspaces (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 name text not null, kind text not null check(kind in ('personal','business')),
 cnpj text, sector text, description text, logo_url text, currency text not null default 'BRL',
 created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 unique(id,owner_id)
);
create unique index if not exists unique_personal_space on public.workspaces(owner_id) where kind='personal';

-- Os dados abaixo são privados e sempre vinculados a um espaço de titular único.
create table if not exists public.financial_accounts (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null, name text not null, institution text, kind text not null default 'corrente',
 initial_balance numeric(16,2) not null default 0,color text default '#00d6a0', icon text default 'wallet',archived boolean not null default false,
 created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 unique(id,workspace_id,user_id),foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade
);
create table if not exists public.categories (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null,name text not null,kind text not null check(kind in ('income','expense')),
 color text not null default '#8b84f7',icon text default 'tag', parent_id uuid,monthly_limit numeric(16,2),archived boolean not null default false,
 created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 unique(id,workspace_id,user_id),foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade,
 foreign key(parent_id,workspace_id,user_id) references public.categories(id,workspace_id,user_id)
);
create table if not exists public.cards (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null, name text not null,institution text, card_limit numeric(16,2) not null default 0,
 closing_day int not null default 10 check(closing_day between 1 and 28), due_day int not null default 17 check(due_day between 1 and 28),
 color text not null default '#8175ff',archived boolean not null default false,created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 unique(id,workspace_id,user_id),foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade
);
create table if not exists public.transactions (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null, description text not null, amount numeric(16,2) not null check(amount > 0),
 kind text not null check(kind in ('income','expense')), status text not null default 'paid' check(status in ('paid','pending','cancelled')),
 event_date date not null default current_date, due_date date,account_id uuid,category_id uuid,
 payment_method text default 'outro', recurrence text not null default 'none' check(recurrence in ('none','daily','weekly','monthly','yearly')),
 recurrence_parent_id uuid,notes text,attachment_path text,import_ref text,created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 unique(id,workspace_id,user_id),foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade,
 foreign key(account_id,workspace_id,user_id) references public.financial_accounts(id,workspace_id,user_id),
 foreign key(category_id,workspace_id,user_id) references public.categories(id,workspace_id,user_id)
);
create unique index if not exists unique_transaction_import on public.transactions(workspace_id,import_ref) where import_ref is not null;
create table if not exists public.transfers (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null,from_account_id uuid not null,to_account_id uuid not null,amount numeric(16,2) not null check(amount>0),
 event_date date not null default current_date,notes text,created_at timestamptz not null default now(),
 foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade,
 foreign key(from_account_id,workspace_id,user_id) references public.financial_accounts(id,workspace_id,user_id),
 foreign key(to_account_id,workspace_id,user_id) references public.financial_accounts(id,workspace_id,user_id),
 check(from_account_id<>to_account_id)
);
create table if not exists public.card_purchases (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null, card_id uuid not null,category_id uuid,description text not null,amount numeric(16,2) not null check(amount>0),
 installments int not null default 1 check(installments between 1 and 120),purchase_date date not null default current_date,
 notes text,created_at timestamptz not null default now(),
 foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade,
 foreign key(card_id,workspace_id,user_id) references public.cards(id,workspace_id,user_id),
 foreign key(category_id,workspace_id,user_id) references public.categories(id,workspace_id,user_id)
);
create table if not exists public.card_payments (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null,card_id uuid not null,account_id uuid not null,month_key text not null check(month_key ~ '^\d{4}-\d{2}$'),
 amount numeric(16,2) not null check(amount>0),paid_at date not null default current_date,created_at timestamptz not null default now(),
 foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade,
 foreign key(card_id,workspace_id,user_id) references public.cards(id,workspace_id,user_id),
 foreign key(account_id,workspace_id,user_id) references public.financial_accounts(id,workspace_id,user_id)
);
create table if not exists public.budgets (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null,category_id uuid not null,month_key text not null check(month_key ~ '^\d{4}-\d{2}$'),
 amount numeric(16,2) not null check(amount>0),created_at timestamptz not null default now(),
 unique(workspace_id,category_id,month_key),foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade,
 foreign key(category_id,workspace_id,user_id) references public.categories(id,workspace_id,user_id)
);
create table if not exists public.investments (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null,name text not null,kind text not null default 'outros',institution text,
 initial_amount numeric(16,2) not null default 0,current_value numeric(16,2) not null default 0,
 applied_at date default current_date,notes text,created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 unique(id,workspace_id,user_id),foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade
);
create table if not exists public.investment_events (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null,investment_id uuid not null,kind text not null check(kind in ('contribution','redemption')),
 amount numeric(16,2) not null check(amount>0),event_date date not null default current_date,notes text,
 created_at timestamptz not null default now(),foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade,
 foreign key(investment_id,workspace_id,user_id) references public.investments(id,workspace_id,user_id)
);
create table if not exists public.patrimony (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null,name text not null,kind text not null check(kind in ('asset','liability')),
 category text default 'outros',value numeric(16,2) not null default 0,notes text,updated_at timestamptz not null default now(),created_at timestamptz not null default now(),
 foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade
);
-- Projetos e planejamento pessoal.
create table if not exists public.projects (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 name text not null,color text not null default '#8c78fc',description text,archived boolean not null default false,created_at timestamptz not null default now(),
 unique(id,user_id)
);
create table if not exists public.task_categories (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 name text not null,color text default '#9a86ff',created_at timestamptz not null default now(),unique(id,user_id)
);
create table if not exists public.tasks (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 title text not null,description text,priority text not null default 'medium' check(priority in ('low','medium','high','urgent')),
 status text not null default 'pending' check(status in ('pending','in_progress','completed','cancelled')),
 due_at timestamptz,start_at timestamptz,project_id uuid,category_id uuid,
 recurrence text not null default 'none' check(recurrence in ('none','daily','weekly','monthly','yearly')),
 recurrence_parent_id uuid,notes text,completed_at timestamptz,created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 unique(id,user_id),foreign key(project_id,user_id) references public.projects(id,user_id),
 foreign key(category_id,user_id) references public.task_categories(id,user_id)
);
create table if not exists public.subtasks (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 task_id uuid not null,title text not null,completed boolean not null default false,created_at timestamptz not null default now(),
 foreign key(task_id,user_id) references public.tasks(id,user_id) on delete cascade
);
create table if not exists public.goals (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 workspace_id uuid not null,title text not null,description text,kind text not null default 'personal' check(kind in ('personal','financial')),
 target numeric(16,2) not null default 1 check(target>0),progress numeric(16,2) not null default 0,
 unit text not null default 'un',due_date date,category text, linked_account_id uuid,
 color text not null default '#14d6a3',created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 foreign key(workspace_id,user_id) references public.workspaces(id,owner_id) on delete cascade,
 foreign key(linked_account_id,workspace_id,user_id) references public.financial_accounts(id,workspace_id,user_id)
);
create table if not exists public.habits (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 title text not null,frequency text not null default 'daily' check(frequency in ('daily','weekly')),
 target_weekly int not null default 7 check(target_weekly between 1 and 7),color text not null default '#8c78fc',
 archived boolean not null default false,created_at timestamptz not null default now(),unique(id,user_id)
);
create table if not exists public.habit_logs (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 habit_id uuid not null,log_date date not null default current_date,created_at timestamptz not null default now(),
 unique(habit_id,log_date),foreign key(habit_id,user_id) references public.habits(id,user_id) on delete cascade
);
create table if not exists public.events (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 title text not null,description text,start_at timestamptz not null,end_at timestamptz,
 color text not null default '#ef88d0',recurrence text not null default 'none' check(recurrence in ('none','daily','weekly','monthly','yearly')),
 created_at timestamptz not null default now()
);
create table if not exists public.notification_reads (
 id uuid primary key default gen_random_uuid(),user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 alert_key text not null,read_at timestamptz not null default now(),unique(user_id,alert_key)
);
create table if not exists public.audit_logs (
 id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,
 entity text not null,entity_id uuid,action text not null,at timestamptz not null default now()
);

-- Segurança: RLS obrigatório para toda tabela, sem tabelas públicas com dados privados.
do $$ declare t text; begin
 foreach t in array array['profiles','workspaces','financial_accounts','categories','cards','transactions','transfers','card_purchases','card_payments','budgets','investments','investment_events','patrimony','projects','task_categories','tasks','subtasks','goals','habits','habit_logs','events','notification_reads','audit_logs'] loop
 execute format('alter table public.%I enable row level security',t);
 if t='profiles' then
  execute format('create policy "own_select" on public.%I for select to authenticated using (id = (select auth.uid()))',t);
  execute format('create policy "own_insert" on public.%I for insert to authenticated with check (id = (select auth.uid()))',t);
  execute format('create policy "own_update" on public.%I for update to authenticated using (id = (select auth.uid())) with check (id = (select auth.uid()))',t);
 elsif t='workspaces' then
  execute format('create policy "own_select" on public.%I for select to authenticated using (owner_id = (select auth.uid()))',t);
  execute format('create policy "own_insert" on public.%I for insert to authenticated with check (owner_id = (select auth.uid()))',t);
  execute format('create policy "own_update" on public.%I for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()))',t);
  execute format('create policy "own_delete" on public.%I for delete to authenticated using (owner_id = (select auth.uid()) and kind = ''business'')',t);
 else
  execute format('create policy "own_select" on public.%I for select to authenticated using (user_id = (select auth.uid()))',t);
  if t <> 'audit_logs' then
   execute format('create policy "own_insert" on public.%I for insert to authenticated with check (user_id = (select auth.uid()))',t);
   execute format('create policy "own_update" on public.%I for update to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()))',t);
   execute format('create policy "own_delete" on public.%I for delete to authenticated using (user_id = (select auth.uid()))',t);
  end if;
 end if;
 end loop;
end $$;

create or replace function public.on_new_user() returns trigger language plpgsql security definer set search_path = '' as $$
begin
 insert into public.profiles(id,full_name) values(new.id,coalesce(new.raw_user_meta_data->>'full_name','')) on conflict do nothing;
 insert into public.workspaces(owner_id,name,kind) values(new.id,'Minhas finanças','personal') on conflict do nothing;
 return new;
end $$;
drop trigger if exists new_user_setup on auth.users;
create trigger new_user_setup after insert on auth.users for each row execute function public.on_new_user();
-- Perfis para usuários criados antes desta migração.
insert into public.profiles(id,full_name) select id,coalesce(raw_user_meta_data->>'full_name','') from auth.users on conflict do nothing;
insert into public.workspaces(owner_id,name,kind) select id,'Minhas finanças','personal' from auth.users on conflict do nothing;

create or replace function public.touch_update() returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at=now();return new;end $$;
do $$ declare t text; begin
 foreach t in array array['profiles','workspaces','financial_accounts','categories','cards','transactions','investments','patrimony','tasks','goals'] loop
 execute format('create trigger touch_modified before update on public.%I for each row execute function public.touch_update()',t);
 end loop;
end $$;

-- Auditoria mínima. Função SECURITY DEFINER para que usuários não possam falsificar logs.
create or replace function public.log_user_action() returns trigger language plpgsql security definer set search_path = '' as $$
begin
 if tg_op = 'DELETE' then
  -- Cascata de exclusão de conta: o usuário já pode ter sido removido de auth.users.
  if exists (select 1 from auth.users where id=old.user_id) then
   insert into public.audit_logs(user_id,entity,entity_id,action) values(old.user_id,tg_table_name,old.id,tg_op);
  end if;
  return old;
 else
  insert into public.audit_logs(user_id,entity,entity_id,action) values(new.user_id,tg_table_name,new.id,tg_op);
  return new;
 end if;
end $$;
do $$ declare t text; begin
 foreach t in array array['transactions','tasks','transfers','card_purchases','card_payments','investments','goals','habits'] loop
 execute format('create trigger log_action after insert or update or delete on public.%I for each row execute function public.log_user_action()',t);
 end loop;
end $$;

create index if not exists ix_transactions_period on public.transactions(workspace_id,event_date desc);
create index if not exists ix_transactions_due on public.transactions(user_id,status,due_date);
create index if not exists ix_card_purchases on public.card_purchases(card_id,purchase_date desc);
create index if not exists ix_tasks_due on public.tasks(user_id,due_at);
create index if not exists ix_habits_day on public.habit_logs(user_id,log_date);
create index if not exists ix_audit_user_at on public.audit_logs(user_id,at desc);
create index if not exists ix_goals_workspace on public.goals(workspace_id);
create index if not exists ix_accounts_workspace on public.financial_accounts(workspace_id);

-- Um usuário autenticado só vê dados de sua própria conta e espaços.
-- Armazenamento de anexos usa uma pasta cujo primeiro segmento é auth.uid().
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
 values ('private-files','private-files',false,5242880,array['image/png','image/jpeg','application/pdf'])
 on conflict (id) do nothing;
create policy "Private file read" on storage.objects for select to authenticated
 using(bucket_id='private-files' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "Private file upload" on storage.objects for insert to authenticated
 with check(bucket_id='private-files' and (storage.foldername(name))[1]=(select auth.uid())::text);
create policy "Private file delete" on storage.objects for delete to authenticated
 using(bucket_id='private-files' and (storage.foldername(name))[1]=(select auth.uid())::text);
