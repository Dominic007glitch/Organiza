# Plano prático de testes (duas contas)

Esta lista indica o que precisa ser validado **após conectar o seu Supabase e instalar dependências**. Não significa que esses testes já foram executados.

- [ ] SQL 001 e SQL 002 sem erros no SQL Editor
- [ ] Conta A: cadastro/confirmar email/login/redefinir senha/logout
- [ ] Conta B: não consegue ler ou alterar dados de A, inclusive por REST autenticado
- [ ] Criar empresa A e empresa B; transações não se misturam
- [ ] Criar conta R$1000, despesa paga R$100 e pendente R$50; saldo deve R$900
- [ ] Transferir R$300 para outra conta; patrim. consolidado não muda
- [ ] Categoria e subcategoria criadas e arquivadas sem perda de transações
- [ ] Compra cartão R$100 em 3 vezes; conferir R$33,34/R$33,33/R$33,33
- [ ] Pagar a fatura com conta; conferir redução de saldo sem nova despesa
- [ ] Tentar pagar mais que fatura; banco rejeita
- [ ] Registrar aporte e resgate, conferir valor do investimento
- [ ] Criar meta vinculada a conta, conferir progresso
- [ ] Calendário semanal, mensal, tarefas e eventos recorrentes
- [ ] Criar projeto, subtarefa, arrastar cartões do Kanban, concluir
- [ ] Marcar hábito e desfazer marcação, recarregar, confirmar persistência
- [ ] Testar filtros por período e dados zerados
- [ ] Importar `examples/importacao_csv_exemplo.csv` duas vezes, conferir dedupe
- [ ] Exportar CSV e imprimir/salvar relatório em PDF
- [ ] Fazer upload de comprovante e abrir por URL assinada
- [ ] Testar a exclusão após publicar Edge Function
- [ ] Rodar npm run typecheck e npm run build sem erros
- [ ] Testar PWA Android, iOS Safari e desktop após deploy HTTPS
- [ ] Testar tela com 360px, 390px e 1280px; inspecionar overflow
- [ ] Desligar internet, tentar escrita, confirmar aviso de falha
- [ ] Conferir Network: sem polling frequente/loop de leitura
