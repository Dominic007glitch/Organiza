import React,{createContext,useCallback,useContext,useEffect,useMemo,useState} from 'react'
import type {User} from '@supabase/supabase-js'
import {supabase} from './supabase'
export const TABLES=['profiles','workspaces','financial_accounts','categories','transactions','transfers','cards','card_purchases','card_payments','budgets','investments','investment_events','patrimony','projects','task_categories','tasks','subtasks','goals','habits','habit_logs','events','notification_reads','audit_logs'] as const
export type TableName=typeof TABLES[number]
export type Row=Record<string,any>
type Store={user:User;data:Record<string,Row[]>;loading:boolean;busy:boolean;error:string;workspace:Row|null;setWorkspaceId:(id:string)=>void;workspaceId:string;reload:(table?:TableName)=>Promise<void>;save:(table:TableName,row:Row)=>Promise<Row>;remove:(table:TableName,id:string)=>Promise<void>;upload:(file:File)=>Promise<string>;message:string;setMessage:(message:string)=>void}
const Context=createContext<Store|null>(null)
export const useStore=()=>{const ctx=useContext(Context);if(!ctx)throw new Error('Store não disponível');return ctx}
const sortRows=(rows:Row[])=>rows.sort((a,b)=>String(b.created_at||b.event_date||'').localeCompare(String(a.created_at||a.event_date||'')))
export function StoreProvider({user,children}:{user:User;children:React.ReactNode}){
 const [data,setData]=useState<Record<string,Row[]>>({}),[loading,setLoading]=useState(true),[busy,setBusy]=useState(false)
 const [error,setError]=useState(''),[message,setMessage]=useState(''),[workspaceId,setWorkspaceId]=useState('')
 const fetchTable=useCallback(async(table:TableName)=>{
  if(table==='audit_logs'){
   const {data:rows,error:e}=await supabase.from(table).select('*').order('at',{ascending:false}).limit(120)
   if(e)throw new Error(`${table}: ${e.message}`)
   setData(prev=>({...prev,[table]:sortRows(rows||[])}));return
  }
  let rows:Row[]=[];for(let from=0;from<5000;from+=500){const {data:part,error:e}=await supabase.from(table).select('*').range(from,from+499)
   if(e)throw new Error(`${table}: ${e.message}`)
   rows.push(...(part||[]));if((part||[]).length<500)break
  }
  setData(prev=>({...prev,[table]:sortRows(rows)}))
 },[])
 const reload=useCallback(async(table?:TableName)=>{
  try{setError('');if(table)await fetchTable(table);else{setLoading(true);const {error:repeatError}=await supabase.rpc('sync_recurring_transactions');if(repeatError)setError('Confira a migração 002_financial_integrity.sql: '+repeatError.message);const result=await Promise.allSettled(TABLES.map(fetchTable));const bad=result.filter(x=>x.status==='rejected') as PromiseRejectedResult[];if(bad.length)setError(bad.slice(0,2).map(x=>String(x.reason)).join(' • '))}}
  catch(e:any){setError(e.message||'Falha de conexão')}finally{setLoading(false)}
 },[fetchTable])
 useEffect(()=>{reload()},[reload,user.id])
 const save=useCallback(async(table:TableName,row:Row)=>{
  setBusy(true);try{
   const payload={...row};Object.keys(payload).forEach(k=>payload[k]===undefined&&delete payload[k]);
   const existing=Boolean(payload.id);const request=existing?supabase.from(table).update(payload).eq('id',payload.id):supabase.from(table).insert({...payload,...(table==='profiles'?{}:table==='workspaces'?{owner_id:user.id}:{user_id:user.id})});
   const {data:result,error:e}=await request.select('*').single();if(e)throw new Error(e.message);
   setData(prev=>({...prev,[table]:sortRows([result,...(prev[table]||[]).filter(x=>x.id!==result.id)])}));if(table==='investment_events')await fetchTable('investments');setMessage(existing?'Alterações salvas.':'Registro criado com sucesso.');return result
  }catch(e:any){setError(e.message);throw e}finally{setBusy(false)}
 },[user.id,fetchTable])
 const remove=useCallback(async(table:TableName,id:string)=>{
  setBusy(true);try{const {error:e}=await supabase.from(table).delete().eq('id',id);if(e)throw new Error(e.message);
   setData(prev=>({...prev,[table]:(prev[table]||[]).filter(x=>x.id!==id)}));if(table==='investment_events')await fetchTable('investments');setMessage('Registro excluído.')
  }catch(e:any){setError(e.message);throw e}finally{setBusy(false)}
 },[fetchTable])
 const upload=useCallback(async(file:File)=>{if(!['image/jpeg','image/png','application/pdf'].includes(file.type)||file.size>5*1024*1024)throw new Error('Use PNG, JPG ou PDF de até 5 MB.');const path=`${user.id}/${crypto.randomUUID()}-${file.name.replace(/[^a-zA-Z0-9._-]/g,'_')}`;const {error:e}=await supabase.storage.from('private-files').upload(path,file,{upsert:false});if(e)throw new Error(e.message);return path},[user.id])
 const spaces=data.workspaces||[];const chosen=spaces.find(x=>x.id===workspaceId)||spaces.find(x=>x.kind==='personal')||spaces[0]||null
 const value=useMemo(()=>({user,data,loading,busy,error,workspace:chosen,workspaceId:chosen?.id||'',setWorkspaceId,reload,save,remove,upload,message,setMessage}),[user,data,loading,busy,error,chosen,reload,save,remove,upload,message])
 return <Context.Provider value={value}>{children}</Context.Provider>
}
