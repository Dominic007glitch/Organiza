import test from 'node:test'
import assert from 'node:assert/strict'
import {investmentProjection,installmentSchedule,accountBalance,periodEntries,financialTotals,addMonths,pct,dailyRange,recursOnDate} from '../src/lib/finance.ts'
test('juros compostos sem aportes',()=>{const c=investmentProjection(1000,0,10,12,'annual');assert.ok(Math.abs(c.total-1100)<.01);assert.ok(Math.abs(c.interest-100)<.01)})
test('com depósitos mensal no fim do mês',()=>{const c=investmentProjection(0,100,0,12,'annual');assert.equal(c.total,1200);assert.equal(c.contributed,1200)})
test('parcela divide centavos sem perda de precisão',()=>{const a=installmentSchedule({amount:100,installments:3,purchase_date:'2026-01-03'},{closing_day:10,due_day:17});assert.deepEqual(a.map(x=>x.amount),[33.34,33.33,33.33]);assert.equal(a.reduce((s,x)=>s+x.amount,0).toFixed(2),'100.00')})
test('compra após fechamento vai para mês seguinte',()=>{const a=installmentSchedule({amount:120,installments:2,purchase_date:'2026-01-12'},{closing_day:10,due_day:17});assert.equal(a[0].month_key,'2026-02');assert.equal(a[1].month_key,'2026-03')})
test('vencimento anterior ao fechamento atrasa mês',()=>{const a=installmentSchedule({amount:100,installments:1,purchase_date:'2026-01-01'},{closing_day:10,due_day:5});assert.equal(a[0].month_key,'2026-02')})
test('transferências não são renda/despesa e saldos se compensam',()=>{const accounts=[{id:'a',initial_balance:1000},{id:'b',initial_balance:0}];const transfers=[{from_account_id:'a',to_account_id:'b',amount:350}];const balances=accounts.map(a=>accountBalance(a,[],transfers,[]));assert.deepEqual(balances,[650,350]);assert.equal(balances.reduce((a,b)=>a+b,0),1000)})
test('pagamentos de fatura reduzem dinheiro em conta só no pagamento',()=>{const cardPayments=[{account_id:'a',amount:250}];assert.equal(accountBalance({id:'a',initial_balance:1000},[],[],cardPayments),750)})
test('conta pendente não reduz saldo',()=>{const transactions=[{account_id:'a',status:'pending',amount:50,kind:'expense'},{account_id:'a',status:'paid',amount:20,kind:'expense'}];assert.equal(accountBalance({id:'a',initial_balance:100},transactions,[],[]),80)})
test('parcelas contam no período do mês e não à vista',()=>{const purchases=[{amount:100,installments:2,purchase_date:'2026-01-05',card_id:'card',category_id:'cat'}];const cards=[{id:'card',closing_day:10,due_day:20}];const jan=periodEntries([],purchases,cards,'2026-01-01','2026-01-31');const feb=periodEntries([],purchases,cards,'2026-02-01','2026-02-28');assert.equal(financialTotals(jan).expense,50);assert.equal(financialTotals(feb).expense,50)})
test('meses atravessam o ano corretamente',()=>{assert.equal(addMonths('2026-12-20',2),'2027-02')})
test('porcentagem de total zero é zero',()=>{assert.equal(pct(0,0),0)})
test('período mensal retorna mês inteiro',()=>{assert.deepEqual(dailyRange('month','2026-02-20'),['2026-02-01','2026-02-28'])})

test('recorrência semanal de eventos ocorre na mesma data da semana',()=>{assert.equal(recursOnDate('2026-10-05T12:00:00','weekly','2026-10-12'),true);assert.equal(recursOnDate('2026-10-05T12:00:00','weekly','2026-10-13'),false)})
