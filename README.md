# Controle Glicêmico — Flutter

## Etapa 1 — Fundação + interface de referência

Projeto Android próprio em Flutter/Dart, sem conexão com Google Sheets nesta etapa.

A interface foi estruturada a partir do protótipo HTML aprovado (`controle-glicemico-inicio(1).html`).

### Objetivos desta etapa
- Fundação do projeto Flutter/Dart.
- Arquitetura separada por configuração, modelos, domínio, repositório, telas e widgets.
- Dados exclusivamente fictícios/em memória.
- Regras de STATUS implementadas.
- Regra de TURNO implementada: antes de 12:00 = Manhã; antes de 18:00 = Tarde; 18:00 em diante = Noite.
- Tela inicial responsiva com a identidade visual aprovada.
- Gráfico em `CustomPainter`, sem dependências externas.
- Navegação inferior preparada para as próximas etapas.

### Não faz parte da Etapa 1
- Google Sheets.
- Google Cloud.
- OAuth/autenticação.
- APK/Codemagic.
- Persistência local real.
- Registro real.
- PDF.
- Sincronização.

## Estrutura

```text
lib/
├── config/
│   └── app_theme.dart
├── data/
│   └── sample_records.dart
├── domain/
│   └── glycemia_rules.dart
├── models/
│   └── glycemia_record.dart
├── repository/
│   ├── glycemia_repository.dart
│   └── in_memory_glycemia_repository.dart
├── screens/
│   └── home_screen.dart
├── widgets/
│   ├── app_header.dart
│   ├── glycemia_chart.dart
│   ├── measurement_card.dart
│   ├── recent_measurements_card.dart
│   ├── register_button.dart
│   ├── report_card.dart
│   └── summary_card.dart
└── main.dart
```

A camada `repository` é a fronteira preparada para, em etapa posterior, trocar os dados fictícios pela integração segura com Google Sheets sem reconstruir a interface.


## Etapa 2 — Interface Android

A interface foi adaptada para Flutter usando o protótipo HTML aprovado como referência visual oficial.

Mantidos: identidade bordô/vermelha, fundo claro, cabeçalho, última medição, botão de registro, resumo, gráfico, relatórios, medições recentes e navegação inferior.

Nesta etapa continuam proibidos: Google Sheets, Google Cloud, OAuth, sincronização e alterações na planilha real. Os dados permanecem fictícios/em memória.

## Etapa 2 — Correção para Codemagic

Foi incluída a plataforma Android (`android/`) e o `codemagic.yaml` para permitir a geração do APK de validação no Codemagic. Não há integração com Google Sheets, OAuth, sincronização ou dados reais nesta etapa.
