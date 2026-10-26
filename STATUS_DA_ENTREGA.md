# Situação honesta da entrega — OrbisOS 1.0

Data: 25/10/2026.

## Implementado no código

- React/TypeScript/Vite, shell responsivo premium, login/cadastro/recuperação via Supabase Auth, proteção de rota por sessão.
- Tela inicial com dois módulos e navegação lateral; área financeira com cartões, gráfico de área, rosca, lista de transações, barras de metas e filtros.
- Contas financeiras, transferências, categorias personalizáveis, transações, status/recorrência, anexos privados, cartões de crédito e parcelas, cálculo de saldos, faturas e pagamentos.
- Investimentos, calculadora composta, movimentos de aporte/resgate, patrimônio, orçamentos mensais, alertas por limites, múltiplas empresas separadas por workspace.
- Tarefas, projetos, subtarefas, categorias pessoais, calendário semanal/mensal, quadro Kanban arrastável com fallback, eventos recorrentes na visualização, hábitos, metas e progresso.
- Gráficos e relatórios, exportação CSV, impressão para PDF, backup JSON dos registros carregados, importação CSV com preview e hash, pesquisa em registros permitidos, central de avisos com persistência da leitura.
- Tema escuro/claro, foto e nome, senha via Supabase Auth, cor primária e visibilidade dos indicadores, logs mínimos, tela de exclusão de conta via Edge Function opcional.
- Esquema SQL com 23 tabelas, RLS por titular e vínculo cruzado ao workspace, Storage privado, índices, gatilhos de auditoria, regras de fatura e recorrência.
- PWA com ícones 180/192/512, web manifest, service worker estático, orientação de instalação e atualização.

## Validação efetivamente realizada neste ambiente

- **17 testes automatizados passaram** em `npm test` (cálculos e checagens estruturais do SQL).
- **0 erros de parsing TS/TSX** no código, verificados pelo compilador TypeScript disponível no ambiente.
- O arquivo ZIP e seus itens foram inspecionados localmente.

## Não foi possível comprovar neste ambiente

- `npm install`, `npm run typecheck` e `npm run build`: o acesso a `registry.npmjs.org` falhou por DNS (`EAI_AGAIN`); não há `node_modules` neste ZIP.
- Aplicação executando com navegador, comparação de screenshots, responsividade final.
- Migrações executadas em um projeto Supabase real, autenticação e operações multiusuário, verificação real de RLS, comportamento de Edge Functions.
- Publicação Vercel, validação do service worker e instalação PWA em Android/iPhone/desktop.

## Restrições e pendências de escopo

1. Ainda **não foi realizada validação ponta a ponta** da plataforma. Pode ser necessário corrigir bugs após `npm install`, typecheck, SQL Editor e testes no navegador. Portanto **não declare como projeto integralmente pronto para produção**.
2. Personalização: nome em `app.config.json`, cor, tema e visibilidade de cartões; **reordenação livre** dos cards e filtros padrão persistentes não foram implementados.
3. Fotos de perfil armazenadas no Storage privado. Não há editor/crop de imagem.
4. Metas aceitam progresso manual e vinculação a saldo de conta, mas **não há tabela própria de etapas de metas nem ligação automática de tarefas às metas**.
5. Subtarefas existem como cadastro, mas não aparecem como checklist integrado nos cartões do calendário.
6. Notificações são internas e avaliadas quando a aplicação está aberta. **Não há push/e-mail programado** nem jobs de servidor periódicos.
7. A exclusão total depende da publicação separada da Edge Function; ela remove os arquivos listáveis diretamente na pasta do usuário e o registro de autenticação, mas a cobertura de arquivos e relações deve ser testada no projeto real.
8. Não há integração de cotação em tempo real, banco/Open Finance, conciliação bancária automática ou inventário empresarial. O módulo empresarial é **financeiro**, não ERP de estoque/equipe/permissões de funcionários.
9. Não foi implementado um sistema de **compartilhamento por membros**, apenas isolamento por dono e múltiplos workspaces do mesmo titular.
10. Saldo inicial e valores de investimento exigem cadastramento consistente para não duplicar patrimônio; não há contabilidade de partidas dobradas nem DRE contábil certificada.
11. Repetições financeiras se geram no login até 30 dias adiante, com limite de 60 eventos por origem; um período muito longo sem login precisará de lógica de sincronização adicional. Recorrência de tarefas cria a próxima ocorrência ao marcar concluída. Não há cron autônomo.
12. Exportação JSON inclui registros carregados e é limitada pelo carregamento do navegador; para bases grandes use exportações diretas do Supabase.
13. O orçamento usa thresholds fixos de 70/90/100; **não há editor desses percentuais**.
14. Preferências de notificações não possuem painel avançado; a central mostra apenas alertas internos baseados nas regras atuais. Logs de auditoria são mínimos, sem diff de conteúdo e sem centro administrativo multiusuário.
15. Não foi escrita suíte E2E com navegador ou automação real de instalação. Os testes do banco inclusos são **estáticos**, e o login rate limiting usa proteção do Supabase Auth, sem política própria de bloqueio progressivo.

O código se destina a ser a **base inicial ampla e real** da plataforma, com funcionalidade conectada ao banco onde especificada, e não um mockup; no entanto **alguns requisitos do prompt ainda são parciais**. A lista é parte obrigatória da entrega para que não sejam omitidas limitações.
