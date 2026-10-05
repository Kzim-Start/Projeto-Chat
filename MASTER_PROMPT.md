# CRIMSON MAGE
## MASTER DEVELOPMENT PROMPT — VERSÃO FINAL UNIFICADA

> Este documento é a **fonte única de verdade** do projeto.
>
> Ele substitui todas as versões anteriores do prompt, adendos e regras conflitantes.
>
> Caso alguma instrução antiga do projeto entre em conflito com este documento, **ESTE DOCUMENTO PREVALECE**.

---

# 1. MISSÃO

Desenvolva um jogo mobile completo chamado:

# CRIMSON MAGE

Atue simultaneamente como:

- Lead Game Developer;
- Game Designer;
- Gameplay Programmer;
- Technical Artist;
- UI/UX Designer;
- VFX Designer;
- Audio Designer;
- QA Engineer;
- Mobile Optimization Engineer.

O objetivo NÃO é produzir:

- apenas um protótipo;
- apenas uma tech demo;
- um conjunto de scripts desconectados;
- telas sem gameplay;
- pseudocódigo;
- funções vazias;
- dezenas de TODOs;
- sistemas simulados que não funcionam.

O objetivo é construir um jogo:

- jogável;
- divertido;
- organizado;
- expansível;
- estável;
- otimizado;
- preparado para Android e iOS.

---

# 2. REGRA CENTRAL DE DESENVOLVIMENTO

Nunca tente construir o jogo inteiro de uma vez.

Sempre siga:

```text
IMPLEMENTAR
↓
CONECTAR
↓
EXECUTAR
↓
TESTAR
↓
CORRIGIR
↓
VALIDAR
↓
AVANÇAR
```

Uma etapa não deve ser considerada concluída simplesmente porque o código foi escrito.

Ela só termina quando estiver:

- integrada;
- executável;
- testada;
- sem erros críticos conhecidos.

Se um teste importante falhar:

```text
NÃO AVANCE.
```

Primeiro:

```text
INVESTIGUE
↓
CORRIJA
↓
TESTE NOVAMENTE
```

---

# 3. TECNOLOGIA

Utilizar:

## Engine

Godot 4.x

## Linguagem

GDScript

## Renderização

2D

## Plataformas principais

Android

iOS

## Orientação

Landscape / horizontal.

## Requisitos gerais

O jogo deve:

- funcionar offline;
- não exigir servidor;
- não exigir conexão constante;
- não utilizar plugins pagos obrigatórios;
- evitar dependências externas desnecessárias.

Objetivo:

```text
60 FPS
```

em smartphones intermediários.

Fallback aceitável:

```text
30 FPS estáveis
```

em aparelhos mais fracos.

---

# 4. CONCEITO

CRIMSON MAGE é um:

**Action Roguelite 2D Top-Down em Pixel Art Dark Fantasy.**

O jogador controla magos elementais e atravessa pequenas salas infestadas por criaturas.

Cada run contém:

```text
COMBATE
↓
RECOMPENSA
↓
ESCOLHA
↓
FORTALECIMENTO
↓
NOVO COMBATE
↓
BOSS
```

A sensação desejada é:

> “Só mais uma sala.”

O jogo pode utilizar referências do gênero para ritmo e estrutura.

Porém precisa possuir identidade própria.

Não copiar:

- personagens;
- sprites;
- interfaces;
- mapas;
- nomes;
- músicas;
- efeitos;
- layouts;
- assets;

de outros jogos.

---

# 5. PILARES DO CRIMSON MAGE

Toda decisão de desenvolvimento deve favorecer:

1. combate extremamente responsivo;
2. magias satisfatórias;
3. controles mobile confortáveis;
4. progressão roguelite;
5. builds variadas;
6. salas rápidas e intensas;
7. chefes memoráveis;
8. identidade visual forte;
9. feedback audiovisual;
10. boa performance;
11. rejogabilidade;
12. progressão de longo prazo;
13. arquitetura expansível.

---

# 6. FILOSOFIA DE DESENVOLVIMENTO

Sempre seguir:

```text
FUN
↓
SYSTEMS
↓
CONTENT
↓
POLISH
```

Nunca:

```text
CONTENT
↓
CONTENT
↓
CONTENT
↓
TENTAR DEIXAR DIVERTIDO DEPOIS
```

Primeiro faça:

- o jogador ser gostoso de controlar;
- o ataque ser satisfatório;
- uma sala ser divertida;
- uma run funcionar;
- uma fase ser excelente.

Somente depois:

- adicionar cinco novos biomas;
- dezenas de inimigos;
- mais conteúdo.

---

# 7. ESTRUTURA DE PASTAS

Organizar aproximadamente:

```text
res://

assets/
    characters/
        ice_mage/
        fire_mage/
        lightning_mage/

    enemies/
        desert/
        forest/
        snow/
        grail/
        heaven/
        hell/

    bosses/

    environments/

    tilesets/

    ui/

    vfx/

    audio/
        music/
        sfx/
        ui/

scenes/
    boot/
    menus/
    map/
    characters/
    enemies/
    bosses/
    rooms/
    biomes/
    ui/
    effects/

scripts/
    core/
    player/
    combat/
    enemies/
    bosses/
    procedural/
    progression/
    save/
    localization/
    audio/
    ui/
    mobile/
    debug/

data/
    characters/
    enemies/
    bosses/
    economy/
    items/
    relics/
    upgrades/
    biomes/
    rooms/

autoload/

resources/

tests/
```

Não criar arquivos gigantes com responsabilidades demais.

---

# 8. ARQUITETURA CENTRAL

Criar sistemas independentes quando necessário:

```text
GameManager

SceneManager

RunManager

ProgressionManager

SaveManager

RoomManager

EnemyManager

PoolManager

InputManager

UIManager

AudioManager

SettingsManager

LootManager

UpgradeManager

LocalizationManager
```

Utilizar Autoload somente quando fizer sentido.

Evitar:

- dependências circulares;
- God Objects;
- código fortemente acoplado.

---

# 9. SISTEMA DATA-DRIVEN

Valores importantes não devem ficar espalhados pelos scripts.

Utilizar:

- Resources;
- arquivos de configuração;
- dados centralizados.

Exemplo:

```text
MageData

id
name_key
description_key
max_hp
max_shield
max_mana
move_speed
attack_damage
attack_cost
attack_speed
skill_cooldown
dash_cooldown
element
sprite_data
```

Inimigos:

```text
EnemyData

id
name_key
max_hp
damage
speed
attack_range
attack_interval
enemy_type
loot_table
biome
difficulty_cost
```

Economia:

```text
EconomyData

fire_mage_price
lightning_mage_price
phase_rewards
shop_prices
permanent_upgrade_costs
coin_drop_values
```

Não espalhar números mágicos pelo código.

---

# 10. LOCALIZAÇÃO DESDE O INÍCIO

O jogo deve possuir oficialmente:

```text
Português do Brasil — pt_BR

English — en
```

Localização NÃO deve ser adicionada somente no final.

Todos os textos apresentados ao jogador devem utilizar chaves.

Nunca:

```text
button.text = "Jogar"
```

Utilizar conceito equivalente a:

```text
MENU_PLAY
```

Português:

```text
MENU_PLAY = Jogar
```

English:

```text
MENU_PLAY = Play
```

Isso inclui:

- menus;
- botões;
- tutorial;
- loading;
- nomes de fases;
- nomes de magos;
- nomes de bosses;
- habilidades;
- upgrades;
- relíquias;
- lojas;
- vitória;
- derrota;
- confirmações;
- mensagens;
- tooltips;
- configurações.

Na primeira abertura:

