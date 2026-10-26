/* Funções puras: nenhum dado simulado; valores vêm das tabelas Supabase. */
export type Entry = {amount?:number|string;kind?:string;status?:string;event_date?:string;account_id?:string;category_id?:string;due_date?:string}
export const asNumber=(v:unknown)=>Number(v||0)
export const money=(v:unknown)=>new Intl.NumberFormat('pt-BR',{style:'currency',currency:'BRL'}).format(asNumber(v))
export const pct=(v:number,d:number)=>d>0?Math.round(v/d*100):0
export const monthOf=(d:string)=>String(d||'').slice(0,7)
export const todayLocal=()=>{const d=new Date();return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`}
export function addMonths(d:string,n:number){const [y,m]=d.slice(0,7).split('-').map(Number);const next=new Date(Date.UTC(y,m-1+n,1));return `${next.getUTCFullYear()}-${String(next.getUTCMonth()+1).padStart(2,'0')}`}
export function addInterval(date:string,repeat:string){const d=new Date(`${date.slice(0,10)}T12:00:00Z`);if(repeat==='daily')d.setUTCDate(d.getUTCDate()+1);else if(repeat==='weekly')d.setUTCDate(d.getUTCDate()+7);else if(repeat==='monthly')d.setUTCMonth(d.getUTCMonth()+1);else if(repeat==='yearly')d.setUTCFullYear(d.getUTCFullYear()+1);return d.toISOString().slice(0,10)}
export function investmentProjection(initial:number,monthly:number,rate:number,months:number,rateType:'monthly'|'annual'='annual'){
 const r=rateType==='annual'?Math.pow(1+rate/100,1/12)-1:rate/100;let balance=initial;const points=[{month:0,balance,invested:initial}];
 for(let i=1;i<=months;i++){balance=balance*(1+r)+monthly;points.push({month:i,balance,invested:initial+monthly*i})}
 return {total:balance,contributed:initial+monthly*months,interest:balance-initial-monthly*months,points}
}
export function installmentSchedule(purchase:{amount?:number|string;installments?:number;purchase_date?:string},card:{closing_day?:number;due_day?:number}){
 const count=Math.max(1,Number(purchase.installments||1));const cents=Math.round(asNumber(purchase.amount)*100);
 const base=Math.floor(cents/count);const remainder=cents-base*count;
 const purchased=new Date(`${(purchase.purchase_date||todayLocal()).slice(0,10)}T12:00:00Z`);
 let offset=purchased.getUTCDate()>Number(card.closing_day)?1:0;
 if(Number(card.due_day)<=Number(card.closing_day))offset+=1;
 return Array.from({length:count},(_,i)=>({month_key:addMonths(purchase.purchase_date||todayLocal(),offset+i),amount:(base+(i<remainder?1:0))/100,part:i+1,total:count}))
}
export function accountBalance(account:{id?:string;initial_balance?:number|string},transactions:Entry[],transfers:any[],cardPayments:any[]){
 let value=asNumber(account.initial_balance);
 for(const t of transactions)if(t.status==='paid'&&t.account_id===account.id)value+=(t.kind==='income'?1:-1)*asNumber(t.amount);
 for(const t of transfers){if(t.from_account_id===account.id)value-=asNumber(t.amount);if(t.to_account_id===account.id)value+=asNumber(t.amount)}
 for(const p of cardPayments)if(p.account_id===account.id)value-=asNumber(p.amount);
 return Math.round(value*100)/100
}
export function periodEntries(transactions:Entry[],purchases:any[],cards:any[],start:string,end:string){
 const direct=transactions.filter(t=>t.status==='paid'&&(t.event_date||'')>=start&&(t.event_date||'')<=end).map(t=>({...t,amount:asNumber(t.amount)}));
 const fromCards=purchases.flatMap(p=>{const c=cards.find(x=>x.id===p.card_id);return c?installmentSchedule(p,c).filter(x=>x.month_key>=start.slice(0,7)&&x.month_key<=end.slice(0,7)).map(x=>({...p,kind:'expense',status:'paid',amount:x.amount,event_date:`${x.month_key}-01`,description:`${p.description} (${x.part}/${x.total})`})) : []});
 return [...direct,...fromCards]
}
export function financialTotals(rows:Entry[]){return rows.reduce((a,t)=>{if(t.kind==='income')a.income+=asNumber(t.amount);else if(t.kind==='expense')a.expense+=asNumber(t.amount);return a},{income:0,expense:0})}
export function dailyRange(mode:string,base=todayLocal()){
 const d=new Date(`${base}T12:00:00Z`),y=d.getUTCFullYear(),m=d.getUTCMonth();
 const fmt=(x:Date)=>x.toISOString().slice(0,10);
 if(mode==='today')return [base,base];if(mode==='week'){const mon=(d.getUTCDay()+6)%7;d.setUTCDate(d.getUTCDate()-mon);const s=fmt(d);d.setUTCDate(d.getUTCDate()+6);return [s,fmt(d)]}
 if(mode==='year')return [`${y}-01-01`,`${y}-12-31`];if(mode==='last30'){d.setUTCDate(d.getUTCDate()-29);return [fmt(d),base]};return [`${y}-${String(m+1).padStart(2,'0')}-01`,fmt(new Date(Date.UTC(y,m+1,0)))]
}

export function recursOnDate(startISO:string,repeat:string,date:string){
 const origin=startISO.slice(0,10);if(date<origin)return false;if(date===origin)return true;
 if(repeat==='none'||!repeat)return false;
 const [y,m,d]=date.split('-').map(Number),[oy,om,od]=origin.split('-').map(Number)
 if(repeat==='daily')return true;
 if(repeat==='weekly')return (Date.UTC(y,m-1,d)-Date.UTC(oy,om-1,od))%604800000===0;
 if(repeat==='monthly')return d===od;
 if(repeat==='yearly')return d===od&&m===om;
 return false;
}
