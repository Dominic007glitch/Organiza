NOTA DE ATUALIZAÇÃO (V2 — DESIGN + PWA + INFRAESTRUTURA)
Este documento mantém na íntegra o PROMPT MESTRE original (seções 1 a 30) e acrescenta especificações obrigatórias nas seções 31 a 37.
As imagens mencionadas no texto devem ser disponibilizadas à IA desenvolvedora junto deste prompt.

---

# PROMPT MESTRE — SISTEMA DE GERENCIAMENTO PESSOAL E FINANCEIRO

## 1. OBJETIVO DO PROJETO

Desenvolva um sistema web completo, moderno, responsivo e profissional para gerenciamento da vida pessoal e financeira.

O sistema deve centralizar:

- Controle financeiro pessoal.
- Controle financeiro empresarial.
- Investimentos e patrimônio.
- Contas a pagar e a receber.
- Planejamento financeiro.
- Tarefas pessoais.
- Metas pessoais e financeiras.
- Hábitos e rotinas.
- Planejamento diário, semanal, mensal e anual.
- Relatórios, estatísticas e gráficos.
- Organização e acompanhamento da produtividade.

O usuário deve ter controle sobre suas informações e poder personalizar grande parte do sistema.

**Nome do sistema:** Configurável. Não definir um nome permanente no código.

**Idioma padrão:** Português do Brasil.

**Moeda padrão:** Real brasileiro (R$).

**Objetivo principal:** Permitir que qualquer pessoa organize sua vida financeira, profissional e pessoal em uma única plataforma.

---

# 2. TECNOLOGIAS E ARQUITETURA

Utilizar preferencialmente:

- React com TypeScript.
- Vite.
- Tailwind CSS.
- Biblioteca de componentes moderna, como shadcn/ui.
- Lucide React para ícones.
- Recharts para gráficos interativos.
- Supabase para autenticação, banco de dados e armazenamento.
- PostgreSQL por meio do Supabase.
- Vercel para hospedagem.

Organizar o projeto com arquitetura modular, componentes reutilizáveis e separação entre interface, serviços, autenticação e dados.

O projeto deve ser preparado para crescimento futuro.

## Requisitos técnicos

1. Sistema totalmente responsivo.
2. Interface em português brasileiro.
3. Tema claro e escuro.
4. Dados persistidos no banco de dados.
5. Atualização das informações após cada operação.
6. Validação de formulários.
7. Tratamento de erros.
8. Indicadores de carregamento.
9. Proteção de rotas.
10. Políticas de segurança no Supabase.
11. Consultas eficientes para evitar leituras desnecessárias.
12. Código organizado, documentado e de fácil manutenção.

---

# 3. SISTEMA DE LOGIN E CADASTRO

Ao acessar o site, o usuário deve encontrar uma tela de autenticação moderna.

## Login

Campos:

- E-mail.
- Senha.
- Botão Entrar.
- Esqueci minha senha.
- Criar conta.

## Cadastro

Campos:

- Nome completo.
- E-mail.
- Senha.
- Confirmar senha.

### Regras

- A senha deve ter no mínimo 8 caracteres.
- Pode conter letras, números e símbolos.
- Não exigir obrigatoriamente letras maiúsculas ou símbolos especiais.
- Senhas nunca devem ser armazenadas em texto puro.
- Utilizar autenticação segura do Supabase Auth.
- Disponibilizar recuperação de senha por e-mail.
- Permitir encerrar a sessão.
- Manter sessão autenticada de forma segura.

Cada usuário terá seu próprio espaço de trabalho.

**Muito importante:** Nenhum usuário pode visualizar ou modificar os dados privados de outro usuário.

Utilizar Row Level Security (RLS) em todas as tabelas que armazenarem informações privadas.

---

# 4. TELA INICIAL APÓS O LOGIN

Depois de entrar na conta, apresentar uma tela de boas-vindas com duas grandes opções.

## Opção 1 — Gerenciamento Financeiro

Ícone relacionado a dinheiro ou gráficos.

Descrição:

"Organize suas receitas, despesas, investimentos, empresas e patrimônio."

Botão: Acessar minhas finanças.

## Opção 2 — Tarefas e Metas

Ícone relacionado a tarefas ou objetivos.

Descrição:

"Organize sua rotina, acompanhe tarefas, crie hábitos e alcance suas metas."

Botão: Acessar meu planejamento.

A tela também pode mostrar um pequeno resumo do dia com tarefas pendentes, compromissos e alertas financeiros.

O usuário poderá alternar entre os dois módulos a qualquer momento, sem fazer login novamente.

---

# 5. MÓDULO DE GERENCIAMENTO FINANCEIRO

## 5.1 Dashboard financeiro

Criar um dashboard moderno, organizado e personalizável.

Exibir cartões com:

- Saldo total.
- Total recebido no mês.
- Total gasto no mês.
- Resultado líquido mensal.
- Despesas pendentes.
- Receitas previstas.
- Valor investido.
- Patrimônio total.
- Valor disponível para gastar.
- Economia do mês.
- Percentual de receitas comprometidas.
- Evolução financeira em relação ao mês anterior.

Utilizar indicadores visuais:

- Verde para receitas.
- Vermelho para despesas.
- Azul para informações.
- Amarelo para avisos.
- Cores adaptadas aos temas da interface.

Permitir selecionar períodos:

- Hoje.
- Esta semana.
- Este mês.
- Últimos 30 dias.
- Este ano.
- Período personalizado.

## 5.2 Registro de receitas e despesas

O usuário poderá cadastrar movimentações financeiras.

Campos:

- Descrição.
- Valor.
- Tipo: receita ou despesa.
- Categoria.
- Data.
- Conta financeira.
- Forma de pagamento.
- Status.
- Observações.
- Anexo opcional.
- Recorrência, quando aplicável.

Permitir:

- Criar movimentações.
- Editar movimentações.
- Excluir movimentações.
- Duplicar registros.
- Pesquisar.
- Filtrar por data.
- Filtrar por categoria.
- Filtrar por conta.
- Filtrar por valor.
- Ordenar os resultados.

### Despesas recorrentes

O usuário poderá cadastrar despesas que se repetem automaticamente:

- Diariamente.
- Semanalmente.
- Mensalmente.
- Anualmente.

Exemplos:

- Aluguel.
- Internet.
- Energia.
- Assinaturas.
- Mensalidades.

Diferenciar despesas previstas de despesas efetivamente pagas.

Não marcar automaticamente uma despesa como paga apenas porque chegou o vencimento.

---

# 6. CATEGORIAS FINANCEIRAS PERSONALIZÁVEIS

O usuário deve poder criar quantas categorias desejar.

Exemplos iniciais:

**Despesas:**
- Alimentação.
- Transporte.
- Moradia.
- Saúde.
- Educação.
- Compras.
- Lazer.
- Assinaturas.
- Outros.

**Receitas:**
- Salário.
- Vendas.
- Freelance.
- Rendimentos.
- Reembolsos.
- Outros.

Permitir:

- Criar categoria.
- Editar nome.
- Escolher cor.
- Escolher ícone.
- Criar subcategorias.
- Arquivar categoria.
- Excluir categorias sem uso.
- Definir limite mensal de gastos.
- Visualizar estatísticas por categoria.

Se uma categoria já possuir registros, impedir exclusões que destruam o histórico; oferecer arquivamento ou transferência de registros.

---

# 7. GRÁFICOS E ESTATÍSTICAS FINANCEIRAS

Implementar gráficos interativos e responsivos.

## Gráfico de pizza — Despesas por categoria

Mostrar quanto o usuário gastou em cada categoria.

Exemplo:

- Alimentação: 30%.
- Moradia: 25%.
- Transporte: 15%.
- Lazer: 10%.
- Outras categorias: 20%.

Ao clicar em uma categoria, permitir visualizar as movimentações relacionadas.

## Gráfico de pizza — Receitas por origem

Mostrar de onde o dinheiro recebido está vindo.

## Gráfico de barras — Receitas x Despesas

Comparar entradas e saídas financeiras por mês.

## Gráfico de linha — Evolução do saldo

Exibir a evolução do dinheiro ao longo do tempo.

## Gráfico de patrimônio

Mostrar crescimento ou redução do patrimônio.

## Gráfico de economia

Mostrar quanto foi economizado em cada mês.

Todos os gráficos devem oferecer filtros, legendas e informações ao passar o cursor.

Apresentar porcentagens e valores em reais, com cálculos corretos.

---

# 8. CONTAS FINANCEIRAS E CARTEIRAS

Permitir cadastrar diferentes locais onde o usuário mantém dinheiro.

Exemplos:

- Dinheiro em espécie.
- Conta corrente.
- Conta poupança.
- Carteira digital.
- Conta de investimento.
- Outras contas personalizadas.

Cada conta terá:

- Nome.
- Instituição.
- Tipo.
- Saldo inicial.
- Saldo atual calculado.
- Cor e ícone.
- Histórico de movimentações.

Permitir transferir dinheiro entre contas.

Transferências não devem ser contabilizadas como receitas ou despesas comuns, evitando duplicidade nos relatórios.

---

# 9. CARTÕES DE CRÉDITO

Criar uma área para gerenciamento de cartões.

Informações:

- Nome do cartão.
- Instituição.
- Limite total.
- Limite disponível.
- Dia de fechamento.
- Dia de vencimento.
- Faturas.
- Compras parceladas.

Permitir:

- Registrar compras.
- Parcelar compras.
- Visualizar parcelas futuras.
- Consultar faturas anteriores.
- Marcar faturas como pagas.
- Receber alertas de vencimento.
- Comparar gastos entre cartões.

As parcelas devem ser distribuídas corretamente entre os meses.

Evitar contabilização duplicada ao pagar uma fatura.

---

# 10. ÁREA DE INVESTIMENTOS

Criar uma seção específica chamada "Investimentos".

O objetivo é permitir que o usuário acompanhe onde está guardando e investindo dinheiro.

## Cadastro de investimentos

Campos:

- Nome do investimento.
- Tipo.
- Instituição.
- Valor inicialmente investido.
- Data da aplicação.
- Aportes adicionais.
- Resgates.
- Rentabilidade.
- Saldo atual.
- Observações.

Exemplos de tipos:

- Poupança.
- CDB.
- Tesouro Direto.
- Ações.
- Fundos imobiliários.
- Fundos de investimento.
- Criptomoedas.
- Outros.

O usuário deve poder informar o valor atual manualmente.

Não apresentar cotações em tempo real sem integração verdadeira com uma fonte confiável.

## Calculadora de investimentos

Desenvolver uma calculadora interativa.

O usuário informa:

- Valor inicial.
- Aporte mensal.
- Taxa de rentabilidade.
- Período.
- Tipo de taxa: mensal ou anual.

O sistema calcula:

- Total aportado.
- Juros acumulados.
- Patrimônio estimado ao final.
- Evolução mensal.
- Evolução anual.

Mostrar gráfico de crescimento.

Oferecer simulações com juros compostos.

Identificar que os resultados são estimativas e não garantias.

Quando houver impostos, inflação ou taxas adicionais, explicitar se estão incluídos no cálculo.

## Objetivos de investimento

Permitir cadastrar objetivos, por exemplo:

- Reserva de emergência.
- Comprar um carro.
- Comprar uma casa.
- Viagem.
- Aposentadoria.

Mostrar:

- Valor desejado.
- Valor acumulado.
- Valor restante.
- Percentual concluído.
- Prazo estimado, conforme os parâmetros informados.

---