1. detectar idioma do aparelho;
2. se compatível com português brasileiro, utilizar `pt_BR`;
3. caso contrário, utilizar inglês;
4. permitir alteração manual;
5. salvar a preferência.

Mudança manual deve idealmente atualizar a interface sem reiniciar o jogo.

---

# 11. FLUXO FINAL DO JOGO

```text
BOOT
↓
MAIN MENU
↓
MAPA-PERGAMINHO
↓
ESCOLHA DA FASE
↓
ESCOLHA DO MAGO
↓
LOADING
↓
FASE
↓
SALA
↓
COMBATE
↓
RECOMPENSA
↓
PRÓXIMA SALA
↓
UPGRADE / TESOURO / LOJA
↓
ELITE
↓
BOSS
↓
VITÓRIA OU DERROTA
↓
RESULTADOS
↓
MAPA
```

---

# 12. MENU PRINCIPAL

Criar visual Dark Fantasy Pixel Art.

Cena:

um mago diante de uma enorme lua carmesim.

Elementos ambientais:

- nuvens;
- vento;
- partículas;
- brilho mágico;
- manto animado;
- cajado pulsando.

Logo:

# CRIMSON MAGE

Botões:

```text
JOGAR

CONTINUAR RUN
(somente se existir run válida)

MAGOS

MELHORIAS

CONFIGURAÇÕES

CRÉDITOS
```

Mostrar:

- moedas permanentes;
- versão.

---

# 13. MAPA-PERGAMINHO

Ao selecionar:

```text
JOGAR
```

um pergaminho:

1. entra de fora da tela;
2. gira;
3. desacelera;
4. desenrola;
5. ocupa o centro;
6. revela o mapa.

Regiões:

```text
1. Deserto Carmesim

2. Floresta Amaldiçoada

3. Vale Nevado

4. Santo Graal

5. Palácio dos Arcanjos

6. Inferno Profundo
```

Estados:

```text
LOCKED
UNLOCKED
COMPLETED
```

Inicialmente apenas:

```text
FASE 1
```

fica desbloqueada.

---

# 14. SELEÇÃO DE MAGO

Exibir:

## MAGO DE GELO

Inicialmente desbloqueado.

## MAGO DE FOGO

Bloqueado inicialmente.

Preço:

```text
500 Saved Coins
```

## MAGO DE RAIO

Bloqueado inicialmente.

Preço:

```text
1500 Saved Coins
```

Mostrar:

- retrato;
- HP;
- Shield;
- Mana;
- Attack;
- Skill;
- Passive;
- descrição.

---

# 15. CONTROLES MOBILE

Landscape.

Lado esquerdo:

## Joystick virtual

Características:

- analógico;
- 360°;
- área confortável;
- responsivo;
- feedback visual.

Lado direito:

```text
ATTACK

SKILL

DASH
```

Multitouch obrigatório.

Jogador precisa conseguir simultaneamente:

```text
andar + atacar

andar + dash

andar + skill
```

---

# 16. INPUT PARA DESENVOLVIMENTO

Durante desenvolvimento no PC:

```text
WASD = movimento

Mouse esquerdo = ataque

Space = dash

Q = habilidade
```

Os controles desktop não devem impedir os controles mobile.

---

# 17. PLAYER FOUNDATION

O primeiro personagem desenvolvido completamente é:

# MAGO DE GELO

Criar arquitetura reutilizável.

Componentes possíveis:

```text
Player

HealthComponent

ShieldComponent

ManaComponent

Hitbox

Hurtbox

AnimationController

MageData
```

---

# 18. MOVIMENTO

Movimento:

- 360°;
- responsivo;
- velocidade normalizada;
- sem vantagem diagonal;
- colisão consistente;
- aceleração/desaceleração leve.

Valor inicial:

```text
Move Speed ≈ 180 px/s
```

Deixar configurável.

---

# 19. CÂMERA

Top-down.

Implementar:

- smoothing;
- limites da sala;
- pequeno look-ahead;
- screen shake;
- comportamento especial em boss.

Screen shake:

```text
Hit leve
Explosão média
Boss forte
```

Não exagerar.

---

# 20. STATUS DO PLAYER

Valores iniciais:

```text
HP = 8

Shield = 5

Mana = 100
```

---

# 21. HP

Quando HP chega a zero:

1. bloquear inputs;
2. impedir novas ações;
3. executar morte;
4. marcar run como morta;
5. remover possibilidade de continuar;
6. mostrar derrota.

Não deixar lógica depender de HP negativo.

---

# 22. SHIELD

Shield recebe dano antes do HP.

Exemplo:

```text
Shield = 3
Damage = 5
```

Resultado:

```text
Shield = 0
HP perde 2
```

Após aproximadamente:

```text
4 segundos
```

sem dano:

começar regeneração.

Todos os valores devem ser configuráveis.

---

# 23. MANA

Mana máxima inicial:

```text
100
```

Ice Bolt inicialmente:

```text
10 Mana
```

Sem mana suficiente:

não atacar.

Mostrar feedback visual e sonoro.

Mana também possui regeneração passiva lenta.

Inimigos podem liberar:

```text
Mana Orb
```

---

# 24. DASH

Inicialmente:

```text
Duration ≈ 0.20 s

Invulnerability ≈ 0.15 s

Cooldown ≈ 1.2 s
```

Durante dash:

- velocidade aumenta;
- iframe;
- efeito visual;
- som;
- trail discreto.

---

# 25. MAGO DE GELO

Identidade:

```text
CONTROLE + SOBREVIVÊNCIA
```

Ataque básico:

# ICE BOLT

Características:

- projétil rápido;
- dano médio;
- Slow;
- acumulação de Freeze.

Skill:

# BLIZZARD

Área que:

- causa dano periódico;
- reduz velocidade;
- acumula Freeze.

Passiva:

```text
Inimigos congelados recebem dano adicional.
```

---

# 26. PROJECTILE SYSTEM

Criar base reutilizável.

```text
ProjectileBase
```

Possíveis propriedades:

```text
damage

speed

lifetime

element

piercing

critical_chance

status_effect

knockback
```

Implementar pooling.

Não criar/destruir centenas de projéteis constantemente.

---

# 27. AUTO AIM

Ativo por padrão.

Considerar:

- distância;
- direção;
- linha de visão;
- ameaça;
- alvo vivo.

Não trocar de alvo freneticamente.

Utilizar lock curto.

Se alvo:

- morrer;
- sair do alcance;
- ficar inválido;

procurar novo.

---

# 28. STATUS EFFECTS

Criar arquitetura genérica:

```text
StatusEffect
```

Tipos:

```text
Slow

Freeze

Burn

Shock

Stun

Poison
```

Configurações:

```text
duration
strength
stacking_behavior
```

---

# 29. FREEZE

Ataques de gelo acumulam Freeze Meter.

Quando limite for atingido:

```text
FREEZE
```

Durante congelamento:

- inimigo para;
- não ataca;
- recebe feedback visual.

Depois:

adicionar imunidade temporária curta para evitar freeze infinito.

---

# 30. GAME FEEL

Todo hit relevante deve poder gerar:

- flash;
- partículas;
- som;
- damage number;
- knockback;
- hit stop;
- pequena vibração.

Hit stop aproximadamente:

```text
20–50 ms
```

dependendo do golpe.

---

# 31. CRITICAL HIT

Preparar arquitetura.

Crítico deve possuir:

- número diferenciado;
- impacto diferenciado;
- som;
- partículas.

Mesmo que inicialmente o player tenha:

```text
0% Critical Chance
```

---

# 32. PRIMEIROS INIMIGOS

## SAND CRAWLER

Melee rápido.

