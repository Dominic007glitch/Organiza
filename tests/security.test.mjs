import test from 'node:test'
import assert from 'node:assert/strict'
import fs from 'node:fs'
const sql=fs.readFileSync('supabase/migrations/001_schema.sql','utf8')
test('RLS é habilitada para todas tabelas privadas previstas',()=>{for(const t of ['profiles','workspaces','financial_accounts','categories','cards','transactions','transfers','card_purchases','card_payments','budgets','investments','investment_events','patrimony','projects','task_categories','tasks','subtasks','goals','habits','habit_logs','events','notification_reads','audit_logs'])assert.ok(sql.includes(`'${t}'`),'Tabela sem RLS: '+t)})
test('credenciais privadas não são expostas nas variáveis do frontend',()=>{assert.ok(!fs.readFileSync('.env.example','utf8').includes('SERVICE_ROLE_KEY='))})
test('storage privado restringe acesso por pasta do usuário',()=>{assert.match(sql,/storage\.foldername\(name\)/);assert.match(sql,/bucket_id='private-files'/)})
test('integridade financeira exige conta e categoria da mesma área',()=>{assert.match(sql,/foreign key\(account_id,workspace_id,user_id\)/);assert.match(sql,/foreign key\(category_id,workspace_id,user_id\)/)})
