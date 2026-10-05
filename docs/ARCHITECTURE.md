# Arquitetura e decisões

## Entrega 0–10

O documento possui 171 seções e, dentro delas, 14 blocos de desenvolvimento. O usuário autorizou as partes 0–10. Esta entrega prepara a foundation e a localização, sem declarar que os blocos de gameplay estão completos.

## Responsabilidades

| Sistema | Responsabilidade atual | Momento futuro |
| --- | --- | --- |
| GameManager | Estado global e validação inicial do catálogo | Orquestrar fluxo do jogo sem absorver combate |
| SceneManager | Navegação entre cenas e rejeição de destinos inválidos | Carregamento assíncrono dos biomas |
| SettingsManager | Persistência e recuperação da preferência de idioma | Demais preferências do jogador |
| LocalizationManager | Locales suportados, detecção e troca imediata | Todas as telas e conteúdos novos |
| DataCatalog e Resources | Definições tipadas de magos, inimigos e economia | Novos dados sem duplicar sistemas |
| RunManager / ProgressionManager | Não implementados | Run Coins / Saved Coins e progressão |
| SaveManager | Não implementado | PermanentSave, RunSave e transferência idempotente |
| Room/Enemy/Pool/Input/UI/Audio/Loot/Upgrade | Não implementados como managers globais | Implementar somente quando o uso exigir |

Os quatro gerenciadores iniciais são Autoloads. Resources descrevem dados; Nodes implementam comportamento. Componentes de combate pertencem às cenas, não aos Autoloads.

## Ordem e dependências atuais

1. `SettingsManager` lê preferências usando `SettingsStore` e `LocalePolicy`, classes sem dependência de Autoload.
2. `LocalizationManager` usa a preferência válida; na primeira abertura, detecta e salva o idioma do aparelho. Depois atualiza o `TranslationServer`.
3. `GameManager` valida `data/game_catalog.tres`. Recursos inválidos impedem o boot de avançar e produzem diagnóstico no console.
4. `SceneManager` navega somente entre destinos enumerados e bloqueia transições simultâneas.
5. `Boot` abre `Foundation`; a foundation instancia cartões a partir do catálogo e abre `SettingsScreen`.

As telas dependem desses serviços, mas os serviços não dependem das telas. `LocalizationManager` emite `locale_changed`; os cartões usam a notificação nativa de tradução. Não há dependência circular entre managers.

## Dados e unidades

- `attack_speed`: ataques por segundo; cooldowns e intervalos: segundos; movimento/alcance: pixels por segundo/pixels no espaço 2D.
- O catálogo e os Resources são definições compartilhadas, nunca estado de uma run. Testes que alteram dados usam cópias profundas.
- IDs de magos são `ice`, `fire`, `lightning`. IDs desconhecidos retornam `null` no catálogo ou `-1` na consulta de preço, nunca um desbloqueio gratuito implícito.
- Apenas o preço dos magos e atributos explicitamente definidos no mestre são requisitos fixos. Outros valores `.tres` são sementes para balanceamento futuro.
- O inimigo `desert_crawler` valida o contrato EnemyData/loot/economia. Não há inimigo instanciado nem IA nesta entrega.
- Pastas são criadas conforme têm conteúdo real. Os diretórios futuros do mestre não são preenchidos com scripts vazios.

## Preferências e localização

Arquivo: `user://settings.cfg`; backup: `settings.cfg.bak`. O diretório é fornecido pelo Godot para cada plataforma, fora de `res://`.

A gravação serializa e verifica `settings.cfg.tmp`, preserva o último arquivo válido e promove o temporário por rename. Uma falha retorna um `Error` e a UI não confirma sucesso nem muda de idioma. Um schema mais recente bloqueia escrita para evitar perda por downgrade. Um temporário incompleto não é adotado no próximo boot.

Esta proteção é de **preferências**, não prova de crash safety para economia. Não substitui PermanentSave/RunSave, banco idempotente ou testes de desligamento forçado em dispositivo.

O idioma do aparelho com prefixo `pt` usa `pt_BR`; outros idiomas usam `en`. A preferência manual tem precedência nas próximas aberturas. Todas as mensagens da interface usam chaves em `assets/localization/*.po`; campos de dados guardam as chaves, não texto traduzido. Adicione cada chave aos dois arquivos e preserve os placeholders entre chaves.

O modo de teste (`-- --test-mode`, apenas builds debug) usa `user://tests/session_settings.cfg`. Fixtures de testes recebem diretório único e são removidas pela própria suíte; não há acesso aos futuros saves de progresso.

## Regras já fixadas pelo documento

- Somente Gelo começa disponível. Fogo custa 500 e Raio 1.500 moedas permanentes.
- Morte/abandono explícito descartam as moedas da run. Fechar o aplicativo preserva a possibilidade de retomada.
- Recursos carregados são definições compartilhadas; o estado mutável de uma futura run será separado deles.
- As duas línguas oficiais são pt_BR e en. Textos exibidos ao jogador usam chaves, incluindo mensagens de erro.
- Um teste em Linux não comprova compatibilidade em Android/iOS.

## Decisões ainda abertas

- Origem dos dois elementos necessários aos combos quando uma run utiliza apenas um mago.
- Retomada no meio do combate: snapshot completo ou checkpoint de sala com regras contra duplicação de loot.
- Política de migração de saves entre versões, antes da implementação dos saves de progresso.
- Arte, animação, áudio e dispositivos de referência para profiling.

Estas decisões não bloqueiam a foundation e não serão resolvidas silenciosamente por uma mecânica inventada.
