# CRIMSON MAGE DEVELOPMENT STATUS

## CURRENT BLOCK
Seções 10–15 e ampliação autorizada em 11/10/2026: magos mais detalhados em pixel art, loja de equipamentos, tela para equipar e bônus de dano.

## CURRENT STAGE
Versão 0.3.0-arcane-arsenal: menus corrigidos, arte dos magos redesenhada e equipamentos integrados. Entrega validada; pronta para retomar a partir do NEXT STEP.

## COMPLETED
- Repositório original inspecionado; continha somente README.
- Prompt mestre importado integralmente (quebras de linha normalizadas para LF).
- Escopo desta entrega e orientações de continuidade registrados.
- Projeto Godot 4.5.2, 2D, Compatibility, horizontal, viewport de referência 1280×720.
- Resources tipados para magos, inimigos, loot e economia; validação na inicialização.
- Gelo inicial; Fogo/Raio bloqueados nas definições, com preços 500/1.500.
- Boot conectado ao menu principal; foundation preservada como tela técnica. Navegação protegida contra destinos inválidos e cliques repetidos.
- Catálogos de tradução pt_BR/en já carregados pela engine.
- Detecção inicial do idioma do aparelho; português mapeado para pt_BR e demais idiomas para en.
- Configurações com seleção de idioma, atualização imediata, persistência e retorno à foundation.
- Preferências com arquivo temporário, backup válido, validação de schema e erros de gravação tratados.
- Reabertura em processos novos confirmou ambas as preferências salvas.
- Menu com arte pixel original: lua carmesim, mago, manto, partículas e cajado animados.
- Mapa-pergaminho com seis regiões e três estados; somente Deserto começa aberto.
- Retratos, status, ataque, habilidade, passiva e seleção dos três magos; bloqueio validado também fora da UI.
- Telas reais de melhorias e créditos. Settings preserva a tela de origem.
- Perfil permanente mínimo para saldo, compras e níveis; gravação de débito/desbloqueio em uma transação de arquivo.
- Pátio para validar joystick 360°, ataque, magia e dash; multitouch com posse por índice, cancelamento, resize e perda de foco.
- Magos redesenhados em 96×112 pixels: roupas em camadas, contornos, chapéus/hood distintos, bordados, luvas, botas e cajados elementais. Oito poses; cache limitado a 96 texturas.
- Arsenal com loja, inventário, retrato do mago e três espaços: cajado, manto, amuleto. Seis itens configuráveis, incluindo um presente inicial gratuito.
- Compra, equipamento, substituição e remoção persistentes. Comparação de dano e mudanças visuais por peça. A combinação pertence a cada mago.
- Dano equipado aplicado de fato nos projéteis do treino; feedback de dano, partículas de impacto e barra de mana azul.
- Migração de perfil v1 para v2 preservando moedas, fases, magos e upgrades; falhas de gravação não alteram a memória.

## CURRENTLY WORKING
- Nenhuma implementação em execução. Ponto de parada: esta entrega de menus, arte e arsenal está concluída; a campanha completa continua pendente.

## WORKING FEATURES
- Projeto importável pelo `project.godot`; fluxo principal executado via boot (F5 no editor).
- Catálogo integrado à tela de foundation (não é seleção de mago nem compra).
- Suite nativa de testes, executável offline.
- Português/inglês com alteração imediata de rótulos, cartões e mensagens.
- Preferências locais independentes dos futuros saves de progresso.
- Boot → menu → mapa → mago → carregamento de recurso → pátio de treino → mapa.
- Compras usam Saved Coins; treino não gera recompensas nem moedas.

## KNOWN BUGS
- Corrigidos o pergaminho fora da tela, botões cortados nos magos e a altura dos cartões do arsenal. Nenhuma falha nos testes listados abaixo; validação em aparelho ainda pendente.