# 11. PATRIMÔNIO PESSOAL

Criar uma tela para acompanhar o patrimônio.

Categorias:

- Dinheiro disponível.
- Investimentos.
- Imóveis.
- Veículos.
- Outros bens.
- Dívidas e obrigações.

Calcular:

**Patrimônio líquido = Ativos - Passivos.**

Permitir incluir bens manualmente e acompanhar sua evolução.

Evitar somar duas vezes investimentos ou saldos que já estejam registrados em outras áreas.

---

# 12. GERENCIAMENTO FINANCEIRO EMPRESARIAL

Dentro do módulo financeiro, criar uma seção separada chamada "Empresas".

O usuário poderá cadastrar uma ou várias empresas.

Cada empresa deve ter seu próprio espaço financeiro, separado das finanças pessoais.

## Cadastro de empresa

Informações:

- Nome da empresa.
- Nome fantasia.
- CNPJ opcional.
- Ramo de atividade.
- Descrição.
- Logo opcional.
- Moeda.
- Saldo inicial.

## Dashboard empresarial

Exibir:

- Faturamento.
- Despesas operacionais.
- Resultado líquido.
- Contas a receber.
- Contas a pagar.
- Fluxo de caixa.
- Despesas por categoria.
- Receitas por origem.
- Evolução mensal.
- Margem financeira.
- Comparação entre períodos.

## Movimentações empresariais

Permitir registrar:

- Vendas.
- Recebimentos.
- Compras.
- Pagamentos.
- Despesas fixas.
- Despesas variáveis.
- Assinaturas.
- Despesas com funcionários.
- Impostos.
- Investimentos da empresa.

## Categorias empresariais

Totalmente personalizáveis.

Exemplos:

- Vendas.
- Serviços.
- Marketing.
- Funcionários.
- Fornecedores.
- Aluguel.
- Equipamentos.
- Impostos.
- Manutenção.

## Relatórios empresariais

Gerar:

- Fluxo de caixa.
- Receitas x despesas.
- Demonstrativo gerencial de resultados.
- Evolução de faturamento.
- Despesas por categoria.
- Contas em aberto.
- Comparação entre meses.

A DRE gerencial não deve ser apresentada como documento contábil oficial.

## Separação obrigatória

As finanças empresariais nunca devem ser misturadas automaticamente às pessoais.

Transferências entre a pessoa e sua empresa devem ser identificadas e classificadas adequadamente.

Permitir uma visão consolidada opcional, sem perder a separação dos registros.

Preparar a arquitetura para futuramente permitir colaboradores com diferentes permissões.

---

# 13. ORÇAMENTO E PLANEJAMENTO FINANCEIRO

Criar uma área de orçamentos mensais.

O usuário poderá definir limites.

Exemplo:

- Alimentação: R$ 800.
- Transporte: R$ 400.
- Lazer: R$ 300.

Mostrar barras de progresso e percentuais de utilização.

Quando um orçamento alcançar determinados limites, gerar alertas internos.

Limites sugeridos:

- 70% do orçamento.
- 90% do orçamento.
- 100% do orçamento.

Permitir personalizar esses percentuais.

---

# 14. MÓDULO DE TAREFAS E METAS

Criar um segundo espaço principal, totalmente voltado à organização pessoal.

## Dashboard pessoal

Apresentar:

- Tarefas de hoje.
- Tarefas atrasadas.
- Tarefas concluídas.
- Metas em andamento.
- Hábitos do dia.
- Calendário.
- Produtividade semanal.
- Próximos compromissos.

O dashboard deve ter aparência moderna, simples e motivadora.

---

# 15. GERENCIAMENTO DE TAREFAS

Criar um gerenciador completo de tarefas.

Cada tarefa poderá conter:

- Título.
- Descrição.
- Categoria.
- Prioridade.
- Data de criação.
- Data de vencimento.
- Horário.
- Status.
- Subtarefas.
- Etiquetas.
- Recorrência.
- Observações.

## Prioridades

- Baixa.
- Média.
- Alta.
- Urgente.

## Status

- Pendente.
- Em andamento.
- Concluída.
- Cancelada.

## Visualizações

Disponibilizar:

- Lista.
- Quadro Kanban.
- Calendário.
- Planejamento semanal.

Permitir arrastar tarefas entre colunas no quadro Kanban.

Disponibilizar pesquisa e filtros.

## Tarefas recorrentes

Permitir repetir tarefas:

- Diariamente.
- Semanalmente.
- Mensalmente.
- Em dias específicos.
- Em intervalos personalizados.

Manter histórico das conclusões anteriores.

---

# 16. METAS E OBJETIVOS

Criar uma área de acompanhamento de metas.

Exemplos:

- Economizar R$ 10.000.
- Estudar 100 horas.
- Ler 12 livros.
- Treinar 150 vezes.
- Concluir um projeto.
- Abrir uma empresa.

Cada meta pode conter:

- Nome.
- Descrição.
- Categoria.
- Data inicial.
- Prazo.
- Valor ou quantidade desejada.
- Progresso atual.
- Etapas.
- Tarefas relacionadas.
- Observações.

Mostrar barra de progresso.

Calcular automaticamente o percentual de conclusão quando houver dados suficientes.

## Metas financeiras integradas

Permitir relacionar uma meta financeira a uma conta, orçamento ou objetivo de investimento.

O progresso deve ser baseado em dados reais quando houver integração, sem contar o mesmo dinheiro duas vezes.

---

# 17. CONTROLE DE HÁBITOS

Implementar um rastreador de hábitos.

Exemplos:

- Beber água.
- Fazer exercícios.
- Estudar.
- Ler.
- Dormir cedo.
- Economizar dinheiro.

Permitir:

- Criar hábitos.
- Definir frequência.
- Marcar como realizado.
- Visualizar calendário de conclusões.
- Acompanhar sequências de dias.
- Ver porcentagem de consistência.
- Consultar histórico.