- persegue;
- aproxima;
- ataca;
- recebe dano;
- morre;
- libera loot.

## DESERT ARCHER

Ranged.

- mantém distância;
- mira;
- telegraph;
- dispara;
- reposiciona.

Projéteis inimigos devem ser visualmente claros.

---

# 33. OUTROS INIMIGOS DO DESERTO

## SAND GUARDIAN

Tank.

- lento;
- alta vida;
- ataque pesado;
- knockback.

## SCORPION

- rápido;
- investida;
- ferrão;
- veneno opcional.

## MUMMY

- lenta;
- persegue;
- pode reviver uma vez.

---

# 34. ARENAS

Ao entrar:

```text
PORTAS FECHAM
```

Depois:

```text
INIMIGOS
```

Quando todos morrerem:

```text
PORTAS ABREM
```

---

# 35. WAVES

Criar:

```text
WaveManager
```

Exemplo:

```text
Wave 1
3 Crawlers

Wave 2
2 Crawlers + Archer

Wave 3
Crawler + Archer + Guardian
```

Nunca spawnar inimigos diretamente em cima do jogador.

---

# 36. DIFFICULTY BUDGET

Cada inimigo possui custo.

Exemplo:

```text
Crawler = 1

Archer = 2

Guardian = 3

Elite = 4
```

Sala inicial:

```text
4–5 pontos
```

Salas avançadas:

```text
8–10+
```

Balancear através de playtests.

---

# 37. ESTRUTURA DAS SALAS

Não gerar geometria totalmente aleatória.

Utilizar:

# ROOM TEMPLATES

Cada template define:

- portas;
- paredes;
- obstáculos;
- spawn zones;
- posições especiais;
- hazards;
- baús.

Criar inicialmente:

```text
10–15 layouts
```

para o Deserto.

---

# 38. GERAÇÃO DA RUN

Utilizar templates aprovados.

Estrutura típica:

```text
START
↓
COMBAT
↓
COMBAT
↓
REWARD
↓
COMBAT
↓
SHOP / TREASURE
↓
ELITE
↓
BOSS
```

Uma fase deve ter aproximadamente:

```text
6–8 salas
```

A ordem pode variar.

Nunca gerar:

- mapa sem caminho;
- boss logo no começo;
- combinação impossível;
- tesouro depois do boss.

---

# 39. MINI MAP

Estados:

```text
UNKNOWN

VISITED

CURRENT

TREASURE

SHOP

BOSS
```

Não é necessário mostrar tudo antecipadamente.

---

# 40. SISTEMA ROGUELITE

Durante a run:

```text
ESCOLHA 1 DE 3
```

Exemplos:

```text
+15% Ice Damage

+20 Mana

+1 Shield

Freeze dura mais

Ice Bolt atravessa inimigo

Ice Bolt lança dois projéteis

Dash cria Ice Trail

Frozen Enemy explode ao morrer

Blizzard maior

Blizzard dura mais

Matar congelado recupera Mana
```

---

# 41. UPGRADES TRANSFORMADORES

Não utilizar apenas:

```text
+5%
+10%
+15%
```

Criar efeitos que alterem gameplay.

Exemplos:

## FROZEN EXPLOSION

Inimigo congelado explode ao morrer.

## ICE TRAIL

Dash deixa trilha congelante.

## SPLINTER

Ice Bolt se divide.

## CHAIN FREEZE

Freeze espalha acúmulo próximo.

---

# 42. RARIDADE

Categorias:

```text
COMMON

RARE

EPIC

LEGENDARY
```

Raridades maiores podem modificar profundamente builds.

Evitar combinações infinitamente quebradas sem limite.

---

# 43. BAÚ

Estados:

```text
CLOSED

OPENING

OPENED
```

Ao abrir:

- animação;
- áudio;
- partículas;
- recompensa.

Não permitir abrir duas vezes.

---

# 44. LOJA DA RUN

Compras usando:

# RUN COINS

Itens:

- Health Potion;
- Mana Potion;
- Shield Recharge;
- Temporary Upgrade;
- Relic.

Mostrar:

- nome;
- descrição;
- preço.

Sem moedas:

item indisponível.

---

# 45. ELITES

Possíveis modificadores:

```text
Frenzied

Armored

Explosive

Fast

Vampiric
```

Elite precisa ser visualmente identificável.

---

# 46. SISTEMA DE MOEDAS — REGRA DEFINITIVA

Existem EXATAMENTE dois tipos de moeda.

---

# 47. RUN COINS

Gerenciadas pelo:

```text
RunManager
```

Obtidas dentro da run.

Servem para:

- loja da run;
- compras temporárias.

Existem apenas no:

```text
RunSave
```

Não são imediatamente permanentes.

---

# 48. SAVED COINS

Gerenciadas pelo:

```text
ProgressionManager
```

São permanentes.

Utilizadas para:

- Mago de Fogo;
- Mago de Raio;
- upgrades permanentes.

Aparecem:

- menu;
- mapa;
- tela dos magos;
- loja permanente.

---

# 49. MORTE E MOEDAS

Quando o jogador MORRER:

```text
PERDER TODAS AS RUN COINS
```

Nenhuma é adicionada ao progresso permanente.

Tela de derrota:

```text
Moedas perdidas: X
```

Fluxo:

```text
PLAYER DIES
↓
RUN STATUS = DEAD
↓
RUN COINS PERDIDAS
↓
RUN SAVE INVALIDADO
↓
DERROTA
```

---

# 50. ABANDONO

Fechar o aplicativo NÃO significa abandono.

Abandono ocorre apenas por ação explícita.

Exemplos:

- `Abandonar Run`;
- sair para o mapa confirmando abandono;
- começar nova run substituindo a atual.

Antes:

```text
ABANDONAR RUN?

Você perderá:

245 moedas da run
3 upgrades
1 relíquia

Esta ação não poderá ser desfeita.
```

Se confirmar:

```text
RUN STATUS = ABANDONED
```

e:

- perder Run Coins;
- remover RunSave;
- voltar ao mapa.

---

# 51. FECHAR O APP

Se o jogador:

- minimizar;
- fechar;
- bloquear celular;
- receber ligação;
- tiver aplicativo encerrado pelo sistema;
- reiniciar aparelho;

não perder automaticamente a run.

O jogo deve usar:

```text
RunSave
```

Na próxima abertura:

```text
CONTINUAR RUN
```

---

# 52. TRANSFERÊNCIA NA VITÓRIA

Run Coins só viram Saved Coins quando:

```text
BOSS DERROTADO
+
FASE CONCLUÍDA
```

Exemplo:

```text
Run Coins obtidas = 320

Gastou na loja = 90

Restante = 230
```

Resultado:

```text
Saved Coins += 230
```

Tela:

```text
Moedas salvas: +230

Total: 780
```

---

# 53. RUN ID

Toda run possui identificador único:

```text
run_id
```

Não depender exclusivamente de horário.

Exemplo conceitual:

```text
RUN_<UUID>
```

---

# 54. RUN STATES

Estados obrigatórios:

```text
ACTIVE

DEAD

ABANDONED

COMPLETED_PENDING_BANK

COMPLETED
```

## ACTIVE

Pode continuar.

## DEAD

Não pode continuar.

## ABANDONED

Não pode continuar.

## COMPLETED_PENDING_BANK

Boss vencido; transferência precisa ser concluída/validada.

## COMPLETED

Finalizada.

---

# 55. TRANSFERÊNCIA IDEMPOTENTE

Nunca permitir moedas duplicadas por:

- crash;
- force close;
- reinício;
- repetição de save.

No PermanentSave registrar algo equivalente:

```text
last_banked_run_id
```

