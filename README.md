# Controle Glicêmico — Etapa 3

Etapa 3 implementa o fluxo local do aplicativo, mantendo a interface validada na Etapa 2 e sem integração com Google Sheets.

## Implementado
- Registro de glicemia pelo botão `+ REGISTRAR GLICEMIA`.
- Entrada somente do valor da glicemia.
- Data e hora preenchidas automaticamente pelo aparelho.
- Turno calculado automaticamente.
- Status calculado pelas regras existentes do projeto.
- Persistência local no Android com `shared_preferences`.
- Histórico funcional usando os dados armazenados localmente.
- Resumo, última medição, gráfico e medições recentes atualizados após o registro.
- Dados de exemplo são usados apenas para inicializar a base local na primeira execução.

## Fora desta etapa
- Google Sheets
- Google Drive
- OAuth
- Google Cloud
- sincronização
- dados reais da planilha
- PDF

## Teste recomendado no celular
1. Abrir o aplicativo.
2. Tocar em `+ REGISTRAR GLICEMIA`.
3. Informar um valor, por exemplo `99`.
4. Tocar em `SALVAR MEDIÇÃO`.
5. Confirmar a atualização da última glicemia, resumo, gráfico e medições recentes.
6. Abrir `Histórico` e confirmar o novo registro.
7. Fechar o aplicativo completamente.
8. Abrir novamente e confirmar que o registro permanece.