Criar gráficos semanais e mensais.

---

# 18. CALENDÁRIO E PLANEJAMENTO

Criar calendário integrado contendo:

- Tarefas.
- Metas com prazo.
- Compromissos.
- Contas a pagar.
- Contas a receber.
- Eventos importantes.

Permitir alternar entre:

- Dia.
- Semana.
- Mês.

Usar cores diferentes para cada tipo de evento.

Ao selecionar um evento, abrir sua visualização detalhada.

Permitir criar lembretes internos.

---

# 19. RELATÓRIOS DE PRODUTIVIDADE

Criar gráficos mostrando:

- Quantidade de tarefas concluídas.
- Quantidade de tarefas pendentes.
- Percentual de conclusão.
- Evolução semanal.
- Cumprimento de metas.
- Frequência de hábitos.
- Comparação entre períodos.

Implementar um painel de estatísticas pessoais.

---

# 20. CENTRAL DE NOTIFICAÇÕES

Criar uma central de notificações dentro do sistema.

Exemplos:

- Conta próxima do vencimento.
- Conta vencida.
- Orçamento ultrapassado.
- Tarefa atrasada.
- Meta próxima do prazo.
- Hábito pendente.
- Objetivo financeiro alcançado.

Permitir marcar notificações como lidas.

Disponibilizar configurações individuais para cada tipo de aviso.

Evitar notificações duplicadas.

Notificações externas, como e-mail ou push, podem ser adicionadas posteriormente mediante configuração apropriada.

---

# 21. PERSONALIZAÇÃO DO SISTEMA

O sistema deve permitir ampla personalização.

O usuário poderá modificar:

- Nome de exibição.
- Foto de perfil.
- Tema claro ou escuro.
- Cor principal da interface.
- Categorias financeiras.
- Categorias de tarefas.
- Ícones.
- Ordem dos cartões.
- Cartões visíveis nos dashboards.
- Filtros padrão.
- Formato de data.
- Preferências de notificações.

As preferências devem ser salvas por usuário.

---

# 22. DESIGN E EXPERIÊNCIA VISUAL

O design deve ser premium, elegante e organizado.

Inspiração visual:

- Aplicativos financeiros modernos.
- Dashboards SaaS profissionais.
- Sistemas de produtividade.
- Interfaces minimalistas.

## Elementos visuais

- Sidebar lateral.
- Menu superior.
- Cartões arredondados.
- Gráficos modernos.
- Ícones consistentes.
- Animações suaves.
- Tipografia agradável.
- Espaçamento adequado.
- Boa hierarquia visual.

O design deve transmitir qualidade sem excesso de elementos.

## Responsividade

Desktop:

- Sidebar completa.
- Dashboards com múltiplas colunas.
- Gráficos maiores.

Tablet:

- Layout adaptativo.
- Sidebar recolhível.

Celular:

- Navegação simplificada.
- Cartões reorganizados.
- Formulários adaptados.
- Gráficos responsivos.

Todas as funções principais devem funcionar também no celular.

---

# 23. NAVEGAÇÃO

Estrutura sugerida:

**Tela principal**
- Gerenciamento Financeiro.
- Tarefas e Metas.

**Dentro do Financeiro**
- Visão Geral.
- Transações.
- Contas.
- Cartões.
- Categorias.
- Orçamentos.
- Investimentos.
- Patrimônio.
- Empresas.
- Relatórios.

**Dentro de Tarefas e Metas**
- Visão Geral.
- Minhas Tarefas.
- Quadro Kanban.
- Calendário.
- Minhas Metas.
- Hábitos.
- Produtividade.

**Conta**
- Meu Perfil.
- Personalização.
- Notificações.
- Segurança.
- Configurações.

---

# 24. SEGURANÇA E PRIVACIDADE

A segurança deve ser prioridade.

Implementar:

1. Supabase Auth.
2. Controle de sessões.
3. RLS em todas as tabelas privadas.
4. Proteção de dados por usuário.
5. Validação de permissões no banco.
6. Validação de entradas.
7. Proteção contra consultas indevidas.
8. Tratamento seguro de erros.
9. Recuperação de senha.
10. Logout.
11. Configurações de privacidade.
12. Logs técnicos mínimos e seguros.
13. Proteção contra tentativas excessivas de login.
14. Exclusão segura da conta.
15. Exportação dos próprios dados.

Não inserir chaves secretas no frontend.

Não confiar apenas na interface para controlar permissões.

Todas as operações de escrita e leitura devem respeitar as regras de acesso no banco.

---

# 25. BANCO DE DADOS

Planejar tabelas para:

- Perfis de usuários.
- Preferências dos usuários.
- Contas financeiras.
- Categorias.
- Transações.
- Transferências.
- Cartões.
- Faturas.
- Parcelas.
- Orçamentos.
- Investimentos.
- Aportes e resgates.
- Bens patrimoniais.
- Passivos.
- Empresas.
- Movimentações empresariais.
- Tarefas.
- Subtarefas.
- Categorias pessoais.
- Metas.
- Etapas das metas.
- Hábitos.
- Registros de hábitos.
- Eventos do calendário.
- Notificações.

Utilizar relacionamentos consistentes, índices e políticas RLS.

Adotar valores monetários com precisão decimal, evitando erros de arredondamento.

As exclusões e alterações devem preservar a integridade dos relacionamentos e do histórico financeiro.

---

# 26. FUNCIONALIDADES EXTRAS

Implementar também:

## Pesquisa global

Buscar tarefas, movimentações, categorias e metas.

A pesquisa deve respeitar os espaços e permissões de cada usuário.

## Exportação

Permitir exportar relatórios em CSV e PDF.

## Importação financeira

Disponibilizar importação de movimentações por CSV, com visualização prévia, validação e prevenção de duplicações.

