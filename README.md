# Crimson Mage

Action roguelite 2D top-down em pixel art dark fantasy, desenvolvido em Godot/GDScript para Android e iOS. Repositório: **Kzim-Start/Projeto-Chat**.

## Escopo atual

A solicitação de 05/10/2026 cobre as **seções 0 a 10**: preparação do repositório, fundamentos, organização, arquitetura, dados e localização. O documento mestre começa na seção 1; a parte 0 é a preparação e o versionamento. Isto não significa implementar os blocos de desenvolvimento 1 a 10.

O projeto será construído incrementalmente. Combate, runs, biomas, APK/AAB e publicação nas lojas ainda não pertencem a esta entrega.

## Abrir e executar

1. Instale o [Godot 4.5.2 Standard](https://godotengine.org/download/archive/4.5.2-stable/) — não é necessário .NET.
2. Clone ou baixe este repositório e importe o arquivo `project.godot` no Godot.
3. Pressione **F5** para executar o projeto.
4. Na tela de foundation, abra **Configurações / Settings**. Escolha português ou inglês e volte: a mudança é imediata e permanece após fechar o jogo.

A tela atual é uma ferramenta de verificação da base, não o menu final nem uma demo de combate. Os três cartões leem os Resources reais; os preços e bloqueios são definições iniciais, não um sistema de compra já implementado. Não há botão de jogar sem função.

## O que está implementado

- Boot e navegação entre foundation e configurações.
- Quatro Autoloads com responsabilidades separadas: configurações, localização, catálogo global e navegação.
- `MageData`, `EnemyData`, `LootTableData`, `EconomyData` e `GameCatalog`, com validação integrada.
- Apenas Gelo disponível inicialmente nas definições; Fogo = 500 e Raio = 1.500 Saved Coins.
- Português brasileiro e inglês com detecção inicial e preferência local.
- Preferências gravadas por arquivo temporário, com backup válido e proteção contra schemas mais novos.
- Testes nativos de dados, localização, UI, recuperação e persistência entre processos.

Dados de combate, drops e loja são valores iniciais para desenvolvimento, ainda sem playtest de balanceamento. `sprite_data` é opcional nesta etapa: sprites e animações não foram produzidos.

## Testar

Com Godot no PATH, no diretório do projeto:

```sh
godot --headless --editor --path . --import
godot --headless --path . --quit-after 1800 res://tests/test_runner.tscn -- --test-mode
```

No Linux/macOS com Bash, o comando abaixo inclui também o smoke test de boot e os seis testes entre processos:

```sh
GODOT_BIN=/caminho/para/godot bash tests/run_tests.sh
```

O script procura `rg` e usa `grep` como alternativa. O jogo não depende dessas ferramentas. No Windows, use o executável console do Godot para ver a saída dos comandos. As instruções para outros sistemas não significam que eles foram testados nesta entrega.

Resultado executado: **205 verificações, 0 falhas; 6 probes entre processos aprovados**, em Godot 4.5.2 no Linux headless. Inspeção visual, toque, Windows, Android, iOS, exportações e performance em dispositivos: **NOT TESTED**. Veja os detalhes em [docs/QA_0_10.md](docs/QA_0_10.md).

## Documentos

- [MASTER_PROMPT.md](MASTER_PROMPT.md): especificação completa fornecida pelo usuário, preservada sem alterações de conteúdo.
- [PROGRESS.md](PROGRESS.md): trabalho concluído, verificações, limitações e próxima etapa.
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md): responsabilidades, decisões e limites dos sistemas.
- [docs/QA_0_10.md](docs/QA_0_10.md): cobertura, reprodução e limites dos testes.

As metas de 60 FPS, diversão e qualidade final exigem medições e playtests; não são resultados garantidos por geração de código.