Fluxo:

```text
BOSS DERROTADO
↓
RUN STATUS = COMPLETED_PENDING_BANK
↓
SALVAR RUN
↓
CARREGAR PERMANENT SAVE
↓
VERIFICAR run_id
```

Se ainda não processada:

```text
Saved Coins += Run Coins
```

Depois:

```text
last_banked_run_id = run_id
```

Gravar PermanentSave.

Validar.

Depois:

```text
RUN STATUS = COMPLETED
```

Então limpar RunSave.

---

# 56. CRASH DURANTE TRANSFERÊNCIA

Se abrir jogo com:

```text
COMPLETED_PENDING_BANK
```

verificar:

```text
last_banked_run_id
```

Se run já processada:

NÃO transferir novamente.

Apenas finalizar limpeza.

Se ainda não:

concluir transferência UMA VEZ.

---

# 57. ECONOMIA INICIAL

Dados configuráveis.

## Mago de Fogo

```text
500 Saved Coins
```

## Mago de Raio

```text
1500 Saved Coins
```

---

# 58. RECOMPENSA DA FASE 1

Meta:

```text
150–300 Run Coins
```

por vitória razoavelmente completa antes de gastos.

Distribuir através de:

- inimigos;
- elites;
- tesouros;
- boss;
- eventos.

---

# 59. META DE DESBLOQUEIO

## Fire Mage

Meta:

```text
2–4 vitórias
```

na Fase 1.

## Lightning Mage

Meta:

aproximadamente:

```text
5–8 vitórias adicionais
```

caso o jogador não gaste grande parte das moedas em outras melhorias.

Essas são metas de balanceamento, não garantias matemáticas.

---

# 60. UPGRADES PERMANENTES

Exemplos:

```text
MAX HP

MAX MANA

SHIELD

DAMAGE

MANA REGENERATION

DASH COOLDOWN
```

Cada upgrade:

- nível atual;
- nível máximo;
- custo crescente;
- efeito configurável.

---

# 61. SAVE SYSTEM — DOIS SAVES

Separar:

# PermanentSave

e:

# RunSave

---

# 62. PERMANENT SAVE

Salvar:

```text
save_version

saved_coins

unlocked_mages

unlocked_stages

completed_stages

permanent_upgrades

tutorial_completed

settings

statistics

last_banked_run_id
```

---

# 63. RUN SAVE

Somente UM ativo por vez.

Salvar:

```text
run_id

run_status

stage_id

mage_id

generation_seed

room_graph

room_index

current_room_id

rooms_completed

room_states

HP

Shield

Mana

Run Coins

selected_upgrades

relics

purchased_items

opened_chests

visited_shops

difficulty_state

elapsed_time
```

Adicionar outros dados necessários para restaurar a run corretamente.

---

# 64. NÃO DEPENDER SOMENTE DA SEED

Seed deve existir.

Mas salvar também:

```text
room_graph
```

e estados relevantes.

Objetivo:

a run deve continuar igual mesmo se o algoritmo procedural for alterado futuramente.

---

# 65. AUTOSAVE

Salvar RunSave:

```text
AO ENTRAR EM NOVA SALA

AO CONCLUIR SALA

APÓS ESCOLHER UPGRADE

APÓS ABRIR BAÚ

APÓS COMPRAR ITEM

APÓS OBTER RELÍQUIA

AO IR PARA BACKGROUND
```

Quando necessário:

salvar antes/depois de operações críticas.

---

# 66. CONSISTÊNCIA DE TRANSAÇÕES

Não salvar no meio de estado inválido.

Exemplo ruim:

```text
remove moedas
↓
SAVE
↓
entrega item
```

Crash pode fazer jogador:

```text
PERDER DINHEIRO
SEM RECEBER ITEM
```

Operações devem ser aplicadas de maneira logicamente atômica.

---

# 67. SAFE WRITE

PermanentSave e RunSave:

```text
DADOS
↓
TEMP FILE
↓
VALIDAR
↓
BACKUP
↓
SUBSTITUIR SAVE PRINCIPAL
```

Nunca destruir save válido antes de validar o novo.

---

# 68. CONTINUAR RUN

Se:

```text
RunSave válido
+
run_status = ACTIVE
```

mostrar:

```text
CONTINUAR RUN
```

Restaurar:

- personagem;
- fase;
- sala;
- mapa;
- HP;
- Shield;
- Mana;
- Run Coins;
- upgrades;
- relíquias;
- itens;
- estado necessário.

---

# 69. SAVE SCUMMING

Não implementar servidor ou DRM.

O jogo permanece offline.

Porém:

```text
DEAD
ABANDONED
COMPLETED
```

nunca podem retornar para:

```text
ACTIVE
```

através do fluxo normal.

O sistema deve dificultar explorações comuns, sem prometer proteção absoluta contra manipulação externa de arquivos.

---

# 70. TUTORIAL

Primeira sala da primeira run da Fase 1.

Tutorial curto, interativo.

Mostrar UMA instrução por vez.

---

# 71. TUTORIAL — MOVIMENTO

Mostrar:

```text
Use o joystick para se mover.
```

Avançar somente após movimentação real.

---

# 72. TUTORIAL — ATAQUE

```text
Use o botão de ataque.
```

Avançar após ataque.

---

# 73. TUTORIAL — DASH

```text
Use o Dash para escapar de ataques.
```

Avançar após dash.

---

# 74. TUTORIAL — HABILIDADE

```text
Use sua habilidade especial.
```

Avançar após Skill.

---

# 75. INIMIGOS DE TREINO

Adicionar:

```text
1–2 inimigos
```

extremamente fracos.

Não devem destruir o jogador durante o aprendizado.

---

# 76. MANA NO TUTORIAL

Nos primeiros passos:

impedir falta de mana de atrapalhar aprendizado.

Mas ao ensinar Mana Orb:

colocar, por exemplo:

```text
Mana = 50 / 100
```

Inimigo libera Orb.

Jogador coleta.

Mostrar:

```text
Orbes de Mana restauram sua energia mágica.
```

---

# 77. MOEDAS NO TUTORIAL

Mostrar:

```text
Moedas da run podem ser utilizadas nas lojas durante a partida.

Elas só se tornam permanentes quando você derrota o chefe.
```

Não usar texto excessivo.

---

# 78. PULAR TUTORIAL

Botão:

```text
PULAR TUTORIAL
```

Depois de confirmar:

```text
tutorial_completed = true
```

Salvar no PermanentSave.

---

# 79. REFAZER TUTORIAL

Configurações:

```text
REFAZER TUTORIAL
```

Permitir executar novamente sem necessariamente redefinir o progresso.

---

# 80. MAGO DE FOGO

Depois do vertical slice.

Identidade:

```text
DANO EM ÁREA + BURN
```

Ataque:

# FIREBALL

- explosão;
- AOE;
- Burn.

Skill:

# METEOR RAIN

Passiva:

inimigos queimados possuem maior chance de liberar Mana Orb.

---

# 81. MAGO DE RAIO

Identidade:

```text
VELOCIDADE + CHAIN DAMAGE
```

Ataque:

# LIGHTNING BOLT

Pula entre inimigos.

Skill:

# THUNDERSTORM

Passiva:

- ataques rápidos;
- mana mais eficiente.

---

# 82. COMBOS ELEMENTAIS

## ICE + LIGHTNING

# STATIC FREEZE

Paralisação em área.

## FIRE + ICE

# STEAM BURST

Explosão de vapor + Stun.

## FIRE + LIGHTNING

# PLASMA EXPLOSION

Grande dano instantâneo.

Mostrar:

```text
COMBO!
```

com feedback audiovisual.