## IMPORTANT DESIGN DECISIONS
- Projeto distinto de Yggdrasil; não reutilizar sua progressão ou engine.
- Jogo offline, 2D, horizontal, pt_BR/en.
- Pixel art dark fantasy confirmada em 11/10/2026; proposta 3D retirada, sem conversão do jogo.
- Equipamentos usam Saved Coins. Inventário compartilhado e combinação independente por mago; somente uma peça por espaço. Bônus afetam ataques básicos, sem empilhamento por reequipar.
- Combos com um único mago por run ainda precisam de decisão de design antes da seção 82.

## IMPORTANT ARCHITECTURAL DECISIONS
- Seções 0–10 não equivalem aos blocos 1–10.
- Gerenciadores futuros serão implementados quando houver comportamento real para atender.

## ECONOMY SETTINGS
- Alvos do documento: Fogo = 500 Saved Coins; Raio = 1.500 Saved Coins.
- Saldo de Saved Coins e compras implementados como dependência dos menus. Run Coins, recompensas e banking ainda ausentes.
- Equipamentos: Amuleto do Aprendiz grátis, Cajado Rúnico 120, Manto do Arcanista 160, Pingente Lunar 280, Cajado do Eclipse 340, Manto Astral 380. Balanceamento inicial em `data/equipment/*.tres`.
- Valores adicionais de combate, loot e loja são sementes de configuração, não balanceamento aprovado em gameplay.

## SAVE SYSTEM STATUS
- Perfil permanente em `user://permanent_save.json`, versão 2: saldo, magos, estados de fases, primeiro upgrade, `owned_equipment` e `loadouts`. Migração de v1 implementada. Não é a conclusão do sistema completo das seções 61–69.
- RunSave e banking não implementados. Continuar Run não aparece porque nenhuma run válida é criada nesta versão.
- Preferências independentes: `user://settings.cfg`, schema 1, backup e promoção de temporário.

## LOCALIZATION STATUS
- pt_BR/en integrados; chaves, conteúdo não vazio e placeholders conferidos automaticamente.
- Detecção inicial, troca manual, gravação e reabertura em outro processo: PASS no Linux.

## LAST TESTED BUILD
Godot Version: 4.5.2.stable.official.6ce3de25a.
Linux: PASS — Godot 4.5.2, importação, testes headless e renderização OpenGL/llvmpipe de seis prévias em 1280×720.
Windows: NOT TESTED.
Android: NOT TESTED.
iOS: NOT TESTED.

## LAST TEST RESULTS
- Conferência documental: repositório correto e escopo definidos.
- 624 verificações da suíte de foundation/localização: PASS; 0 falhas.
- 73 verificações de menus, transações, geometria e multitouch: PASS; 0 falhas.
- 63 verificações de equipamentos: PASS; 0 falhas. Incluem migração, backup, compras, troca/remoção, isolamento entre magos, falha de escrita, UI, traduções e impacto real do projétil.
- 6 probes em processos independentes: PASS (reset isolado, primeira abertura, gravação/leitura de pt_BR e en).
- Boot executado até o menu principal sem erros de script/runtime.
- Cobertura: dados, referências, traduções, preferências, recuperação, escrita inválida, navegação real e geometria de UI em cinco tamanhos de janela.
- Geometria headless não substitui inspeção visual ou teste de toque em aparelho.
- Relatório atual e comandos: `docs/QA_10_15_EQUIPAMENTOS.md`. Relatório anterior mantido em `docs/QA_0_10.md`.

## NEXT STEP
Próximo passo técnico: controles desktop da seção 16, depois continuar o combate e a primeira fase conforme autorização do usuário. Ganho de moedas, banking, RunSave, inimigos reais, chefes e exportações ainda não implementados.

Para retomar: leia este arquivo e o mestre; execute `GODOT_BIN=/caminho/godot bash tests/run_tests.sh`. Equipamentos estão em `resources/equipment_data.gd`, `data/equipment/`, `autoload/progression_manager.gd`, `scripts/save/profile_store.gd` e `scripts/ui/equipment_screen.gd`. A arte está em `assets/art/pixel_art.gd` e `scripts/ui/mage_portrait.gd`. Não há migração 3D pendente. As capturas estão em `docs/previews/`; o arsenal equipado é um cenário identificado de teste, não um bônus de moedas concedido ao jogador.
