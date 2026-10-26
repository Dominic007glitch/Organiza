import React,{useEffect,useState} from 'react'
import {supabase} from '../lib/supabase'
export function ProfileAvatar({path,name,className='top-avatar'}:{path?:string|null;name:string;className?:string}){
 const [src,setSrc]=useState('')
 useEffect(()=>{let alive=true;if(!path){setSrc('');return}supabase.storage.from('private-files').createSignedUrl(path,3600).then(({data})=>{if(alive)setSrc(data?.signedUrl||'')});return()=>{alive=false}},[path])
 return src?<img src={src} alt={`Foto de ${name}`} className={className+' avatar-img'}/>:<span className={className}>{(name||'U').slice(0,1).toUpperCase()}</span>
}
