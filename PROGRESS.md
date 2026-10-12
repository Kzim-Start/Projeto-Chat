# CRIMSON MAGE DEVELOPMENT STATUS

## CURRENT BLOCK
Seções 10–15 e ampliação autorizada em 11/10/2026: magos mais detalhados em pixel art, loja de equipamentos, tela para equipar e bônus de dano.

## CURRENT STAGE
Checkpoint 10–15 B: correções de mapa/pergaminho e cartões verificadas. Próximo checkpoint: arte dos magos e equipamentos.

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
- Menu com arte pixel original: lua carmesim, mago, manto, partículas e cajado animados.
- Mapa-pergaminho com seis regiões e três estados; somente Deserto começa aberto.
- Retratos, status, ataque, habilidade, passiva e seleção dos três magos; bloqueio validado também fora da UI.
- Telas reais de melhorias e créditos. Settings preserva a tela de origem.
- Perfil permanente mínimo para saldo, compras e níveis; gravação de débito/desbloqueio em uma transação de arquivo.
- Pátio para validar joystick 360°, ataque, magia e dash; multitouch com posse por índice, cancelamento, resize e perda de foco.

## CURRENTLY WORKING
- Implementação de equipamentos permanentes (cajado, manto e amuleto), com compra por Saved Coins e cálculo de dano; redesenho dos magos.

## WORKING FEATURES
- Projeto importável pelo `project.godot`; fluxo principal executado via boot (F5 no editor).
- Catálogo integrado à tela de foundation (não é seleção de mago nem compra).
- Suite nativa de testes, executável offline.
- Português/inglês com alteração imediata de rótulos, cartões e mensagens.
- Preferências locais independentes dos futuros saves de progresso.
- Boot → menu → mapa → mago → carregamento de recurso → pátio de treino → mapa.
- Compras usam Saved Coins; treino não gera recompensas nem moedas.

## KNOWN BUGS
- Corrigidos o pergaminho fora da tela e botões cortados nos cartões. Revisão visual das quatro telas realizada em Linux; teste em aparelho ainda pendente.

## IMPORTANT DESIGN DECISIONS
- Projeto distinto de Yggdrasil; não reutilizar sua progressão ou engine.
- Jogo offline, 2D, horizontal, pt_BR/en.
- Combos com um único mago por run ainda precisam de decisão de design antes da seção 82.

## IMPORTANT ARCHITECTURAL DECISIONS
- Seções 0–10 não equivalem aos blocos 1–10.
- Gerenciadores futuros serão implementados quando houver comportamento real para atender.

## ECONOMY SETTINGS
- Alvos do documento: Fogo = 500 Saved Coins; Raio = 1.500 Saved Coins.
- Saldo de Saved Coins e compras implementados como dependência dos menus. Run Coins, recompensas e banking ainda ausentes.
- Valores adicionais de combate, loot e loja são sementes de configuração, não balanceamento aprovado em gameplay.

## SAVE SYSTEM STATUS
- Perfil permanente mínimo em `user://permanent_save.json`: saldo, magos, estados de fases e primeiro upgrade. Não é a conclusão do sistema completo das seções 61–69.
- RunSave e banking não implementados. Continuar Run não aparece porque nenhuma run válida é criada nesta versão.
- Preferências independentes: `user://settings.cfg`, schema 1, backup e promoção de temporário.

## LOCALIZATION STATUS
- pt_BR/en integrados; chaves, conteúdo não vazio e placeholders conferidos automaticamente.
- Detecção inicial, troca manual, gravação e reabertura em outro processo: PASS no Linux.

## LAST TESTED BUILD
Godot Version: 4.5.2.stable.official.6ce3de25a.
Linux: PASS — importação, testes headless e renderização OpenGL/llvmpipe de menu, mapa, magos e treino em 1280×720.
Windows: NOT TESTED.
Android: NOT TESTED.
iOS: NOT TESTED.

## LAST TEST RESULTS
- Conferência documental: repositório correto e escopo definidos.
- 465 verificações da suíte de foundation/localização: PASS; 0 falhas.
- 73 verificações de menus, transações, geometria e multitouch: PASS; 0 falhas.
- 6 probes em processos independentes: PASS (reset isolado, primeira abertura, gravação/leitura de pt_BR e en).
- Boot executado até o menu principal sem erros de script/runtime.
- Cobertura: dados, referências, traduções, preferências, recuperação, escrita inválida, navegação real e geometria de UI em cinco tamanhos de janela.
- Geometria headless não substitui inspeção visual ou teste de toque em aparelho.
- Relatório e comandos de reprodução: `docs/QA_0_10.md`.

## NEXT STEP
Implementar e testar a ampliação de equipamentos solicitada, salvar código e prévias. Campanha, chefes, áudio e combate completo continuam pendentes. Ao interromper, registrar aqui os arquivos e verificações que ainda faltam.
