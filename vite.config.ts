import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { VitePWA } from 'vite-plugin-pwa'
import appConfig from './app.config.json'
export default defineConfig({ plugins: [react(), VitePWA({registerType:'prompt',includeAssets:['favicon.svg','icons/icon-180.png'],manifest:{name:`${appConfig.name} — ${appConfig.tagline}`,short_name:appConfig.shortName,description:'Finanças, metas e tarefas num só lugar',start_url:'/',scope:'/',display:'standalone',orientation:'any',background_color:'#080913',theme_color:appConfig.themeColor,lang:'pt-BR',icons:[{src:'/icons/icon-192.png',sizes:'192x192',type:'image/png',purpose:'any maskable'},{src:'/icons/icon-512.png',sizes:'512x512',type:'image/png',purpose:'any maskable'}]},workbox:{globPatterns:['**/*.{js,css,html,svg,png,ico,woff2}'],navigateFallback:'/index.html',navigateFallbackDenylist:[/^\/auth\/callback/],runtimeCaching:[],cleanupOutdatedCaches:true,skipWaiting:false,clientsClaim:true}})]})