## Backup dos dados

Disponibilizar exportação dos próprios registros.

Informar claramente que a exportação não substitui backups administrativos do banco de dados.

## Comparação de períodos

Permitir comparar informações financeiras e de produtividade entre meses.

## Interface sem dados

Criar estados vazios bem projetados com explicações e botões para o primeiro cadastro.

## Histórico

Registrar eventos importantes de criação, alteração, conclusão e exclusão, de acordo com a necessidade de cada módulo.

---

# 27. DESEMPENHO

O sistema precisa ser eficiente.

Implementar:

- Carregamento sob demanda.
- Paginação.
- Consultas otimizadas.
- Índices no banco.
- Cache adequado.
- Componentes reutilizáveis.
- Controle de requisições.
- Evitar consultas repetitivas.
- Evitar ciclos infinitos de renderização.
- Evitar recarregar todos os dados a cada interação.

Priorizar estabilidade, principalmente no Supabase.

---

# 28. TESTES OBRIGATÓRIOS

Testar:

1. Cadastro de usuário.
2. Login e logout.
3. Recuperação de senha.
4. Isolamento de dados entre duas contas.
5. Criação e edição de categorias.
6. Cadastro de receitas.
7. Cadastro de despesas.
8. Transferências.
9. Cálculo de saldos.
10. Compras parceladas.
11. Cálculos de investimento.
12. Separação entre empresas e finanças pessoais.
13. Criação de tarefas.
14. Conclusão de tarefas.
15. Metas e barras de progresso.
16. Hábitos recorrentes.
17. Calendário.
18. Gráficos.
19. Filtros.
20. Layout mobile.
21. Permissões no banco.
22. Sessões expiradas.
23. Erros de rede.
24. Consistência após atualização da página.

Não considerar o sistema concluído apenas porque a interface está funcionando.

As operações devem funcionar de verdade e persistir corretamente no banco de dados.

---

# 29. ENTREGA DO PROJETO

Quero o sistema funcional, e não apenas um protótipo visual.

Entregue o projeto completo em arquivo .ZIP contendo:

- Código-fonte.
- Frontend completo.
- Componentes.
- Rotas.
- Integração com Supabase.
- Scripts SQL.
- Migrações do banco.
- Políticas RLS.
- Arquivo `.env.example`.
- Configurações para Vercel.
- Testes implementados.
- README em português brasileiro.

O README deve explicar:

1. Como instalar o Node.js.
2. Como executar `npm install`.
3. Como configurar o Supabase.
4. Como encontrar a URL correta do projeto Supabase.
5. Onde encontrar a chave pública.
6. Como executar as migrações SQL.
7. Como configurar a autenticação.
8. Como cadastrar o primeiro usuário.
9. Como executar `npm run dev`.
10. Como publicar na Vercel.
11. Como testar o sistema.
12. Como solucionar erros comuns.

Não colocar senhas ou chaves secretas reais no código.

Caso alguma integração externa dependa de credenciais que não foram fornecidas, implementar sua estrutura e documentar claramente o que precisa ser configurado.

---

# 30. REGRAS FINAIS PARA A IA DESENVOLVEDORA

**Requisitos obrigatórios:**

- Não criar apenas telas ilustrativas.
- Não usar botões sem funcionamento.
- Não apresentar números fictícios como dados reais.
- Não misturar dados de diferentes usuários.
- Não misturar finanças pessoais e empresariais.
- Não eliminar funcionalidades por simplificação.
- Não deixar operações financeiras apenas no estado local.
- Não criar autenticação insegura.
- Não fazer consultas desnecessárias.
- Não entregar um projeto incompleto afirmando que está finalizado.

Todas as funcionalidades descritas devem possuir implementação real ou ser claramente identificadas como não concluídas.

Priorizar nesta ordem:

1. Segurança.
2. Integridade dos dados.
3. Funcionamento.
4. Desempenho.
5. Facilidade de utilização.
6. Qualidade visual.
7. Personalização.

**RESULTADO ESPERADO:**

Um sistema web profissional de gerenciamento pessoal, financeiro e empresarial, com autenticação segura, dashboards modernos, categorias personalizáveis, controle de gastos e receitas, investimentos, gráficos, gerenciamento de tarefas, hábitos e metas, banco de dados Supabase e estrutura pronta para publicação na Vercel.

O projeto deve estar organizado para que novas funcionalidades possam ser adicionadas futuramente sem necessidade de reconstruir o sistema inteiro.

---

# 31. ATUALIZAÇÃO OBRIGATÓRIA — FIDELIDADE VISUAL ÀS DUAS IMAGENS

**Esta seção complementa integralmente os itens 1 a 30. Nenhum requisito anterior deve ser removido, resumido, desativado ou substituído por dados falsos.** A implementação visual precisa se aproximar o máximo possível das DUAS imagens de referência anexadas a este pacote. As imagens são referências de layout, hierarquia, cores, espaçamentos, componentes e experiência de uso; não são modelos para usar como plano de fundo ou como uma tela estática.

Imagens anexas ao pacote:
- `referencias/01_dashboard_financeiro.png`: **referência visual prioritária** para o módulo financeiro, investimentos, patrimônio e dashboards empresariais.
- `referencias/02_dashboard_tarefas.png`: **referência visual prioritária** para o módulo de tarefas, metas, hábitos, calendário e projetos pessoais.

**Regra principal:** criar componentes React reais, interativos e responsivos visualmente muito próximos às referências. Não inserir a imagem como captura de tela, não usar imagens recortadas dos painéis para simular interfaces e não criar botões sem ação. Manter a identidade estética das duas referências como uma mesma família de produto.

## 31.1 Referência 01 — Dashboard financeiro

Reproduzir, com a maior fidelidade prática:

