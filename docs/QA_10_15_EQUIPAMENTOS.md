# QA — menus, controles, pixel art e equipamentos

Build: `0.3.0-arcane-arsenal`. Engine: `4.5.2.stable.official.6ce3de25a`.

## Escopo executado

Continuação das seções 10–15 e pedido adicional de 11/10/2026: melhorar os magos em pixel art, criar itens compráveis e um menu para equipar e aumentar o dano. A proposta 3D foi retirada por solicitação do usuário. O mestre original foi preservado.

| Verificação | Resultado | Limite |
| --- | --- | --- |
| Importação e boot | PASS | Linux, Godot Compatibility |
| Foundation/localização | 624 verificações, 0 falhas | Dados, traduções, preferências e UI existente |
| Menus e controles | 73 verificações, 0 falhas | Eventos de toque injetados na viewport nativa |
| Equipamentos | 63 verificações, 0 falhas | Perfil e saldo isolados para testes |
| Preferências entre processos | 6 probes, PASS | Detecção, gravação e reabertura pt_BR/en |
| Revisão visual | PASS | Seis PNGs da engine em 1280×720, OpenGL/llvmpipe |
| Windows, Android, iOS | NOT TESTED | Sem execução nesses sistemas |
| APK/AAB, toque físico, desempenho em celular | NOT TESTED | Sem exportação ou medição em aparelho |

São 760 verificações automáticas, além dos seis probes e da inspeção das capturas. Isso não representa playtest completo de uma campanha.

## Casos de equipamento

- Migração de perfil v1 para v2 preserva moedas, desbloqueios, fases e upgrades, sem conceder equipamentos comprados.
- O backup v1 continua legível; versões futuras bloqueiam downgrade e arquivos v2 incompletos são rejeitados.
- Compra pelo preço exato; saldo insuficiente; ID inválido; tentativa duplicada; presente gratuito resgatado uma vez.
- Mago bloqueado e item não adquirido não podem ser equipados, inclusive chamando a API diretamente.
- Cada combinação usa um item por espaço. Trocar amuleto remove o bônus anterior; reequipar não empilha dano.
- Compra grava inventário e débito juntos. Falhas de escrita não alteram carteira, inventário ou combinação em memória.
- Combinações de magos são independentes; Resources compartilhados não são modificados pelo equipamento.
- Uma nova instância de ProfileStore recupera saldo e itens do disco; leitura de combinação retorna cópia.
- Loja abre pelo menu, inventário filtra itens, seleção de magos retorna corretamente e idioma muda sem reiniciar.
- Os seis cartões e os controles do arsenal cabem na viewport de referência.
- Projétil equipado aplica dano real: com Amuleto do Aprendiz, um alvo de 3 HP passa a 1,9 HP após um impacto.
- O pátio mantém zero recompensa em moedas.

## Revisão visual e correções

O mapa desaparecia porque a animação alterava o transform de um filho gerenciado pelo VBox. O pergaminho agora anima dentro de um Control próprio após o layout. Botões dos magos e a altura dos cartões do arsenal também foram corrigidos.

Os magos usam sprites originais de 96×112 pixels, oito poses e camadas de roupa, cajado, amuleto e bordado. Retratos exibem altar, alvenaria, runas e partículas. O mesmo desenho aparece nos menus e no treino. O cache dos magos tem limite de 96 texturas; não se gera uma textura nova a cada frame renderizado. Essas escolhas não comprovam uma meta de FPS em celular.

Capturas: [menu](previews/menu.png), [mapa](previews/mapa.png), [magos](previews/magos.png), [loja inicial](previews/equipamentos.png), [arsenal equipado](previews/arsenal-equipado.png) e [treino](previews/treino.png). A captura do arsenal equipado identifica um perfil temporário com saldo simulado; o script restaura o perfil de teste anterior ao terminar.

## Reproduzir

No diretório do projeto:

```sh
GODOT_BIN=/caminho/para/godot bash tests/run_tests.sh
```

Teste do arsenal isoladamente, após importar o projeto:

```sh
godot --headless --path . --quit-after 2400 res://tests/test_equipment.tscn -- --test-mode
```

Capturas com display gráfico real ou virtual disponível:

```sh
godot --path . --rendering-method gl_compatibility res://tests/capture_preview.tscn -- --test-mode
```

O modo de captura rejeita headless. As imagens são salvas em `docs/previews/`. Um aviso de V-Sync não suportado ocorreu no display virtual; não foi registrado como prova de performance ou de compatibilidade mobile.

## Pendente para as próximas entregas

Controles desktop da seção 16; campanha e inimigos reais; habilidades completas por elemento; RunSave; banking após vitória; áudio; teste em aparelhos e exportações. A aquisição de moedas por jogo ainda depende da campanha, portanto os itens pagos só podem ser comprados quando houver Saved Coins. O amuleto gratuito já permite experimentar o fluxo completo de compra, equipamento e dano com o saldo inicial.
