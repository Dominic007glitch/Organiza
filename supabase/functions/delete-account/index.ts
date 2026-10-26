// Supabase Edge Function: use supabase functions deploy delete-account
import { createClient } from 'npm:@supabase/supabase-js@2'
const cors={ 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type', 'Access-Control-Allow-Methods':'POST, OPTIONS' }
Deno.serve(async req=>{
 if(req.method==='OPTIONS')return new Response('ok',{headers:cors})
 if(req.method!=='POST')return Response.json({error:'Método não permitido'},{status:405,headers:cors})
 try{
  const token=req.headers.get('Authorization')?.replace(/^Bearer\s+/i,'')||''
  const payload=await req.json()
  if(payload.confirm!=='EXCLUIR')return Response.json({error:'Confirmação incorreta'},{status:400,headers:cors})
  const url=Deno.env.get('SUPABASE_URL')!,key=Deno.env.get('SUPABASE_ANON_KEY')!,adminKey=Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  const client=createClient(url,key,{auth:{persistSession:false}})
  const {data,error}=await client.auth.getUser(token)
  if(error||!data.user)return Response.json({error:'Não autorizado'},{status:401,headers:cors})
  const admin=createClient(url,adminKey,{auth:{persistSession:false}})
  // Apagar objetos do próprio usuário antes de excluir o usuário.
  const {data:files}=await admin.storage.from('private-files').list(data.user.id,{limit:1000})
  if(files?.length){const paths=files.map(f=>`${data.user!.id}/${f.name}`);await admin.storage.from('private-files').remove(paths)}
  const {error:deleted}=await admin.auth.admin.deleteUser(data.user.id)
  if(deleted)throw deleted
  return Response.json({ok:true},{headers:cors})
 }catch(e){return Response.json({error:String(e)},{status:500,headers:cors})}
})