1. Fundo geral muito escuro, preto-azulado; painéis em azul-marinho quase preto, discretamente separados do fundo.
2. Sidebar fixa à esquerda no desktop, com logotipo configurável, ícones, separadores e opções de navegação. Item ativo em destaque verde/turquesa.
3. Barra superior com saudação personalizada, filtros de período, busca, sino de notificações e avatar/menu da conta.
4. Primeira linha com **quatro cartões de indicadores financeiros** com tipografia forte e valores grandes; primeiro cartão verde/turquesa de maior destaque e os demais em tonalidade escura.
5. Segunda linha: painel maior à esquerda com gráfico suave de fluxo de caixa (linhas/áreas de receitas e despesas), e painel menor à direita com **gráfico de rosca** mostrando gastos por categoria, valor central e legenda com percentuais.
6. Terceira linha: lista de transações recentes à esquerda e cartão de **metas financeiras com barras de progresso coloridas** à direita.
7. Bordas arredondadas, sombras discretas, contornos sutis, separação visual confortável, números alinhados e ícones pequenos bem definidos.
8. Visualização limpa, elegante e densa o suficiente para exibir dados úteis sem parecer sobrecarregada.
9. Usar dados reais de Supabase para todos os indicadores e gráficos. Uma conta recém-criada deverá visualizar valores zerados e estados vazios bem desenhados, **não valores inventados**.
10. Aplicar esta linguagem também às telas de receitas/despesas, cartões, investimentos, contas, relatórios e finanças das empresas, mantendo a separação entre contextos pessoais e empresariais.

## 31.2 Referência 02 — Dashboard de tarefas, metas e planejamento

Reproduzir, com a maior fidelidade prática:

1. Interface escura em grafite/carvão, integrada esteticamente ao financeiro.
2. Sidebar com avatar e perfil, área de pesquisa, menu organizado e projetos/grupos de tarefas.
3. Cabeçalho com título do espaço, campo de busca, ícones de ações, notificações, opções de visualização e filtros.
4. **Calendário semanal em destaque**, com dias da semana e grade de horários, semelhante à imagem.
5. Cards de compromissos e tarefas posicionados na grade, com formas arredondadas e cores pastel vivas como amarelo, azul, lilás e rosa.
6. Cards com título, horário, descrição curta, prioridade, checklist, progresso e ações rápidas sempre que adequado.
7. Menu para alternar entre visualização por calendário, lista, quadro Kanban e outras visões disponíveis, sem perder informações.
8. Parte inferior com resumos de projetos/metas e pequeno painel de estatísticas de produtividade em gráfico.
9. Ações rápidas para criar tarefa, compromisso, meta e projeto; arrastar cartões quando fizer sentido, respeitando regras de acessibilidade e com alternativa a drag-and-drop.
10. Não obrigar o usuário a ter uma equipe: a experiência principal é **gerenciamento pessoal**. Recursos de equipes são opcionais/futuros, sem inventar membros nem compartilhamentos automáticos.

## 31.3 Identidade visual unificada

- Estilo: premium, SaaS/fintech, minimalista, semelhante às duas referências.
- Tema padrão: **dark mode**; disponibilizar light mode personalizável conforme requisito anterior.
- Cores de fundo sugeridas (ajustar por comparação com as imagens): financeiro `#070711`, painéis `#101123`, módulos de tarefas `#15161A` / `#1E1F24`.
- Cor principal financeira: verde-turquesa próximo a `#00D5A0`.
- Acentos secundários: azul, violeta, rosa, amarelo; vermelho/rosa para despesas e avisos negativos.
- Textos em branco levemente suavizado, textos secundários em cinzas frios.
- Bordas e divisores quase invisíveis, com contraste suficiente para acessibilidade.
- Tipografia moderna como Inter, com pesos e tamanhos bem definidos.
- Raios de borda consistentes, microinterações leves e boa legibilidade.
- Preservar a estética vista nas referências sem copiar indevidamente marcas, logotipos, avatares ou ilustrações de terceiros.
- Nome e ícone do projeto serão definidos posteriormente pelo usuário; deixar configuráveis em um único local de configuração.

## 31.4 Proporção e adaptação das interfaces

**Desktop:** sidebar fixa de aproximadamente 220–270 px quando expandida; cabeçalho, cartões de métricas, gráficos e painéis em grade de múltiplas colunas, respeitando a hierarquia das imagens. Exibir área financeira e tela de planejamento com proporções visualmente próximas às referências em larguras de 1280–1600 px.

**Tablet:** permitir recolher a sidebar, reorganizar grids, preservar gráficos legíveis e controles utilizáveis.

**Celular:** usar barra de navegação inferior ou menu lateral compacto, tarjetas em coluna única ou duas colunas quando couber, filtros acessíveis e calendário adaptado para visão diária/lista. Não criar rolagem horizontal acidental, cortar gráficos, sobrepor botões ou exigir zoom.

**Tela de login e seleção de módulos:** manter a mesma identidade premium e dark das imagens, com formulário elegante e uma página principal pós-login que contenha exatamente dois acessos prioritários: **Gerenciamento Financeiro** e **Tarefas e Metas**. Permitir alternar entre módulos depois sem fazer login novamente.

---

# 32. INFRAESTRUTURA EXCLUSIVA — SUPABASE, VERCEL E VS CODE

**Restrição obrigatória do projeto:** usar apenas os seguintes serviços e ferramentas de infraestrutura:

- **Supabase:** autenticação, PostgreSQL, políticas RLS, Storage e, caso precise de lógica segura no servidor, Supabase Edge Functions.
- **Vercel:** hospedagem, HTTPS, domínio e publicação do frontend.
- **Visual Studio Code (VS Code):** edição, execução local, depuração e manutenção do código-fonte.

**Bibliotecas locais do ecossistema React, Vite e npm são permitidas** — elas não constituem serviços adicionais. Pode usar TypeScript, Tailwind CSS, shadcn/ui, Lucide React, Recharts, React Router, Zod, vite-plugin-pwa e outras dependências livres necessárias.

