# Orbis — Gerenciamento pessoal, financeiro e empresarial

Projeto web em **React + TypeScript + Vite**, com dados privados no **Supabase**, publicação pela **Vercel**, desenvolvimento no **VS Code** e instalação como **PWA**. Não depende de Firebase, servidor Node em produção nem APIs financeiras externas. Inclui duas imagens originais de referência em `referencias/` e seus respectivos dashboards implementados em React/CSS (não imagens estáticas).

> **ATENÇÃO:** este pacote contém o **código-fonte**, não uma implantação configurada ou um `dist/` já compilado. É necessário conectar seu próprio projeto Supabase, instalar as dependências e realizar os testes finais. Não há credenciais reais incluídas. Consulte `STATUS_DA_ENTREGA.md` para os limites conhecidos.

## 1. Requisitos

- VS Code e terminal integrado (Windows PowerShell funciona).
- Node.js 22 LTS ou compatível, com npm.
- Conta no Supabase e conta na Vercel.
- Conexão com internet para executar `npm install` e acessar o Supabase.

Não é necessário instalar PostgreSQL nem configurar um servidor backend. O Supabase fornece banco, autenticação e Storage.

## 2. Abrir e instalar

1. Descompacte o ZIP e abra **a pasta `OrbisOS`** no VS Code.
2. No terminal da pasta (a mesma que contém `package.json`):

```powershell
npm install
```

3. Verifique que existe a pasta `node_modules` após instalar.

Não rode `npm audit fix --force` automaticamente: pode atualizar pacotes com alterações incompatíveis. Analise os avisos antes de modificar dependências.

## 3. Criar o projeto Supabase

1. Acesse https://supabase.com/dashboard e crie um projeto.
2. Aguarde o banco estar ativo.
3. Abra **SQL Editor** → **New query**.
4. Cole TODO o conteúdo de `supabase/migrations/001_schema.sql` e execute (**Run**).
5. Em outra query, cole TODO o conteúdo de `supabase/migrations/002_financial_integrity.sql` e execute.
6. Confirme em **Table Editor** que aparecem, entre outras, as tabelas `profiles`, `workspaces`, `financial_accounts`, `transactions`, `tasks`, `habits` e `goals`.
7. Em **Database → Policies**, confirme que o RLS está ativado nas tabelas criadas.

**Execute 001 antes de 002.** As migrações são preparadas para uma **instalação nova**, não para reexecução arbitrária nem substituição sobre tabelas antigas. Se houver erro de SQL, interrompa, salve a mensagem exata e corrija antes de usar o app. Não desative RLS para contornar erros.

### Login e e-mails

No projeto Supabase, abra **Authentication → Providers → Email**. Habilite cadastro por email/senha e decida se deseja confirmação de e-mail (recomendado). Em **Authentication → URL Configuration**:

- **Site URL** para desenvolvimento: `http://localhost:5173`.
- **Redirect URLs**: inclua `http://localhost:5173/**` e posteriormente `https://SEU-DOMINIO.vercel.app/**`.
- Ao entrar em produção, troque o Site URL pelo domínio definitivo.

O cadastro cria automaticamente `profiles` e um espaço financeiro `personal` por meio do gatilho `on_new_user`. **Não cadastre senhas diretamente nas tabelas SQL.** Crie contas pela interface ou por **Authentication → Users**.

O envio de emails pelo serviço de autenticação depende das configurações e limites do projeto Supabase; em produção configure a entrega conforme as opções disponíveis no seu plano.

## 4. Configuração de ambiente

Em **Project Settings → API / API Keys**, copie:

- URL do projeto: `https://seu-id-de-projeto.supabase.co`
- Chave **publishable / pública** (`sb_publishable_...`) ou chave `anon` legada.

**Importante:** `https://supabase.com/dashboard/project/...` é um endereço do painel, NÃO serve para `VITE_SUPABASE_URL`.

Na pasta do projeto, faça cópia do arquivo `.env.example` com o nome `.env.local`. Preencha:

```env
VITE_SUPABASE_URL=https://seu-projeto.supabase.co
VITE_SUPABASE_ANON_KEY=sb_publishable_SUA_CHAVE_PUBLICA
```

**Nunca** use `service_role`, chave secreta nem senha do banco em variáveis `VITE_`. Arquivos `.env.local` estão excluídos no `.gitignore`.

## 5. Rodar no VS Code

```powershell
npm run dev
```

Abra http://localhost:5173. Para abrir em outros aparelhos na mesma rede, o Vite usa `--host`, mas isso não fornece HTTPS; o teste de instalação PWA deve ser feito na Vercel com HTTPS, ou em `localhost`.

Para parar o servidor pressione Ctrl+C. Se mudar `.env.local`, pare e execute `npm run dev` novamente.

**Teste de duas contas:** crie uma conta A e outra B com emails diferentes. Cadastre transações em A; saia e entre em B. B não deve enxergar nem editar registros de A. O controle efetivo está nas políticas RLS do SQL, não apenas nas telas.

## 6. Publicar na Vercel

