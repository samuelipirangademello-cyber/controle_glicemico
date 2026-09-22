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


## Etapa 2 — Compatibilidade Android/Flutter atual

Atualizado o Kotlin Gradle Plugin para 2.2.20, conforme requisito do Flutter usado no CI.

## Build 9 — Diagnóstico da tela quebrada (blocos sólidos rosa/cinza)

No aparelho (Xiaomi/MIUI), a build 8 abriu com a aba Histórico mostrando dois
blocos sólidos sem texto, embora o código dessa tela seja um Column simples
(ícone + título + frase). Isso não é reproduzível lendo o código-fonte: nada em
`main.dart` desenha dois retângulos coloridos. A hipótese testada nesta build:

- O motor gráfico novo do Flutter no Android, o **Impeller**, tem vários
  relatos abertos no repositório oficial do Flutter de cartões com sombra
  (`boxShadow`) sendo desenhados como blocos sólidos ou corrompidos em certas
  GPUs Android, incluindo relatos específicos em aparelhos Xiaomi.
- Todos os cartões desta tela usavam `boxShadow` com blur, e o botão
  "Registrar Glicemia" usava `elevation` (sombra do Material), a mesma família
  de efeito.

Mudanças desta build, só para testar essa hipótese:
1. Removido o `boxShadow` de todos os cartões (mantida a borda fina).
2. Zerada a `elevation`/`shadowColor` do botão principal.
3. Desligado o Impeller no Android via `AndroidManifest.xml`
   (`io.flutter.embedding.android.EnableImpeller = false`), voltando ao motor
   Skia.

Nenhuma mudança de layout, texto ou dado foi feita. Se a tela abrir certa
nesta build, o problema era o Impeller/sombra; se persistir, o problema é
outro e o próximo passo é olhar o log de build do Codemagic.