Não exigir Firebase, Firestore, Netlify, Railway, Render, Clerk, Auth0, AWS, servidores próprios, APIs pagas ou bancos externos. Nenhuma funcionalidade essencial poderá depender obrigatoriamente de uma plataforma fora das três citadas. Para funcionalidades não viáveis apenas com essa infraestrutura, oferecer uma implementação compatível ou documentar claramente a limitação, sem fingir que está pronta.

- O frontend não deve conter secrets nem chave service_role.
- Usar a URL correta `https://<project-ref>.supabase.co` e a chave pública/publishable do Supabase no `.env.local`; nunca usar a URL do dashboard do Supabase como `VITE_SUPABASE_URL`.
- Proteger leitura/escrita com RLS no Postgres, inclusive para dados de empresas do mesmo usuário.
- Não criar um backend Node sempre ligado ou servidor de hospedagem adicional. Caso precise executar regras privilegiadas, utilizar Edge Functions e permissões verificadas no servidor.
- Documentar a publicação do frontend na Vercel, inclusive rewrites de SPA, variáveis de ambiente, URL do domínio e redirects de autenticação.
- Preparar toda a instalação e a manutenção para serem feitas pelo usuário no VS Code + painel do Supabase + painel da Vercel.

---

# 33. INSTALAÇÃO PELO NAVEGADOR E ÍCONE NA TELA INICIAL (PWA)

**Requisito absolutamente obrigatório:** o site deve ser um **Progressive Web App (PWA)** instalável, de modo que, após publicado na Vercel, o usuário possa abrir o endereço no navegador, escolher instalar/adicionar à tela inicial em navegadores compatíveis e encontrar o **ícone do aplicativo na tela inicial do celular** ou na lista de apps/área de trabalho do computador, conforme o sistema operacional.

Esta exigência NÃO significa criar APK nativo ou publicar em App Store / Play Store. A instalação deve funcionar como app web PWA sem serviços externos obrigatórios.

## 33.1 Implementação PWA

1. Configurar `vite-plugin-pwa` ou abordagem equivalente estável no projeto React + Vite.
2. Criar manifesto web com `name` e `short_name` configuráveis, `start_url: "/"`, `scope: "/"`, `display: "standalone"`, `theme_color`, `background_color`, ícones de **192x192 e 512x512**, incluindo versão maskable quando viável.
3. Definir ícones e favicon coerentes com o visual premium do sistema, usando design próprio e substituível quando o nome for definido.
4. Configurar service worker para armazenar **somente recursos estáticos apropriados** e habilitar abertura confiável do shell da aplicação.
5. Não armazenar permanentemente em cache dados financeiros privados, respostas de API autenticadas, tokens, senhas ou informações sensíveis.
6. Quando o usuário abrir o PWA instalado, mostrar a tela de **login** caso a sessão não seja válida, ou a **tela principal com as duas opções** caso esteja autenticado.
7. Permitir abrir o app em janela própria sem a interface habitual do navegador nos ambientes compatíveis.
8. Criar botão/contexto **“Instalar aplicativo”** quando a API de instalação do navegador permitir. Não fingir que a instalação ocorreu: aguardar o resultado real da interação.
9. Para navegadores sem prompt programático (por exemplo, Safari no iPhone), mostrar instruções objetivas de **Compartilhar → Adicionar à Tela de Início**, conforme as opções do sistema.
10. Permitir atualização de versão de modo seguro, evitando que mudanças em JS/service worker deixem o app preso em arquivos antigos; mostrar aviso amigável de nova versão quando necessário.
11. Exibir mensagem clara para falta de conexão. Funções de leitura/gravação que precisam do Supabase devem avisar que exigem internet, sem simular salvamento bem-sucedido.
12. Usar HTTPS fornecido pela Vercel em produção; explicar que instalação e service worker normalmente exigem HTTPS (localhost é exceção de desenvolvimento).
13. Adicionar metatags móveis e configuração apropriada para apresentação do atalho na tela inicial, incluindo ícone para iOS.
14. Considerar bom contraste, área de toque suficiente e navegação por teclado em todos os pontos de instalação.

## 33.2 Critérios objetivos de aceitação da instalação

- O app publicado tem manifest válido e service worker funcional.
- O navegador compatível oferece a opção de instalar o site.
- Após adicionar à tela inicial, aparece um **ícone próprio** com o nome escolhido para o app.
- Abrir o ícone inicia a aplicação no endereço correto e restaura sessão válida ou pede login.
- O usuário pode usar financeiro e tarefas a partir do atalho, com a mesma base de dados no Supabase.
- A experiência fica responsiva em Android, iPhone/iPad e desktop, reconhecendo que o método de instalação varia conforme navegador e sistema.
- A opção de instalar é uma capacidade da experiência publicada; não exigir lojas de aplicativos.

---

# 34. EXPERIÊNCIA DO USUÁRIO E FUNCIONALIDADES VISUAIS REAIS

Todos os controles presentes nas interfaces devem estar ligados à lógica do sistema, inclusive:

- Filtros de data: alteram métricas e gráficos, sem mudar apenas o botão visualmente.
- Busca: pesquisa exclusivamente registros autorizados do usuário no Supabase.
- Avatar/conta: abre menu funcional de perfil, configurações, senha e sair.
- Notificações: mostram avisos reais, com leitura/arquivamento conforme o backend.
- Cartões estatísticos: refletem valores calculados de movimentações reais.
- Gráficos: possuem tooltips, percentuais consistentes, filtros e estados vazios.
- Metas: progresso alterado a partir de registros reais vinculados ou atualizações manuais verificadas.
- Calendário: eventos aparecem em dia e horário corretos; criação, edição, mudança de status e recorrência funcionam.
- Botão de adicionar: abre formulário completo e salva no Supabase.
- Alternância das visões lista/Kanban/calendário: apresenta os mesmos dados com layouts diferentes.
- Navegação lateral e abas: cada item aponta para uma rota/tela implementada.
- Personalização: tema, categorias, cartões e preferências persistem no Supabase por usuário.

