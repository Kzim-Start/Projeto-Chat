# Arquitetura e decisões

## Entrega 0–10

O documento possui 171 seções e, dentro delas, 14 blocos de desenvolvimento. O usuário autorizou as partes 0–10. Esta entrega prepara a foundation e a localização, sem declarar que os blocos de gameplay estão completos.

## Responsabilidades na entrega 0–10 (histórico)

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

## Ordem e dependências na entrega 0–10 (histórico)

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

## Estado atual — 0.3.0, menus e arsenal

As seções acima registram a foundation. A implementação atual acrescenta `ProgressionManager` como quinto Autoload, entre GameManager e SceneManager. Boot abre MainMenu; Foundation continua disponível para verificação técnica. O fluxo é Menu → Mapa → Magos → Loading → Practice. Equipamentos pode abrir pelo menu principal ou pela seleção de mago e retorna à origem sem criar um ciclo no botão Voltar.

| Componente | Responsabilidade |
| --- | --- |
| ProgressionManager | Saved Coins, compras, upgrades, inventário e combinações por mago |
| ProfileStore | Validação, migração v1→v2, temporário/backup e persistência do perfil |
| EquipmentData | ID, traduções, espaço, preço, bônus e variante visual |
| Equipment screen | Loja, inventário, comparação, compra, equipar e remover |
| PixelArt / MagePortrait | Sprites em camadas, cache limitado e apresentação do personagem |
| PracticeMage / PracticeStage | Validação de controles, dano equipado e alvos sem recompensas |

### Inventário e dano

`owned_equipment` armazena IDs de itens; `loadouts` mapeia ID de mago para os espaços `staff`, `mantle` e `amulet`. Um item adquirido pode constar em combinações de magos diferentes, pois só o mago selecionado usa seus atributos. Equipar substitui o ID do mesmo espaço. Remover apaga a associação, sem destruir o item.

Compras e mudanças de combinação montam uma cópia do perfil e só a publicam em memória após gravação bem-sucedida. Não há concessão de moeda no código de produção. O item inicial tem preço zero configurado e segue a mesma regra de aquisição única.

O dano básico deriva de MageData e da combinação: `(base + flat) × (1 + percent)`. Os Resources nunca recebem os atributos modificados. Ao entrar no pátio, PracticeMage obtém o dano e as variantes visuais. Cada projétil guarda o dano do disparo. Os bônus desta entrega não alteram a nevasca experimental; o texto dos itens informa que fortalecem ataques básicos.

O perfil versão 2 adiciona inventário e combinações. A leitura de v1 acrescenta campos vazios e conserva o progresso; a inicialização persiste a migração, mantendo backup. Saves de versão futura não são sobrescritos. Essa transação de arquivo não substitui testes de desligamento físico ou o banking idempotente ainda pendente.

### Arte e limites

PixelArt constrói sprites originais com polígonos de pixels inteiros, paletas por elemento e camadas de equipamento. Texturas dos magos são reutilizadas e limitadas a 96 entradas. Oito poses movimentam tecido e respiração; não representam a implementação de todas as animações de combate do mestre. MagePortrait adiciona altar, pedras, halo e partículas sem modificar o personagem controlável.

Não foi criado um sistema de terceira moeda, recompensa no treino, run ou combate completo. Menus de compra trabalham apenas com o saldo permanente existente. Os testes e a captura equipada usam perfis isolados explicitamente identificados.
