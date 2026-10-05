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
