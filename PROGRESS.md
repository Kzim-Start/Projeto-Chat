# CRIMSON MAGE DEVELOPMENT STATUS

## CURRENT BLOCK
Foundation — escopo autorizado: seções 0–10 do documento mestre.

## CURRENT STAGE
Checkpoint 2: seção 10 integrada — idioma imediato e persistente.

## COMPLETED
- Repositório original inspecionado; continha somente README.
- Prompt mestre importado integralmente (quebras de linha normalizadas para LF).
- Escopo desta entrega e orientações de continuidade registrados.
- Projeto Godot 4.5.2, 2D, Compatibility, horizontal, viewport de referência 1280×720.
- Resources tipados para magos, inimigos, loot e economia; validação na inicialização.
- Gelo inicial; Fogo/Raio bloqueados nas definições, com preços 500/1.500.
- Boot conectado à tela de foundation; navegação protegida contra destinos inválidos e cliques repetidos.
- Catálogos de tradução pt_BR/en já carregados pela engine.
- Detecção inicial do idioma do aparelho; português mapeado para pt_BR e demais idiomas para en.
- Configurações com seleção de idioma, atualização imediata, persistência e retorno à foundation.
- Preferências com arquivo temporário, backup válido, validação de schema e erros de gravação tratados.
- Reabertura em processos novos confirmou ambas as preferências salvas.

## CURRENTLY WORKING
- Revisão final, documentação de execução/QA e fechamento do intervalo autorizado.

## WORKING FEATURES
- Projeto abre pelo `project.godot` e executa com F6/F5 no Godot.
- Catálogo integrado à tela de foundation (não é seleção de mago nem compra).
- Suite nativa de testes, executável offline.
- Português/inglês com alteração imediata de rótulos, cartões e mensagens.
- Preferências locais independentes dos futuros saves de progresso.

## KNOWN BUGS
- Nenhum erro de parsing/runtime nos testes executados. Validação visual e mobile ainda pendentes.

## IMPORTANT DESIGN DECISIONS
- Projeto distinto de Yggdrasil; não reutilizar sua progressão ou engine.
- Jogo offline, 2D, horizontal, pt_BR/en.
- Combos com um único mago por run ainda precisam de decisão de design antes da seção 82.

## IMPORTANT ARCHITECTURAL DECISIONS
- Seções 0–10 não equivalem aos blocos 1–10.
- Gerenciadores futuros serão implementados quando houver comportamento real para atender.

## ECONOMY SETTINGS
- Alvos do documento: Fogo = 500 Saved Coins; Raio = 1.500 Saved Coins.
- Nenhum sistema de moedas implementado.
- Valores adicionais de combate, loot e loja são sementes de configuração, não balanceamento aprovado em gameplay.

## SAVE SYSTEM STATUS
- PermanentSave, RunSave e banking não implementados nesta etapa.

## LOCALIZATION STATUS
- pt_BR/en integrados; chaves, conteúdo não vazio e placeholders conferidos automaticamente.
- Detecção inicial, troca manual, gravação e reabertura em outro processo: PASS no Linux.

## LAST TESTED BUILD
Godot Version: 4.5.2.stable.official.6ce3de25a.
Linux: PASS — importação headless e suite nativa de foundation; visual NOT TESTED.
Windows: NOT TESTED.
Android: NOT TESTED.
iOS: NOT TESTED.

## LAST TEST RESULTS
- Conferência documental: repositório correto e escopo definidos.
- 205 verificações automatizadas: PASS; 0 falhas.
- 6 probes em processos independentes: PASS (reset isolado, primeira abertura, gravação/leitura de pt_BR e en).
- Boot executado até a foundation sem erros de script/runtime.
- Cobertura: dados, referências, traduções, preferências, recuperação, escrita inválida, navegação real e geometria de UI em cinco tamanhos de janela.
- Geometria headless não substitui inspeção visual ou teste de toque em aparelho.

## NEXT STEP
Finalizar documentação e revisão do checkpoint 0–10, sem iniciar a seção 11.