1. Envie esta pasta para um repositório Git privado ou importe o projeto pelo fluxo suportado da Vercel.
2. **Framework Preset:** Vite.
3. **Root Directory:** pasta com `package.json` (normalmente raiz).
4. **Build Command:** `npm run build`.
5. **Output Directory:** `dist`.
6. Crie as variáveis de ambiente `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY` com os valores públicos do Supabase.
7. Publique e abra a URL HTTPS gerada.
8. Configure o domínio final no Supabase **Authentication → URL Configuration**.
9. Faça uma nova implantação se alterar variáveis de ambiente de build.

`vercel.json` contém a regra de fallback da aplicação de página única, cabeçalhos básicos e não deve interceptar os arquivos do service worker, ícones e assets.

### PWA / ícone na tela inicial

O arquivo `vite.config.ts` configura `vite-plugin-pwa`, `manifest.webmanifest` no build, cache do **shell estático** e atualização controlada do service worker. Ícones personalizados estão em `public/icons/` nos tamanhos 180, 192 e 512 px.

- **Android com Chrome/Edge compatível:** abra URL HTTPS → menu ⋮ → **Instalar aplicativo** / **Adicionar à tela inicial**.
- **iPhone/iPad no Safari:** abra o site → Compartilhar → **Adicionar à Tela de Início**.
- **Desktop Chrome/Edge:** procure a opção Instalar no menu/endereço.
- O botão flutuante com ícone de celular exibe instalação quando o browser oferece o evento `beforeinstallprompt`; caso contrário mostra instruções. O app não afirma instalação sem confirmação do navegador.
- Ao abrir o atalho: a sessão válida é restaurada ou o login é exibido.
- O service worker armazena **somente recursos estáticos** e o shell da aplicação: não guarda respostas de `/rest/v1`, dados financeiros, tokens, senhas nem arquivos privados da conta. Gravações no Supabase exigem internet.
- Teste em aparelho real; disponibilidade e aparência do recurso dependem do navegador/sistema.

## 7. Excluir conta pelo próprio site (Edge Function opcional)

A função de exclusão foi preparada em `supabase/functions/delete-account/index.ts`, mas precisa de **deploy separado**. Faça via **Supabase → Edge Functions → Deploy a new function → Via Editor**, nome **`delete-account`**, e cole o conteúdo do arquivo. Também é possível usar Supabase CLI no terminal do VS Code. Confirme que a função exige um JWT válido e responda somente ao titular que pediu a exclusão. O arquivo já verifica o token e a palavra `EXCLUIR`, apaga arquivos conhecidos do Storage e chama `auth.admin.deleteUser`, cujos relacionamentos no SQL possuem `ON DELETE CASCADE`.

Não coloque `SUPABASE_SERVICE_ROLE_KEY` no frontend nem em Vercel: essa chave só é acessada dentro do runtime protegido de Edge Functions. Se a função não estiver implantada, a tela de exclusão avisará que falhou; NÃO considera a conta excluída.

## 8. Organizar a plataforma

- Após o login há duas opções: **Gerenciamento Financeiro** e **Tarefas e Metas**.
- Financeiro → **Visão geral**: patrimônio, receitas, despesas, taxa de economia, gráfico de fluxo, gráfico de rosca, registros e metas.
- Financeiro → **Transações**: receitas/despesas com status, categoria, recorrência e comprovante privado.
- Financeiro → **Contas**: conta inicial, saldos por movimentações pagas e transferências, faturas pagas.
- Financeiro → **Cartões**: compras parceladas, competência, faturas e baixa de pagamento.
- Financeiro → **Categorias/Orçamentos**: limites mensais e alertas por percentual.
- Financeiro → **Investimentos**: saldo declarado, eventos de aporte/resgate, simulador de juros compostos.
- Financeiro → **Patrimônio**: ativos, passivos, cálculo de patrimônio líquido sem duplicidade intencional.
- Financeiro → **Empresas**: crie empresas, selecione no menu superior e registre em espaço separado.
- Financeiro → **Relatórios**: gráfico anual, tabela, CSV e opção de imprimir/salvar PDF.
- Financeiro → **Importar CSV**: visualização de 500 linhas, validação, hash anti-duplicação e importação em blocos.
- Tarefas → **Meu painel**: agenda semanal, lista e quadro Kanban com drag-and-drop e alternativa por seleção.
- Tarefas → **Tarefas**: edição, prioridades, prazos, projetos, subtarefas e recorrência ao concluir.
- Tarefas → **Calendário**: eventos, metas, prazos e pagamentos previstos.
- Tarefas → **Hábitos, Metas e Produtividade**: registros, marcação diária, barras e indicadores.
- Menu superior: pesquisa geral, alertas e configurações de usuário.

### Precisão financeira

