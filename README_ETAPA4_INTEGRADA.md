# Controle Glicêmico — pacote integrado

Este pacote implementa em conjunto:

- Relatórios com período personalizado;
- atalhos de 7 e 30 dias e mês corrente;
- gráfico do período selecionado;
- geração/visualização do relatório em PDF pelo sistema Android;
- tela Configurações funcional;
- conexão Google Sign-In + Google Sheets API;
- leitura da planilha no formato `DATA | HORA | GLICEMIA | TURNO | STATUS`;
- sincronização da planilha para o armazenamento local;
- envio automático de novas medições para a planilha quando a conexão Google estiver ativa;
- preservação do armazenamento local;
- Gradle com 4 GB de heap.

## O que ainda precisa ser configurado fora do código

A comunicação com uma planilha privada exige OAuth do Google. O aplicativo não contém senha nem segredo. Antes do primeiro uso da conexão:

1. Crie/seleciona um projeto no Google Cloud.
2. Ative a Google Sheets API.
3. Configure a tela de consentimento OAuth.
4. Cadastre o aplicativo Android e um cliente OAuth Web.
5. No aplicativo, informe o `ID do cliente OAuth Web` e o `ID da planilha` em Configurações.
6. Primeiro use uma CÓPIA de teste da planilha com os ~70 registros.

O acesso é autenticado pela conta Google e a planilha pode continuar privada.

## Importante

O código está preparado para ler e gravar a planilha, mas a credencial OAuth real não pode ser inventada ou incluída neste ZIP. Sem configurar o projeto OAuth do Google, o botão de conexão exibirá uma mensagem de configuração.

## Formato esperado

A primeira linha pode conter cabeçalho. O intervalo padrão é `A:E` e os dados são interpretados como:

`DATA | HORA | GLICEMIA | TURNO | STATUS`

O botão SINCRONIZAR PLANILHA lê os registros e substitui o conjunto local pelos registros válidos encontrados. Por isso, na primeira sincronização, use a cópia de teste.