O fluxo da interface deve ser suave e dar feedback após ações, com loading, confirmação de exclusões importantes, validação e mensagens compreensíveis. Não exibir dados de exemplo dentro da conta real. Um modo de demonstração só pode existir se claramente identificado e separado dos dados reais.

---

# 35. ENTREGA COMPLETA E REPRODUZÍVEL

Preservar integralmente a obrigação de entrega em **arquivo ZIP com projeto pronto**, definida no item 29, acrescentando obrigatoriamente:

- Código-fonte completo da aplicação React/Vite/TypeScript.
- Design fiel às duas imagens fornecidas, incluindo todos os componentes reais.
- Manifest e service worker PWA, ícones, favicon e configuração de instalação.
- Tela de login/cadastro e seleção dos dois módulos com identidade visual unificada.
- Todas as telas e operações previstas nos itens 1 a 30, sem trocar implementação real por protótipo.
- Scripts SQL/migrações completos para criar e configurar o Supabase e políticas RLS.
- `.env.example` **sem credenciais reais** e documentação para montar o `.env.local`.
- `vercel.json` quando necessário, garantindo atualização de rotas React.
- README didático em português, para uma pessoa que configurará apenas Supabase, Vercel e VS Code.
- Instruções para verificar o PWA no Android, no iPhone/Safari e no desktop, incluindo as limitações naturais de cada navegador.
- Testes de cálculos, permissões, tarefas, responsividade e critérios de instalação PWA.

## 35.1 Instruções de execução esperadas no README

Descrever, de modo objetivo e executável:

1. Abrir a pasta do projeto no Visual Studio Code.
2. Instalar dependências com `npm install`.
3. Criar projeto no Supabase.
4. Aplicar, na ordem correta, scripts SQL/migrações fornecidos no SQL Editor do Supabase.
5. Configurar autenticação, confirmação de e-mail e URLs de redirecionamento.
6. Copiar `.env.example` para `.env.local`, preencher URL `https://<project-ref>.supabase.co` e publishable key.
7. Iniciar com `npm run dev` para testar localmente.
8. Executar build e testes indicados no projeto.
9. Importar/publicar na Vercel e configurar variáveis de ambiente.
10. Conferir redirects/rotas, autenticação e políticas RLS em produção.
11. Abrir o site publicado via HTTPS e instalar na tela inicial pelo navegador.
12. Validar que todas as alterações no financeiro e tarefas persistem no Supabase.

Nenhum passo deve depender de contratar ou configurar outra plataforma de infraestrutura.

---

# 36. TESTES DE FIDELIDADE E VALIDAÇÃO FINAL

Antes de declarar a entrega como concluída, realizar e documentar, sempre que o ambiente de implementação permitir:

**Interface financeira**
- Captura de tela do dashboard em resolução de desktop comparada lado a lado à referência 01.
- Sidebar, cabeçalho, quatro cartões, gráficos, gastos por categoria, transações e metas no arranjo correto.
- Visualização com valores zerados quando a conta não possui registros.

**Interface de produtividade**
- Captura de tela do módulo de tarefas comparada à referência 02.
- Calendário semanal, cartões coloridos, sidebar, abas e gráficos no arranjo correto.
- Inclusão, edição, conclusão, recorrência e filtros persistindo no banco.

**Mobile e PWA**
- Verificar largura de 360–430 px e tablet, sem estouro horizontal nem sobreposição.
- Confirmar manifesto, ícones, service worker e abertura pelo atalho instalado.
- Testar sessão válida, sessão expirada, modo sem internet e atualização de versão.
- Não usar teste puramente visual como substituto para teste funcional.

**Supabase**
- Criar dois usuários de teste e provar isolamento via RLS nas leituras e escritas.
- Testar operações financeiras, limites, receitas/despesas, transferências, cartões, investimentos e empresas sem duplicidade.
- Verificar que consultas de componentes e gráficos não criam loops ou volume anormal de requisições.

Registrar no README quais testes foram efetivamente executados e quais dependem do ambiente de produção. Não afirmar que testes de instalação ou de deploy foram realizados sem tê-los realizado.

---

# 37. PRIORIDADE ENTRE REQUISITOS E CRITÉRIO DE CONCLUSÃO

- Os itens 1 a 30 são a **base funcional integral**; os itens 31 a 37 são **atualizações obrigatórias** e não eliminam nenhuma função anterior.
- A referência 01 governa a aparência da área financeira; a referência 02 governa a aparência de tarefas e metas.
- A PWA deve ser instalável pelo navegador, com atalho na tela inicial.
- A infraestrutura externa limita-se a **Supabase e Vercel**, com desenvolvimento no **VS Code**.
- Dados e cálculos corretos, segurança, permissões e estabilidade têm precedência sobre animações decorativas.
- A aparência tem de ser muito próxima às imagens, mas ser implementada como interface real, acessível e responsiva.
- O projeto só deve ser chamado de completo se todas as funções prometidas estiverem implementadas e verificáveis. Caso haja limitações, listar com transparência em seção específica no README.

**INSTRUÇÃO FINAL À IA DESENVOLVEDORA:** leia TODO o prompt e examine AMBAS as referências antes de começar. Entregue o projeto completo, organizado e pronto para configurar usando exclusivamente Supabase, Vercel e VS Code. Não entregar somente uma landing page ou mockup. O resultado esperado é um sistema real, premium, instalável como PWA, com painéis visualmente fiéis às referências e todas as funções pessoais, financeiras e empresariais acima.