- Valores monetários são persistidos como `numeric(16,2)` no PostgreSQL; o navegador converte em `Number` para gráficos e apresentação.
- Despesas pagas sem uma conta definida entram nos gráficos, mas não reduzem saldos de nenhuma conta. Para acompanhar o saldo, escolha a conta.
- Transferências nunca entram como receita ou despesa comum.
- Compras no crédito entram nas **despesas do mês da parcela**. Pagamentos de fatura **reduzem o saldo da conta pagadora**, sem virar uma segunda despesa no relatório. O SQL adicional bloqueia pagamentos acima da fatura calculada.
- Limites de fechamento e vencimento de cartão aceitam de 1 a 28, para evitar problemas de fevereiro.
- Lançamentos recorrentes são expandidos até 30 dias à frente na abertura da aplicação, em lotes de até 60 ocorrências por origem; repetições são criadas como **pendentes**, não automaticamente pagas. Não é um sistema de cobrança bancária.
- Cotações de investimentos são declaradas manualmente e não são atualizadas por API externa.
- A DRE apresentada é **gerencial**, não substitui a escrituração por um contador.
- Use os relatórios e dados completos do Supabase para auditar os números em contas grandes.

## 9. Nome e identidade da aplicação

O nome provisório é **Orbis**. Altere `app.config.json` (`name`, `shortName`, `tagline`, `themeColor`) e, caso queira personalizar também o texto sem flash no HTML, edite o `<title>` e `apple-mobile-web-app-title` em `index.html`. Substitua os PNG/SVG de `public/icons/` e `public/favicon.svg` se mudar o logo. Faça novo build/implantação para atualizar o manifesto PWA.

Cor e tema por usuário: Configurações → Aparência. O aplicativo usa tema escuro como padrão.

## 10. Testar

```powershell
npm test
npm run typecheck
npm run build
```

`npm test` usa Node 22 com type stripping para executar funções puras e testes estruturais dos scripts SQL. **O teste de RLS incluído é estático**, não uma prova de isolamento em banco vivo; realize os testes em duas contas no Supabase.

Checklist pós-publicação:

1. Criar conta A, entrar, sair e recuperar senha.
2. Criar conta B e verificar isolamento de dados e de empresas.
3. Cadastrar contas, categorias, receita, despesa, transferência e compra parcelada.
4. Verificar que despesa pendente não altera saldo; despesa paga altera.
5. Pagar parte de uma fatura, conferir saldo; tentar pagar além e confirmar rejeição SQL.
6. Criar investimento e aporte/resgate; validar impacto no saldo declarado.
7. Criar tarefa, alterá-la no quadro, concluir e verificar recorrência.
8. Criar meta, hábito, registrar dias e visualizar gráficos.
9. Recarregar a página e validar persistência dos registros.
10. Verificar console do navegador (F12) e logs da Vercel/Supabase.
11. Abrir em celular (largura aproximada de 360–430px), instalar PWA e reabrir pelo ícone.
12. Desconectar internet e confirmar aviso: nenhuma escrita deve ser anunciada como salva sem resposta Supabase.

### Solução de problemas

| Mensagem ou comportamento | Verificação |
|---|---|
| Tela “Configure seu Supabase” | URL e chave pública de `.env.local`, reinicie Vite |
| 404 na atualização de rota | Confira `vercel.json` e diretório `dist` |
| `relation public.transactions does not exist` | Execute migração 001 |
| `function sync_recurring_transactions does not exist` | Execute migração 002 |
| Falta de permissão / RLS | Confira SQL, usuário autenticado e workspace correto |
| E-mail de confirmação não chega | Revise Auth > SMTP/email templates e limites |
| PWA não aparece para instalar | Use HTTPS/localhost, confira manifest e ícones, navegador compatível |
| Botão de excluir falha | Publique Edge Function `delete-account` |
| `npm install` falha | Confira acesso ao npm, proxy, firewall, DNS e versão Node |
| API consumindo leituras excessivas | Abra painel Network do navegador, registre quais tabelas/rotas geram os acessos, verifique loops e limite de dados |

## 11. Estrutura

```
OrbisOS/
├─ src/
│  ├─ App.tsx                    # login, home, menu, navegação, PWA
│  ├─ components/                # formulários CRUD e avatar privado
│  ├─ lib/                       # supabase, contexto de dados e cálculo financeiro
│  ├─ modules/                   # dashboards financeiros, produtividade, extras
│  ├─ style.css                  # tema premium responsivo
│  └─ main.tsx
├─ supabase/
│  ├─ migrations/001_schema.sql
│  ├─ migrations/002_financial_integrity.sql
│  └─ functions/delete-account/index.ts
├─ public/icons/               # ícones PWA
├─ referencias/                 # screenshots enviados como referência
├─ tests/                       # testes automatizados
├─ app.config.json              # nome e metadados
├─ vite.config.ts               # PWA
├─ vercel.json                  # SPA + cabeçalhos
├─ .env.example                 # sem segredos
└─ STATUS_DA_ENTREGA.md          # checklist de limitações e testes
```

## Segurança e responsabilidade

Este é um gerenciador pessoal auto-hospedado com Supabase e Vercel. O código foi preparado para operar com dados reais, **mas não passou por auditoria profissional de segurança, testes de produção nem validação jurídica/contábil**. Considere backups do banco Supabase, verificação periódica das políticas e revisão de permissões antes de guardar dados sensíveis. Em caso de dúvidas, consulte `STATUS_DA_ENTREGA.md`.