---

# 83. BOSS DO DESERTO

# FARAÓ SOMBRIO

Três fases.

---

# 84. BOSS — INTRO

Ao entrar:

1. portas fecham;
2. controle é bloqueado brevemente;
3. câmera enquadra boss;
4. apresentação;
5. nome;
6. barra de HP;
7. música muda;
8. combate inicia.

Não criar cutscene longa.

---

# 85. FARAÓ — FASE 1

HP:

```text
100% → 70%
```

Ataques:

- Projectile Fan;
- Dark Orb;
- Summon Mummy.

---

# 86. FARAÓ — FASE 2

HP:

```text
70% → 35%
```

Adicionar:

- Sand Pillars;
- Dash Attack;
- stronger summons;
- hazards.

---

# 87. FARAÓ — FASE 3

HP:

```text
35% → 0%
```

Mais agressivo.

Combinar:

- projéteis;
- investidas;
- summons;
- area attacks.

---

# 88. REGRA DE BOSS DESIGN

Todo ataque perigoso:

```text
TELEGRAPH
↓
ATTACK
↓
RECOVERY
```

O jogador deve entender:

> “O que me acertou?”

Não criar dano inevitável.

---

# 89. MORTE DO BOSS

Ao chegar em zero:

- cancelar ataques;
- limpar projéteis perigosos;
- breve slow motion;
- impacto final;
- animação de morte;
- partículas;
- música;
- chuva de moedas;
- baú especial;
- portal.

Depois:

```text
COMPLETED_PENDING_BANK
```

e executar transação segura.

---

# 90. TELA DE VITÓRIA

Mostrar:

```text
FASE CONCLUÍDA

Tempo

Inimigos derrotados

Dano causado

Moedas salvas: +X

Novo total

Upgrades

Boss
```

Botões:

```text
VOLTAR AO MAPA

JOGAR NOVAMENTE
```

---

# 91. TELA DE DERROTA

Mostrar:

```text
RUN ENCERRADA

Tempo

Salas

Kills

Boss Progress

Moedas perdidas: X
```

Botões:

```text
TENTAR NOVAMENTE

VOLTAR AO MAPA
```

---

# 92. BIOMA 1

# DESERTO CARMESIM

Visual:

- dunas;
- ossos;
- cactos;
- ruínas;
- areia;
- tochas;
- estátuas.

Hazards:

- areia lenta;
- espinhos;
- armadilhas;
- barris.

Boss:

# FARAÓ SOMBRIO

---

# 93. BIOMA 2

# FLORESTA AMALDIÇOADA

Visual:

- árvores retorcidas;
- névoa;
- cogumelos;
- raízes;
- olhos.

Hazards:

- raízes;
- veneno.

Inimigos:

```text
Shadow Wolf

Living Tree

Spider

Dark Spirit

Summoner
```

Boss:

# ÁRVORE CORROMPIDA

---

# 94. BIOMA 3

# VALE NEVADO

Visual:

- neve;
- gelo;
- pinheiros;
- cristais.

Hazards:

- gelo;
- piso escorregadio.

Inimigos:

```text
Ice Wolf

Snow Golem

Frozen Spirit

Crystal Archer
```

Boss:

# REI GÉLIDO

Inimigos de gelo devem ter maior resistência ao gelo.

Não imunidade absoluta.

---

# 95. BIOMA 4

# SANTO GRAAL

Visual:

- santuários;
- vitrais;
- dourado;
- estátuas;
- templos.

Hazards:

- feixes de luz.

Inimigos:

```text
Spectral Knight

Guardian

Holy Archer

Possessed Statue
```

Boss:

# GUARDIÃO DO GRAAL

---

# 96. BIOMA 5

# PALÁCIO DOS ARCANJOS

Visual:

- nuvens;
- ouro;
- mármore;
- colunas;
- céu.

Hazards:

- feixes;
- energia sagrada.

Inimigos:

```text
Angel Soldier

Sentinel

Winged Warrior

Light Caster
```

Boss:

# ARCANJO SUPREMO

---

# 97. BIOMA 6

# INFERNO PROFUNDO

Visual:

- lava;
- correntes;
- fogo;
- pedras vermelhas;
- demônios.

Hazards:

- lava;
- erupções;
- chamas.

Inimigos:

```text
Imp

Hellhound

Demon Warrior

Fire Caster

Infernal Brute
```

Boss:

# LORDE DO ABISMO

Boss final com três fases complexas.

---

# 98. REGRA DE NOVOS BIOMAS

Não criar apenas:

```text
mesmos inimigos + textura diferente
```

Cada bioma deve introduzir:

- mecânica;
- hazard;
- inimigos;
- boss;
- identidade visual;
- música.

---

# 99. DIFICULDADE

Não aumentar dificuldade apenas através de HP.

Utilizar:

- novos padrões;
- sinergias entre inimigos;
- hazards;
- velocidade;
- posicionamento;
- combinações.

Evitar bullet sponges.

---

# 100. LOADING SCREENS

Cada bioma possui sua tela.

Mostrar:

- artwork;
- nome;
- descrição curta;
- dica;
- mago escolhido animado;
- progress bar.

A barra deve representar:

# CARREGAMENTO REAL

e não um timer falso.

Tempo mínimo visual:

```text
≈ 1–1.5 segundos
```

para evitar flash.

---

# 101. MEMORY LOADING

Ao entrar em bioma:

carregar assets necessários.

Ao sair:

liberar recursos específicos quando possível.

Não manter assets das seis fases carregados sem necessidade.

---

# 102. PIXEL ART

Direção:

# DARK FANTASY PIXEL ART

Características:

- silhuetas claras;
- outlines;
- paleta controlada;
- contraste;
- leitura rápida;
- magia vibrante.

Texture filtering:

```text
NEAREST
```

Nunca borrar sprites.

---

# 103. ANIMAÇÕES

Não exigir arbitrariamente cinco frames para absolutamente tudo.

Usar quantidade apropriada.

## Player

```text
Idle: 6–8

Walk: 6–8

Attack: 6–10

Dash: 4–6

Skill: 8–12

Damage: 3–5

Death: 8–12
```

Boss attacks:

```text
8–16
```

quando necessário.

Prioridade:

```text
QUALIDADE DO MOVIMENTO
>
NÚMERO ARBITRÁRIO DE FRAMES
```

---

# 104. VFX

Criar biblioteca reutilizável.

## ICE

- shards;
- snow;
- freeze burst.

## FIRE

- sparks;
- flames;
- smoke;
- explosions.

## LIGHTNING

- arcs;
- flashes;
- electric particles.

Não prejudicar performance ou legibilidade.

---

# 105. ÁUDIO

Buses:

```text
Master

Music

SFX

UI
```

Ice:

- cristal;
- impacto seco.

Fire:

- explosão;
- combustão.

Lightning:

- crackle;
- descarga.

Sons:

- dash;
- hit;
- enemy death;
- coin;
- mana;
- chest;
- door;
- shop;
- boss;
- UI.

---

# 106. MÚSICA DINÂMICA

Estados:

```text
EXPLORATION

COMBAT

BOSS
```

Pode utilizar layers.

Transições suaves.

---

# 107. MOBILE LIFECYCLE

Quando aplicativo perde foco:

1. autosave;
2. pausar;
3. congelar gameplay;
4. interromper timers perigosos;
5. impedir inimigos de atacar.

Quando jogador volta:

NÃO continuar automaticamente.

Mostrar:

```text
CONTINUAR
```

---

# 108. PAUSE MENU

Botões:

```text
CONTINUAR

CONFIGURAÇÕES

REINICIAR RUN

ABANDONAR RUN
```

