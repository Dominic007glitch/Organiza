import {createClient} from '@supabase/supabase-js'
const url=import.meta.env.VITE_SUPABASE_URL||''
const key=import.meta.env.VITE_SUPABASE_ANON_KEY||''
export const configured=/^https:\/\/[a-z0-9-]+\.supabase\.co$/.test(url)&&key.length>20&&!key.includes('EXEMPLO')
export const supabase=createClient(configured?url:'https://placeholder.supabase.co',configured?key:'public-placeholder-key',{auth:{autoRefreshToken:true,persistSession:true,detectSessionInUrl:true}})
