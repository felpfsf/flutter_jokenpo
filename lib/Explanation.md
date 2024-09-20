# Jo Ken Po usando o Flutter com ValueNotifier

Usando o *ValueNotifier* no lugar de setState, o código fica mais organizado e eficiente. O *ValueNotifier* notifica automaticamente os widgets que precisam ser atualizados sempre que seu valor muda, evitando a necessidade de reconstruir toda a interface.

O *ValueListenableBuilder* é o widget responsável por escutar o *ValueNotifier* e reconstruir seu filho de acordo com o valor atualizado.

Principais *ValueNotifier*s:

- `_messageNotifier`: Armazena a mensagem exibida na tela, como o resultado do jogo.
- `_pcChoiceNotifier`: Armazena o ícone escolhido pelo computador.
- `_userChoiceNotifier`: Armazena o ícone escolhido pelo usuário.
- `_showChoiceNotifier`: Indica se as escolhas (do usuário e do computador) devem ser exibidas.
- `_isAnimatingNotifier`: Controla se a animação de rotação está ativa ou não.

## Função `_userChoice()`

A função `_userChoice()` é chamada quando o usuário escolhe "rock", "paper" ou "scissors". Ela:

- Gera a escolha aleatória do computador.
- Atualiza o `_userChoiceNotifier` e `_pcChoiceNotifier` com as escolhas correspondentes.
- Ativa a animação de rotação e, após um tempo, exibe as escolhas do jogador e do computador.
- Com base nas escolhas, atualiza `_messageNotifier` com o resultado do jogo (vitória, empate ou derrota).
  
O uso de *ValueNotifier* faz com que apenas os widgets que dependem dessas variáveis sejam atualizados, melhorando a performance e a organização do código.