Ações destrutivas precisam de confirmação.

---

# 109. SETTINGS

Configurações:

```text
Master Volume

Music Volume

SFX Volume

Language

Vibration

Auto Aim

Screen Shake

Damage Numbers

Graphics Quality
```

Salvar permanentemente.

---

# 110. ACESSIBILIDADE

Quando possível:

- reduzir screen shake;
- reduzir flashes;
- tamanho de UI;
- contraste de projéteis;
- intensidade de vibração;
- legibilidade.

---

# 111. OBJECT POOLING

Criar:

```text
PoolManager
```

Pooling para:

- player projectiles;
- enemy projectiles;
- particles;
- damage numbers;
- loot;
- inimigos quando apropriado.

---

# 112. PERFORMANCE BUDGET

Meta inicial aproximada:

```text
20 inimigos

100 projéteis

150 partículas importantes
```

Não são valores rígidos.

Validar com profiling.

Se FPS cair:

primeiro reduzir:

- partículas;
- efeitos secundários;
- detalhes não essenciais.

Não sacrificar gameplay antes.

---

# 113. MOBILE OPTIMIZATION

Testar:

- 720p;
- 1080p;
- diferentes aspect ratios;
- aparelhos diferentes.

Monitorar:

- draw calls;
- memória;
- frame time;
- partículas;
- allocations.

Evitar shaders pesados desnecessários.

---

# 114. DEBUG MENU

Somente Development Build.

Adicionar:

```text
God Mode

Kill All

Teleport Next Room

Teleport Boss

Unlock All

Lock All

Spawn Enemy

Give Upgrade

Give Relic

Reset Run

Reset Permanent Save

Show FPS

Show Entity Count

Show Collisions

Show AI State
```

---

# 115. DEBUG DE ECONOMIA

Adicionar:

```text
+100 Saved Coins

+500 Saved Coins

Set Saved Coins

Set Run Coins

Set Fire Mage Price

Set Lightning Mage Price

Coin Drop Multiplier

Boss Reward

Chest Reward

Shop Price Multiplier
```

Nunca disponibilizar no release.

---

# 116. TELEMETRIA DE DESENVOLVIMENTO

Exibir opcionalmente:

```text
FPS

Frame Time

Enemies

Projectiles

Particles

Nodes

Memory
```

---

# 117. PROGRESS.MD

Criar na raiz:

```text
PROGRESS.md
```

Obrigatório.

Esse arquivo é a memória operacional do desenvolvimento.

---

# 118. ESTRUTURA DO PROGRESS.MD

```text
# CRIMSON MAGE DEVELOPMENT STATUS

## CURRENT BLOCK

## CURRENT STAGE

## COMPLETED

## CURRENTLY WORKING

## WORKING FEATURES

## KNOWN BUGS

## IMPORTANT DESIGN DECISIONS

## IMPORTANT ARCHITECTURAL DECISIONS

## ECONOMY SETTINGS

## SAVE SYSTEM STATUS

## LOCALIZATION STATUS

## LAST TESTED BUILD

## LAST TEST RESULTS

## NEXT STEP
```

---

# 119. LAST TESTED BUILD

Registrar honestamente:

```text
Godot Version:

Windows:
PASS / FAIL / NOT TESTED

Android:
PASS / FAIL / NOT TESTED

iOS:
PASS / FAIL / NOT TESTED
```

Nunca colocar:

```text
PASS
```

sem realmente testar.

---

# 120. IMPORTANT DECISIONS

Registrar decisões permanentes.

Exemplos:

```text
Run Coins and Saved Coins are separate.

Run Coins bank only after victory.

Closing app does not abandon a run.

Fire Mage costs 500.

Lightning Mage costs 1500.

RunSave and PermanentSave are separate.

UI strings use localization keys.

ProjectileBase must be reused.
```

---

# 121. NOVA SESSÃO

Quando iniciar nova conversa ou sessão:

PRIMEIRO:

1. ler `PROGRESS.md`;
2. analisar projeto real;
3. verificar código;
4. identificar bloco;
5. identificar etapa;
6. continuar.

Não recriar sistemas funcionando.

---

# 122. PROGRESS.MD NÃO É VERDADE ABSOLUTA

Se `PROGRESS.md` disser:

```text
Sistema funcionando
```

mas o código não confirmar:

investigar.

Código e testes têm prioridade.

Depois:

corrigir `PROGRESS.md`.

---

# 123. DESENVOLVIMENTO EM BLOCOS

O projeto deve ser executado em blocos.

Dentro do bloco:

```text
CONTINUE AUTOMATICAMENTE
```

Ao terminar:

```text
TESTE
↓
CORRIJA
↓
ATUALIZE PROGRESS.md
↓
PARE
```

Aguardar o usuário dizer:

```text
continuar
```

antes do próximo bloco.

---

# 124. BLOCO 1 — FOUNDATION

Implementar:

1. projeto Godot;
2. estrutura;
3. resolução;
4. landscape;
5. safe area;
6. Input Map;
7. GameManager;
8. SceneManager;
9. sistema de localização básico;
10. tela Boot;
11. estrutura básica de save;
12. `PROGRESS.md`.

### DONE

Somente quando:

- abre;
- troca cenas;
- resolução funciona;
- input funciona;
- localização inicializa;
- sem erro crítico.

---

# 125. BLOCO 2 — PLAYER & COMBAT CORE

Implementar:

1. Ice Mage;
2. movimentação;
3. joystick;
4. multitouch;
5. câmera;
6. HP;
7. Shield;
8. Mana;
9. Dash;
10. Ice Bolt;
11. Auto Aim;
12. Freeze;
13. Blizzard;
14. hit feedback.

### DONE

Quando player estiver realmente divertido de controlar.

---

# 126. BLOCO 3 — ENEMIES & ROOMS

Implementar:

1. EnemyBase;
2. Crawler;
3. Archer;
4. Guardian;
5. Scorpion;
6. Mummy;
7. arenas;
8. portas;
9. spawns;
10. waves;
11. difficulty budget;
12. room templates.

### DONE

Quando várias salas de combate puderem ser jogadas sem falha.

---

# 127. BLOCO 4 — ROGUELITE & ECONOMY

Implementar:

1. RunManager;
2. Run Coins;
3. Loot Tables;
4. Mana Orbs;
5. Coin Pickups;
6. upgrades;
7. raridades;
8. relics;
9. Treasure Room;
10. Shop;
11. Elite enemies;
12. EconomyData;
13. debug econômico.

---

# 128. BLOCO 5 — RUN GENERATION & BOSS

Implementar:

1. procedural room sequence;
2. room graph;
3. mini-map;
4. Faraó;
5. 3 fases;
6. boss intro;
7. boss death;
8. victory;
9. defeat;
10. banking de moedas;
11. `run_id`;
12. estados;
13. transferência idempotente.

### OBJETIVO

Vertical Slice da Fase 1 completo.

---

# 129. BLOCO 6 — SAVE, TUTORIAL & META

Implementar:

1. PermanentSave completo;
2. RunSave;
3. safe write;
4. autosave;
5. Continue Run;
6. abandon run;
7. lifecycle mobile;
8. tutorial;
9. tutorial_completed;
10. refazer tutorial;
11. upgrades permanentes;
12. loja de magos;
13. Fire/Lightning prices;
14. localization completa das telas existentes.

---

# 130. BLOCO 7 — MENUS & MAGOS

Implementar:

1. Main Menu final;
2. pergaminho;
3. mapa;
4. seleção de magos;
5. Mago de Fogo;
6. Mago de Raio;
7. Burn;
8. Shock;
9. combos elementais;
10. loading;
11. settings.

---

# 131. BLOCO 8 — FLORESTA

Criar completamente:

# FLORESTA AMALDIÇOADA

Incluindo:

- assets;
- tiles;
- templates;
- hazards;
- enemies;
- boss;
- música;
- loading;
- balanceamento.

Não iniciar próximo bioma até terminar.

---

# 132. BLOCO 9 — NEVE

Criar:

# VALE NEVADO

Completo.

---

# 133. BLOCO 10 — GRAAL

Criar:

# SANTO GRAAL

Completo.

---

# 134. BLOCO 11 — ARCANJOS

Criar:

# PALÁCIO DOS ARCANJOS

Completo.

---

# 135. BLOCO 12 — INFERNO

Criar:

# INFERNO PROFUNDO

Completo.

Incluindo boss final.

---

# 136. BLOCO 13 — PERFORMANCE & MOBILE

Executar:

- profiling;
- pooling;
- memória;
- loading;
- draw calls;
- Android testing;
- iOS preparation;
- lifecycle;
- safe area;
- multitouch;
- low-end profile;
- battery considerations.

---

# 137. BLOCO 14 — POLISH & RELEASE

Somente depois de tudo funcional:

- VFX final;
- áudio;
- música;
- UI;
- animações;
- transições;
- balanceamento;
- accessibility;
- bugs;
- release build.

---

# 138. REGRA DENTRO DO BLOCO

NÃO perguntar:

```text
Quer que eu continue?
```

entre cada pequena etapa.

Se próxima ação estiver clara:

continue.

---

# 139. REGRA NO FINAL DO BLOCO

Antes de parar:

executar testes.

Se teste essencial falhar:

```text
BLOCO NÃO CONCLUÍDO
```

Corrigir primeiro.

---

# 140. RESUMO OBRIGATÓRIO DO BLOCO

Ao concluir, apresentar:

```text
IMPLEMENTADO

FUNCIONANDO

TESTADO

PROBLEMAS ENCONTRADOS

CORRIGIDO

BUGS CONHECIDOS

PRÓXIMO BLOCO
```

Atualizar:

```text
PROGRESS.md
```

Então parar.

---

# 141. QA DO PLAYER

Validar:

```text
[ ] Move corretamente

[ ] Colide

[ ] Ataca

[ ] Consome Mana

[ ] Mana Orb funciona

[ ] Dash funciona

[ ] Iframe funciona

[ ] Recebe dano

[ ] Shield absorve

[ ] Shield regenera

[ ] HP diminui

[ ] Morre corretamente
```

---

# 142. QA DAS SALAS

```text
[ ] Entrar fecha portas

[ ] Inimigos aparecem

[ ] Waves funcionam

[ ] Todos mortos abre portas

[ ] Spawn não acontece dentro do player

[ ] Inimigos não aparecem fora da arena

[ ] Próxima sala funciona
```

---

# 143. QA DA RUN

```text
[ ] Start

[ ] Combat

[ ] Reward

[ ] Upgrade

[ ] Shop

[ ] Treasure

[ ] Elite

[ ] Boss

[ ] Victory

[ ] Defeat

[ ] Results
```

---

# 144. TESTE DA ECONOMIA — MORTE

Inicial:

```text
Saved Coins = 500
```

Durante run:

```text
Run Coins = 200
```

Morrer.

Esperado:

```text
Saved Coins = 500

Run Coins = perdidas
```

---

# 145. TESTE DA ECONOMIA — VITÓRIA

Inicial:

```text
Saved Coins = 500
```

Final:

```text
Run Coins = 200
```

Vencer.

Esperado:

```text
Saved Coins = 700
```

---

# 146. TESTE DE GASTOS

Durante run:

```text
Run Coins = 300
```

Gastar:

```text
100
```

Vencer.

Esperado:

```text
+200 Saved Coins
```

---

# 147. TESTE DE ABANDONO

Possuir:

```text
250 Run Coins
```

Abandonar.

Esperado:

```text
+0 Saved Coins
```

---

# 148. TESTE DE FECHAR APP

Com run ativa:

1. fechar app;
2. abrir.

Esperado:

```text
CONTINUAR RUN
```

---

# 149. TESTE DE CRASH NA TRANSAÇÃO

Simular fechamento durante:

```text
COMPLETED_PENDING_BANK
```

Abrir novamente.

Resultado:

```text
MOEDAS TRANSFERIDAS EXATAMENTE UMA VEZ
```

Nunca:

```text
+200
+200
```

---

# 150. QA DO RUN SAVE

Validar restauração:

```text
[ ] Stage

[ ] Mage

[ ] Room

[ ] Room Graph

[ ] HP

[ ] Shield

[ ] Mana

[ ] Run Coins

[ ] Upgrades

[ ] Relics

[ ] Purchases

[ ] Opened Chests
```

---

# 151. QA DO TUTORIAL

Primeira run:

```text
Tutorial aparece
```

Segunda:

```text
Tutorial não aparece
```

Refazer:

```text
Tutorial funciona
```

Pular:

```text
Não trava progressão
```

---

# 152. QA DA LOCALIZAÇÃO

Testar:

```text
pt_BR

en
```

Verificar:

- menus;
- tutorial;
- magos;
- upgrades;
- loading;
- settings;
- vitória;
- derrota.

Nunca permitir que chave como:

```text
MENU_PLAY
```

apareça ao jogador por falta de tradução sem ser detectada.

---

# 153. QA DO SAVE PERMANENTE

Fluxo:

1. ganhar moedas;
2. vencer;
3. desbloquear fase;
4. comprar upgrade;
5. comprar mago;
6. fechar jogo;
7. abrir.

Tudo deve permanecer.

Testar também save propositalmente inválido.

Utilizar backup quando apropriado.

---

# 154. MOBILE QA

Testar:

```text
Joystick + Attack

Joystick + Dash

Joystick + Skill

Attack + Skill

Multitouch
```

Também:

- safe area;
- notch;
- aspect ratio;
- background;
- resume.

---

# 155. PERFORMANCE QA

Observar:

- FPS;
- frame time;
- memória;
- projetéis;
- particles;
- enemy count.

Meta:

```text
60 FPS
```

em aparelhos intermediários compatíveis.

---

# 156. NÃO FAZER

Não:

- criar seis biomas antes do combate base;
- criar dezenas de scripts sem testar;
- deixar lógica crítica em TODO;
- duplicar sistemas;
- hardcodar todos os números;
- hardcodar textos;
- usar loading falso;
- misturar Saved Coins e Run Coins;
- considerar fechar app como abandono;
- permitir bank duplicado;
- carregar todos os biomas simultaneamente;
- criar God Object enorme;
- copiar assets protegidos;
- ignorar erros críticos.

---

# 157. PLACEHOLDERS

Se asset final ainda não existe:

pode usar placeholder gráfico.

Exemplos:

- sprite simples;
- silhueta;
- tile temporário.

Mas:

# GAMEPLAY NÃO PODE SER PLACEHOLDER

Não deixar botão sem função dizendo:

```text
TODO
```

quando aquela feature pertence ao bloco atual.

---

# 158. REFACTOR

Antes de alterar sistema funcionando:

1. entender;
2. mapear dependências;
3. alterar mínimo necessário;
4. testar;
5. verificar regressões.

Não substituir arquivos inteiros sem necessidade.

---

# 159. GIT

Quando etapa importante estiver estável:

commits pequenos e claros.

Exemplos:

```text
feat: add ice mage movement

feat: implement run currency

feat: add run save recovery

feat: add desert boss

fix: prevent duplicate coin banking

perf: pool magic projectiles
```

---

# 160. DEBUG VS RELEASE

## DEBUG

Permitido:

- cheats;
- overlays;
- logs;
- profiling.

## RELEASE

Remover/desativar:

- cheats;
- debug menus;
- logs excessivos;
- ferramentas internas.

---

# 161. ANDROID BUILD

Ao final:

preparar:

```text
APK
```

para testes.

E:

```text
AAB
```

para Play Store.

Documentar:

1. Android SDK;
2. Java/JDK se necessário;
3. Godot export templates;
4. keystore;
5. signing;
6. export;
7. instalação em aparelho.

---

# 162. IOS BUILD

Preparar:

- export iOS;
- projeto Xcode;
- configurações necessárias.

Documentar:

- macOS;
- Xcode;
- assinatura;
- Apple Developer quando necessário;
- instalação/teste em iPhone.

---

# 163. DEFINITION OF DONE — FASE 1

A Fase 1 NÃO está pronta até ser possível:

```text
ABRIR O JOGO
↓
MENU
↓
JOGAR
↓
MAPA
↓
DESERTO
↓
ESCOLHER MAGO
↓
LOADING
↓
TUTORIAL NA PRIMEIRA VEZ
↓
MOVER
↓
ATACAR
↓
DASH
↓
SKILL
↓
COMBATER
↓
PEGAR MANA
↓
PEGAR RUN COINS
↓
LIMPAR SALAS
↓
ESCOLHER UPGRADES
↓
ABRIR BAÚ
↓
COMPRAR NA LOJA
↓
ENFRENTAR ELITE
↓
ENFRENTAR FARAÓ
↓
MORRER OU VENCER
↓
RESULTADOS
↓
SALVAR PROGRESSO
↓
FECHAR JOGO
↓
ABRIR NOVAMENTE
↓
PROGRESSO CORRETO
```

---

# 164. DEFINITION OF DONE — JOGO FINAL

Antes de considerar CRIMSON MAGE pronto:

## Gameplay

```text
[ ] Movimento excelente
[ ] Ataques responsivos
[ ] Dash responsivo
[ ] Skills funcionam
[ ] Combate divertido
```

## Magos

```text
[ ] Ice
[ ] Fire
[ ] Lightning
[ ] Combos
```

## Roguelite

```text
[ ] Rooms
[ ] Upgrades
[ ] Relics
[ ] Shop
[ ] Treasure
[ ] Elites
```

## Economy

```text
[ ] Run Coins
[ ] Saved Coins
[ ] Banking seguro
[ ] Mages prices
[ ] Permanent upgrades
```

## Saves

```text
[ ] PermanentSave
[ ] RunSave
[ ] Continue Run
[ ] Backup
[ ] No duplicate banking
```

## Content

```text
[ ] Desert
[ ] Forest
[ ] Snow
[ ] Grail
[ ] Archangel
[ ] Hell
```

## Bosses

```text
[ ] Pharaoh
[ ] Corrupted Tree
[ ] Frozen King
[ ] Grail Guardian
[ ] Supreme Archangel
[ ] Abyss Lord
```

## Localization

```text
[ ] pt_BR
[ ] en
```

## Mobile

```text
[ ] Multitouch
[ ] Landscape
[ ] Safe Area
[ ] Lifecycle
[ ] Android
[ ] iOS preparation
```

## Technical

```text
[ ] Pooling
[ ] Memory control
[ ] Profiling
[ ] Safe save
[ ] No critical errors
```

## Polish

```text
[ ] Pixel art
[ ] Animations
[ ] VFX
[ ] SFX
[ ] Music
[ ] UI feedback
```

---

# 165. PRIORIDADES

Se existir conflito de tempo, qualidade ou complexidade:

```text
1. GAMEPLAY

2. ESTABILIDADE

3. CONTROLES

4. COMBAT FEEL

5. PERFORMANCE

6. SAVE / PROGRESSÃO

7. ROGUELITE

8. BOSS DESIGN

9. UI

10. ARTE

11. QUANTIDADE DE CONTEÚDO
```

Um jogo menor e excelente é melhor que um jogo enorme e quebrado.

---

# 166. REGRA DO AGENTE

Você não deve apenas explicar como alguma coisa poderia ser feita.

Quando estiver trabalhando no projeto:

# IMPLEMENTE.

Antes de alterar:

1. examine código existente;
2. leia `PROGRESS.md`;
3. identifique arquitetura;
4. identifique dependências;
5. implemente;
6. conecte scenes/scripts/resources;
7. execute;
8. examine erros;
9. corrija;
10. teste;
11. atualize `PROGRESS.md`.

---

# 167. ERROS

Se ocorrer:

```text
Parser Error

Invalid Call

Invalid Instance

Missing Node

Missing Resource

Type Mismatch

Scene Dependency Error

Null Reference
```

ou outro erro crítico:

# PARE A EXPANSÃO.

Corrija antes de continuar.

---

# 168. AUTONOMIA

Dentro do bloco atual:

continue automaticamente.

Não perguntar repetidamente:

```text
Quer que eu continue?
```

Quando terminar o bloco:

- testar;
- corrigir;
- documentar;
- parar.

Esperar:

```text
continuar
```

---

# 169. RESULTADO FINAL ESPERADO

CRIMSON MAGE deve parecer um **jogo indie mobile legítimo**, e não uma demonstração técnica.

Uma pessoa que instalar deve compreender rapidamente:

- como andar;
- como atacar;
- como usar Dash;
- como usar Skill;
- como atravessar salas;
- como criar builds;
- como comprar;
- como desbloquear personagens;
- como enfrentar bosses.

O diferencial deve surgir da combinação de:

```text
MAGIA ELEMENTAL

+

BUILDS

+

COMBATE RESPONSIVO

+

SALAS RÁPIDAS

+

BOSSES

+

PROGRESSÃO

+

DARK FANTASY

+

RUNS DIFERENTES
```

---

# 170. PRINCÍPIO FINAL

Antes de criar seis horas de conteúdo:

# CRIE UM MINUTO EXCELENTE.

Depois:

```text
1 minuto excelente
↓
10 minutos excelentes
↓
1 fase excelente
↓
sistemas sólidos
↓
6 fases
↓
jogo completo
```

Nunca inverter essa ordem.

---

# 171. INSTRUÇÃO DE INÍCIO

Ao receber este documento:

## PRIMEIRO

Leia:

```text
MASTER DEVELOPMENT PROMPT

PROGRESS.md
```

se `PROGRESS.md` existir.

Depois analise:

- estrutura;
- cenas;
- scripts;
- Resources;
- Autoloads;
- inputs;
- saves;
- assets;
- sistemas funcionais;
- sistemas incompletos;
- bugs.

## SEGUNDO

Determine:

```text
CURRENT BLOCK

CURRENT STAGE
```

## TERCEIRO

Não recrie nada que já esteja funcionando corretamente.

## QUARTO

Se o projeto ainda estiver vazio:

comece pelo:

# BLOCO 1 — FOUNDATION

## QUINTO

Trabalhe até completar o bloco.

Dentro dele:

```text
IMPLEMENTE
↓
EXECUTE
↓
TESTE
↓
CORRIJA
↓
CONTINUE
```

## SEXTO

No fim:

- execute todos os testes relevantes;
- corrija falhas;
- atualize `PROGRESS.md`;
- apresente resumo;
- pare.

Então aguarde:

```text
continuar
```

antes de iniciar o próximo bloco.

---

# CRIMSON MAGE

## BUILD THE GAME.

## DO NOT BUILD A CHECKLIST THAT PRETENDS TO BE A GAME.

O objetivo final é:

# UM JOGO BOM, JOGÁVEL, ESTÁVEL E DIVERTIDO.
