//======================================================================
// IPL - ESCS
// Interação Em Tempo Real
// 2022
//===================================
// Projecto 1
// 2P PONGNOID
//===================================
// Rodrigo Monteiro
// 10229
//===================================
// Source Code do User Text Input: Daniel Shiffman
// Source Code do Pong: eprittinen
// Source Code do Arkanoid: dimitrisdermanis
//======================================================================
// INÍCIO da declaração de variáveis:
//===================================
// ECRÃ INICIAL - USER TEXT INPUT
//===================================
PFont f; // Cria uma variável para gravar a fonte

// Variáveis boleanas não necessariamente criadas para certificar que o nome é gravado, mas sim para servirem de base noutras condições (if statements and so on)
boolean isPlayerLeftNameSaved = false; // boleano criado a seguir ao nome ser gravado, começa com a condição de verdade false, para depois servir de switch ao mudar para true
boolean isPlayerRightNameSaved = false; // boleano criado a seguir ao nome ser gravado, começa com a condição de verdade false, para depois servir de switch ao mudar para true

// Variáveis para mostrar o texto à medida que ele é escrito
String typingPlayerLeftName = ""; // começa com uma string vazia, e vai sendo incrementada, à medida que o texto é escrito
String typingPlayerRightName = ""; // começa com uma string vazia, e vai sendo incrementada, à medida que o texto é escrito

// Variáveis para gravar o texto assim que a tecla ENTER é premida
String savedPlayerLeftName = ""; // começa com uma string vazia, e é preenchida ao acabar de preencher a variável typing correspondente seguido da pressão da tecla ENTER
String savedPlayerRightName = ""; // começa com uma string vazia, e é preenchida ao acabar de preencher a variável typing correspondente seguido da pressão da tecla ENTER
//===================================
// STATES
//===================================
int state = 0; // criada para definir em que estado nos encontramos, ou seja, em que ecrã / gameloop 

boolean canSwitchStates = false; // criada para permitir utilizar a tecla N aquando do user text input

boolean hasPlayerLeftWon = false; // criada para definir que o jogador do lado esquerdo ganhou
boolean hasPlayerRightWon = false; // criada para definir que o jogador do lado direito ganhou
//===================================
// ARKANOID
//===================================
PVector paddle_position, ball_position, ball_speed; // Vectores de posição da bola e do paddle, velocidade da bola
int width = 640; // largura da janela
int height = 480; // altura da janela
int life; // número de vidas disponíveis
int ball_size = 10; // tamanho da bola
int paddle_rx = 40; // largura do paddle
int paddle_ry = 8; // altura do paddle
int brick_rx = 32; // largura do tijolo
int brick_ry = 8; // altura do tijolo
int brick_top_line=50; // linha de cima dos tijolos
int brick_bottom_line=100; // linha de baixo dos tijolos
int n = width / (2*brick_rx);
int m = abs(brick_top_line-brick_bottom_line) / (2*brick_ry);
int empty = width % (2*brick_rx);

ArrayList<Brick> bricks = new ArrayList<Brick>(); // array list dos tijolos
//===================================
// PONG
//===================================
PongBall pongBall; // define a bola como um objecto global
PongPaddle pongPaddleLeft; // define o paddle esquerdo como um objecto global
PongPaddle pongPaddleRight; // define o paddle direito como um objecto global
int scoreLeft = 0; // define o valor do score inicial do jogador do lado esquerdo como zero
int scoreRight = 0; // define o valor do score inicial do jogador do lado direito como zero
int larguraPongPaddleLeft = 15; // define o valor inicial da largura do paddle do lado esquerdo
int alturaPongPaddleLeft = 240; // define o valor inicial da altura do paddle do lado esquerdo
int larguraPongPaddleRight = 625; // define o valor inicial da largura do paddle do lado direito
int alturaPongPaddleRight = 240; // define o valor inicial da altura do paddle do lado direito
//===================================
// FIM da declaração de variáveis
//======================================================================
// INÍCIO dos voids / funções
//===================================
// Void que define as condições estruturais
//===================================
void setup() {
  // ARKANOID
  size(640, 480); // tamanho da janela
  smooth();
  game_reset(); // faz um reset ao game loop do Arkanoid
  // PONG
  pong_game_reset(); // faz um reset ao game loop do Pong
  // ECRÃ INICIAL - USER TEXT INPUT
  f = createFont("Arial",16); // estabelece a fonte Arial como a fonte a ser utilizada no projecto, e com um tamanho base de 16
}
//===================================
// Void que recomeça as definições iniciais do modo de jogo Arkanoid
//===================================
void game_reset() { 
  // ARKANOID
  paddle_position = new PVector(width/2, height-20); // vector de posição do paddle
  new_ball(); // dá spawn a uma nova bola, chamando a função específica
  life = 3; // estabelece o número de vidas do jogador como 3
  
  for (int i=0; i<n; i++) { 
    for (int j=0; j<m; j++) { 
      bricks.add(new Brick((empty/2)+(2*i+1)*brick_rx, brick_bottom_line-(2*j+1)*brick_ry)); 
    }
  }
  fill(255);
  loop();
}
//===================================
// Void que recomeça as definições iniciais do modo de jogo Pong
//===================================
void pong_game_reset() {
  // PONG
  pong_new_ball(); // dá spawn a uma nova bola, chamando a função específica
  pongPaddleLeft = new PongPaddle(larguraPongPaddleLeft, alturaPongPaddleLeft, 30, 200); // dá spawn ao paddle esquerdo
  pongPaddleRight = new PongPaddle(larguraPongPaddleRight, alturaPongPaddleRight, 30, 200); // dá spawn ao paddle direito
  fill(255);
  loop();
}
//===================================
// Void que estabelece as definições iniciais da bola do modo de jogo Arkanoid
//===================================
void new_ball() {
  ball_position = new PVector(width/2, brick_bottom_line+20); // define a posição inicial da bola através de um vector posição
  ball_speed = new PVector(1, 2); // define a velocidade inicial da bola através de um vector velocidade
}
//===================================
// Void que estabelece as definições iniciais da bola do modo de jogo Pong
//===================================
void pong_new_ball() {
  pongBall = new PongBall(width/2, height/2, 50); // define a posição inicial da bola, no centro do ecrã, com um diâmetro de 50, mas ainda não a desenha
  pongBall.speedX = 5; // atribui à bola uma velocidade no eixo do x no valor de 5
  pongBall.speedY = random(-3,3); // atribui à bola uma velocidade no eixo do y num valor randomizado compreendido, entre -3 e 3
}
//===================================
// Void que desenha o que aparece visível no ecrã
//===================================
void draw() {
  background(0); // estabelece a cor do fundo como preto
  if (state == 0) { // maneira utilizada para mudar de ecrãs
    //ECRÃ INICIAL - USER TEXT INPUT
    textSize(44); // estabelece o tamanho do texto como 44
    //line(0, 120, width, 120);
    text("2P PONGNOID", 180, 120); // escreve o texto da string 2P PONGNOID e coloca-o na posição 180 no eixo do x e 120 no eixo do y
    
    int indent = 15; // variável criada para acrescentar uma margem ao texto
  
    textFont(f); // chama a fonte guardada na variável f, que corresponde a Arial
    fill(255); // pinta o texto da cor branca
    
    // revela o texto à medida que as condições são satisfeitas
    if (isPlayerLeftNameSaved == false && isPlayerRightNameSaved == false) {
      text("Click in this window and type. \nHit enter to save your player name. ", indent, 40); // introdução ao modo de como usar a aplicação
      text("" + typingPlayerLeftName, indent, 190); // mostra o texto à medida que é escrito
    } else if (isPlayerLeftNameSaved == true && isPlayerRightNameSaved == false) {
      text("" + savedPlayerLeftName, 240, 230); // mostra o primeiro texto guardado
      text("" + typingPlayerRightName, indent, 320); // mostra o segundo texto à medida que é escrito
    } else if (isPlayerLeftNameSaved == true && isPlayerRightNameSaved == true) {
      text("" + savedPlayerLeftName, 240, 230); // mostra o primeiro texto guardado
      text("" + savedPlayerRightName, 240, 330); // mostra o segundo texto guardado
      textSize(16); // muda o tamanho do texto para 16
      text("Press N to start the game", 240, 380); // revela aos jogadores / utilizadores como prosseguir
    }
  } else if (state == 1) { // maneira utilizada para mudar de ecrãs
      // ECRÃ DE CONTROLOS
      textAlign(CENTER); // alinha o texto ao centro (que como podemos comprovar tal não se verifica :p)
      textSize(44); // estabelece o tamanho do texto como 44
      text("Controls", 200, 50); // mostra a palavra Controls na posição 200 no eixo do x e 50 no eixo do y
      textFont(f); // estabelece a fonte como a guardada na variável f, neste caso Arial
      fill(255); // pinta o texto com a cor branca
      text(savedPlayerLeftName, 160, 100); // mostra o primeiro nome gravado na posição 160 no eixo do x e 100 no eixo do y
      text(savedPlayerRightName, 400, 100); // mostra o segundo nome gravado na posição 400 no eixo do x e 100 no eixo do y
      textSize(32); // estabelece o tamanho do texto como 32
      text("PONG", 240, 140); // mostra a palavra PONG na posição 200 no eixo do x e 140 no eixo do y
      textSize(16); // estabelece o tamanho do texto como 16
      text("Press W to move up", 160, 165); // escreve o texto da string e coloca-o na posição 160 no eixo do x e 165 no eixo do y
      text("Press UP ARROW to move up", 400, 180); // escreve o texto da string e coloca-o na posição 400 no eixo do x e 180 no eixo do y
      text("Press S to move down", 160, 200); // escreve o texto da string e coloca-o na posição 160 no eixo do x e 200 no eixo do y
      text("Press DOWN ARROW to move down", 400, 220); // escreve o texto da string e coloca-o na posição 400 no eixo do x e 220 no eixo do y
      textSize(32); // estabelece o tamanho do texto como 32
      text("ARKANOID", 240, 260); // mostra a palavra ARKANOID na posição 240 no eixo do x e 260 no eixo do y
      textSize(16); // estabelece o tamanho do texto como 16
      text("Move the mouse to the left and right", 240, 285); // escreve o texto da string e coloca-o na posição 240 no eixo do x e 285 no eixo do y
      textSize(32); // estabelece o tamanho do texto como 32
      text("SPECIAL INTERACTIONS", 240, 330);
      textSize(16); // estabelece o tamanho do texto como 16
      text("Press N to switch forward between scenes", 240, 360); // escreve o texto da string e coloca-o na posição 240 no eixo do x e 360 no eixo do y
      text("Press B to switch backwards between scenes", 240, 380); // escreve o texto da string e coloca-o na posição 240 no eixo do x e 380 no eixo do y
      text("Press F when asked", 240, 400); // escreve o texto da string e coloca-o na posição 240 no eixo do x e 400 no eixo do y
      text("Press R to reset the current game", 240, 420); // escreve o texto da string e coloca-o na posição 240 no eixo do x e 420 no eixo do y
  } else if (state == 2) { // maneira utilizada para mudar de ecrãs
    // PONG
    pong_score(); // desenha o quadro de pontuações no topo do UI 
    pong_draw_ball(); // desenha a bola
    pong_draw_paddle(); // desenha os paddles
    pong_win(); // inicia as condições de vitória
  } else if (state == 3) { // maneira utilizada para mudar de ecrãs
    // ARKANOID
    score(); // desenha o quadro de pontuações no topo do UI 
    draw_ball(); // desenha a bola
    draw_bricks(); // desenha os tijolos
    draw_paddle(); // desenha o paddle
  }
}
//===================================
// Void responsável pelo score do Arkanoid, nomeadamente os seus elementos de UI
//===================================
void score() {
  fill(255); // pinta o texto com a cor branca
  textSize(40); // estabelece o tamanho do texto como 40
  textAlign(CENTER); // alinha o texto ao centro
  text("Lives: " + life, width/2, 30); // mostra a palavra Lives mais o número de vidas disponíveis guardadas na variável life, na posição metade da largura no eixo do x, e 30 no eixo do y
  if(hasPlayerLeftWon == true && hasPlayerRightWon == false) { // esta condição verifica que o jogador esquerdo ganhou o jogo do Pong, e apresenta o seu nome no UI do jogo Arkanoid
  textSize(40); // estabelece o tamanho do texto como 40
  textAlign(LEFT); // alinha o texto à esquerda
  text(savedPlayerLeftName, 10, 30); // mostra o nome do jogador esquerdo, gravado na variável através do user text input, na posição 10 no eixo do x e 30 no eixo do y
  } else if (hasPlayerRightWon == true && hasPlayerLeftWon == false) { // esta condição verifica que o jogador direito ganhou o jogo do Pong, e apresenta o seu nome no UI do jogo Arkanoid
  textSize(40); // estabelece o tamanho do texto como 40
  textAlign(RIGHT); // alinha o texto à direita
  text(savedPlayerRightName, width-10, 30); // mostra o nome do jogador esquerdo, gravado na variável através do user text input, na posição largura total da aplicação menos 10 no eixo do x e 30 no eixo do y
  }
  fill(255); // pinta o texto com a cor branca
}
//===================================
// Void responsável pelo score do Pong, nomeadamente os seus elementos de UI
//===================================
void pong_score() {
  textSize(40); // estabelece o tamanho do texto como 40
  textAlign(CENTER); // alinha o texto ao centro
  text(scoreRight, width/2+30, 30); // mostra o score do jogador direito, guardado na variável scoreRight, na posição metade da largura total mais 30 no eixo do x e 30 no eixo do y
  text(scoreLeft, width/2-30, 30); // mostra o score do jogador esquerdo, guardado na variável scoreLeft, na posição metade da largura total menos 30 no eixo do x e 30 no eixo do y
  text("-", width/2, 30); // mostra o símbolo - para evidenciar o contraste entre as duas pontuações
  textSize(40); // estabelece o tamanho do texto como 40
  textAlign(LEFT); // alinha o texto à esquerda
  text(savedPlayerLeftName, 10, 30); // mostra o nome do jogador esquerdo, na posição 10 no eixo do x, e 30 no eixo do y
  textSize(40); // estabelece o tamanho do texto como 40
  textAlign(RIGHT); // alinha o texto à direita
  text(savedPlayerRightName, width-10, 30); // mostra o nome do jogador esquerdo, na posição largura total menos 10 no eixo do x, e 30 no eixo do y
}
//===================================
// Void responsável por desenhar a bola do Arkanoid, nomeadamente os seus elementos gráficos, velocidade e ressalto
//===================================
void draw_ball() { 
  strokeWeight(1); // adiciona contorno no valor de 1 ao desenho da bola
  ellipse(ball_position.x, ball_position.y, ball_size, ball_size); // cria uma elipse na posição e raio guardados na declaração de variáveis no início do sketch
  bounce(); 
  if (ball_position.y>height) loose(); // se a posição da bola em y for inferior à altura da janela da aplicação, activa as condições de derrota 
  ball_position.add(ball_speed); 
}
//===================================
// Void responsável por desenhar a bola do Pong, nomeadamente os seus elementos gráficos, velocidade, ressalto e pontuação atribuídas
//===================================
void pong_draw_ball() {
  pongBall.move(); // calcula a nova posição da bola
  pongBall.display(); // desenha a bola no ecrã
  // deteta as colisões da bola com as extremidades da janela, de forma a mantê-la confinada dentro da mesma
  // os quatro cantos de uma janela são:
  // canto superior esquerdo (0,0)
  // canto superior direito (width,0)
  // canto inferior esquerdo (0, height)
  // canto inferior direito (width, height)
  if (pongBall.right() > width) { // se a posição da bola do lado direito da janela for superior à largura (largura do lado direito) executa o código abaixo
    scoreLeft = scoreLeft + 1; // acrescenta 1 à pontuação do jogador esquerdo
    pongBall.x = width/2; // retorna a bola à posição inicial em x de centro da janela (metade da largura)
    pongBall.y = height/2; // retorna a bola à posição inicial em y de centro da janela (metade da altura)
  }
  if (pongBall.left() < 0) { // se a posição da bola do lado esquerdo da janela for inferior a zero (largura do lado esquerdo) executa o código abaixo
    scoreRight = scoreRight + 1; // acrescenta 1 à pontuação do jogador direito
    pongBall.x = width/2; // retorna a bola à posição inicial em x de centro da janela (metade da largura)
    pongBall.y = height/2; // retorna a bola à posição inicial em y de centro da janela (metade da altura)
  }
  if (pongBall.bottom() > height) { // se a posição da bola em baixo for superior à altura (altura no ponto "mais baixo") executa o código abaixo
    pongBall.speedY = -pongBall.speedY; // provoca uma mudança da velocidade no sentido inverso em y, ressalto
  }
  if (pongBall.top() < 0) { // se a posição da bola em cima for inferior a zero (altura no ponto "mais alto") executa o código abaixo
    pongBall.speedY = -pongBall.speedY; // provoca uma mudança da velocidade no sentido inverso em y, ressalto
  }
}
//===================================
// Void responsável por desenhar cada tijolo do Arkanoid
//===================================
void draw_bricks() { // desenha cada tijolo no arraylist bricks
  for (Brick a_brick : bricks) {
    a_brick.draw();
  }
}
//===================================
// Void responsável por desenhar o paddle do Arkanoid
//===================================
void draw_paddle() { 
  rectMode(RADIUS);
  rect(paddle_position.x, paddle_position.y, paddle_rx, paddle_ry);
  update_paddle_position();
}
//===================================
// Void responsável por desenhar o paddle do Pong
//===================================
void pong_draw_paddle() {
  pongPaddleLeft.move(); // permite que o paddle esquerdo se mova
  pongPaddleLeft.display(); // desenha o paddle esquerdo na janela
  pongPaddleRight.move(); // permite que o paddle direito se mova 
  pongPaddleRight.display(); // desenha o paddle direito na janela 
  // verifica as colisões de ambos os paddles (esquerdo e direito) com os limites da janela, confinando-os aos mesmos
  if (pongPaddleLeft.bottom() > height) {
    pongPaddleLeft.y = height-pongPaddleLeft.h/2;
  }
  if (pongPaddleLeft.top() < 0) {
    pongPaddleLeft.y = pongPaddleLeft.h/2;
  }
  if (pongPaddleRight.bottom() > height) {
    pongPaddleRight.y = height-pongPaddleRight.h/2;
  }
  if (pongPaddleRight.top() < 0) {
    pongPaddleRight.y = pongPaddleRight.h/2;
  }
  // controla as colisões da bola com os paddles e o movimento de ressalto que daí decorre
  if ( pongBall.left() < pongPaddleLeft.right() && pongBall.y > pongPaddleLeft.top() && pongBall.y < pongPaddleLeft.bottom()){
    pongBall.speedX = -pongBall.speedX; // controla o ressalto em x
    pongBall.speedY = map(pongBall.y - pongPaddleLeft.y, -pongPaddleLeft.h/2, pongPaddleLeft.h/2, -10, 10); // controla o ressalto em y
  }
  if ( pongBall.right() > pongPaddleRight.left() && pongBall.y > pongPaddleRight.top() && pongBall.y < pongPaddleRight.bottom()){
    pongBall.speedX = -pongBall.speedX; // controla o ressalto em x
    pongBall.speedY = map(pongBall.y - pongPaddleRight.y, -pongPaddleRight.h/2, pongPaddleRight.h/2, -10, 10); // controla o ressalto em y
  }
}
//===================================
// Void responsável por actualizar a posição do paddle do Arkanoid
//===================================
void update_paddle_position() { 
  paddle_position.x=constrain(mouseX, brick_rx, width-brick_rx); 
}
//===================================
// Void responsável pelo ressalto da bola do Arkanoid
//===================================
void bounce() { 
  paddle_bounce(); // ressalto da bola ao colidir com o paddle
  side_bounce(); // ressalto da bola ao colidir com o lado esquerdo e direito da janela
  top_bounce(); // ressalto da bola ao colidir com o topo da janela
  brick_bounce(); // ressalto da bola ao colidir com um tijolo
}
//===================================
// Void responsável pelo ressalto da bola com o paddle do Arkanoid
//===================================
void paddle_bounce() { 
  if ((ball_position.x>=paddle_position.x-paddle_rx) 
    && (ball_position.x<=paddle_position.x+paddle_rx) 
    && (ball_position.y>=paddle_position.y-paddle_ry-ball_size/2)) {
    if (ball_position.y>paddle_position.y-paddle_ry) { 
      //fail
    } else {
      float magnitude = mag(ball_speed.x, ball_speed.y)+0.1; // criação de uma variável numérica decimal 
      ball_speed.x = map(ball_position.x - paddle_position.x, 0, paddle_rx, 0, 1) * magnitude; 
      ball_speed.y = -sqrt(pow(magnitude, 2) - pow(ball_speed.x, 2)); 
    }
  }
}
//===================================
// Void responsável pelo ressalto da bola com o topo da janela do Arkanoid
//===================================
void top_bounce() { 
  if (ball_position.y<=ball_size/2) {  // caso a posição da bola em y seja menor que ou igual ao seu raio, executa o código abaixo
    ball_speed.y*=-1; // inverte a velocidade em y
  }
}
//===================================
// Void responsável pelo ressalto da bola com o lado esquerdo e direito da janela do Arkanoid
//===================================
void side_bounce() { 
  if ((ball_position.x<=ball_size/2) || (ball_position.x>=width-ball_size/2)) { // caso a posição da bola em x seja menor que ou igual ao seu raio, ou, caso a posição da bola em x seja maior que ou igual à largura da janela menos o raio da bola, executa o código abaixo
    ball_speed.x*=-1; // inverte a velocidade em x
  }
}
//===================================
// Void responsável pelo ressalto da bola com o tijolo do Arkanoid
//===================================
void brick_bounce() {
  for (int i = bricks.size ()-1; i>=0; i--) { // para cada tijolo no arraylist brick
    Brick this_brick = bricks.get(i); // verifica se a bola colidiu com algum dos tijolos
    if (ball_position.x >= this_brick.left() - ball_size 
      && ball_position.x <= this_brick.right() + ball_size 
      && ball_position.y >= this_brick.top() - ball_size
      && ball_position.y <= this_brick.bottom() + ball_size) { // verifica se a bola está dentro do tijolo
      if ((ball_position.x - ball_speed.x < this_brick.left() || ball_position.x - ball_speed.x > this_brick.right()) 
        && ball_position.y - ball_speed.y > this_brick.top() 
        && ball_position.y - ball_speed.y < this_brick.bottom()) { // verifica se a bola colidiu com um dos lados dos tijolos
        ball_speed.x*=-1; // inverte a velocidade em x
      } else {
        ball_speed.y*=-1; // inverte a velocidade em y
      }
      bricks.remove(i); // remove o tijolo do arraylist brick
      win(); // activa as condições de vitória, chamando a função win
      break; // desde que existam tijolos no arraylist, continua o ciclo, até que já não exista nenhum e aí são activadas as condições de vitória
    }
  }
}
//===================================
// Void responsável pelo ecrã de vitória, no caso de todos os tijolos terem sido removidos, do Arkanoid
//===================================
void win() {
  // no caso do jogador esquerdo ter ganho o Pong e ter igualmente ganho o Arkanoid
  if (bricks.isEmpty() && hasPlayerLeftWon == true) {
    background(100); // estabelece a cor do background como cinzento
    fill(0); // estabelece a cor do texto como preto
    textSize(64); // estabelece o tamanho do texto como 64
    textAlign(CENTER); // estabelece o alinhamento do texto ao centro
    text(savedPlayerLeftName, 320, height/2-50); // mostra o texto guardado na variável, na posição em x de 320, e em y a metade da altura menos 50
    textSize(16); // estabelece o tamanho do texto como 16
    text("won the game!", 320, height/2); // mostra o texto da string, na posição em x de 320, e em y a metade da altura
    textSize(32); // estabelece o tamanho do texto como 32
    text("Better luck next time " + savedPlayerRightName, 320, height/2+50); // mostra o texto da string + o texto guardado na variável, na posição em x 320, e em y a metade da altura mais 50
    noLoop();
  }
  // no caso do jogador direito ter ganho o Pong e ter igualmente ganho o Arkanoid
  if (bricks.isEmpty() && hasPlayerRightWon == true) {
    background(100); // estabelece a cor do background como cinzento
    fill(0); // estabelece a cor do texto como preto
    textSize(64); // estabelece o tamanho do texto como 64
    textAlign(CENTER); // estabelece o alinhamento do texto ao centro
    text(savedPlayerRightName, 320, height/2-50); // mostra o texto guardado na variável, na posição em x de 320, e em y a metade da altura menos 50
    textSize(16); // estabelece o tamanho do texto como 16
    text("won the game!", 320, height/2); // mostra o texto da string, na posição em x de 320, e em y a metade da altura
    textSize(32); // estabelece o tamanho do texto como 32
    text("Better luck next time " + savedPlayerLeftName, 320, height/2+50); // mostra o texto da string + o texto guardado na variável, na posição em x 320, e em y a metade da altura mais 50
    noLoop();
  }
}
//===================================
// Void responsável pelo ecrã de vitória, no caso de algum jogador chegar ao valor 5, do Pong
//===================================
void pong_win() {
  // no caso do jogador esquerdo chegar aos 5 pontos
  if (scoreLeft == 5) {
    state = 3; // muda para o ecrã guardado no void draw de 3
    hasPlayerLeftWon = true; // estabelece o boleano de vitória como verdadeiro
    background(100); // estabelece a cor do background como cinzento
    fill(0); // estabelece a cor do texto como preto
    textSize(64); // estabelece o tamanho do texto como 64
    textAlign(CENTER); // estabelece o alinhamento do texto ao centro
    text(savedPlayerLeftName, 320, height/2-150); // mostra o texto guardado na variável, na posição em x de 320, e em y a metade da altura menos 150
    textSize(16); // estabelece o tamanho do texto como 16
    text("won the first round!", 320, height/2-100); // mostra o texto da string, na posição em x de 320, e em y a metade da altura menos 100
    text("Now time for a new challenge!", 320, height/2); // mostra o texto da string, na posição em x de 320, e em y a metade da altura
    text("Does " + savedPlayerLeftName + " have what it takes to win it all?", 320, height/2+50); // mostra o texto das strings mais o texto guardado na variável, na posição em x de 320, e em y a metade da altura mais 50
    textSize(32); // estabelece o tamanho do texto como 32
    text("Press f to start the next challenge", 320, height/2+150); // mostra o texto da string, na posição em x de 320, e em y a metade da altura mais 150
    noLoop();
  }
  // no caso do jogador direito chegar aos 5 pontos
  if (scoreRight == 5) {
    state = 3; // muda para o ecrã guardado no void draw com o valor de 3
    hasPlayerRightWon = true; // estabelece o boleano de vitória como verdadeiro
    background(100); // estabelece a cor do background como cinzento
    fill(0); // estabelece a cor do texto como preto
    textSize(64); // estabelece o tamanho do texto como 64
    textAlign(CENTER); // estabelece o alinhamento do texto ao centro
    text(savedPlayerRightName, 320, height/2-150); // mostra o texto guardado na variável, na posição em x de 320, e em y a metade da altura menos 150
    textSize(16); // estabelece o tamanho do texto como 16
    text("won the first round!", 320, height/2-100); // mostra o texto da string, na posição em x de 320, e em y a metade da altura menos 100
    text("Now time for a new challenge!", 320, height/2); // mostra o texto da string, na posição em x de 320, e em y a metade da altura
    text("Does " + savedPlayerRightName + " have what it takes to win it all?", 320, height/2+50); // mostra o texto das strings mais o texto guardado na variável, na posição em x de 320, e em y a metade da altura mais 50
    textSize(32); // estabelece o tamanho do texto como 32
    text("Press f to start the next challenge", 320, height/2+150); // mostra o texto da string, na posição em x de 320, e em y a metade da altura mais 150
    noLoop();
  }
}
//===================================
// Void responsável pelo ecrã de derrota, no caso de algum jogador voltar a perder quando as vidas restantes disponíveis chegarem ao valor 0, do Arkanoid
//===================================
void loose() {
  // no caso do jogador esquerdo ser o jogador actual e as suas vidas restantes serem igual a 0
  if (life == 0 && hasPlayerLeftWon == true) {
    state = 2; // muda para o ecrã guardado no void draw com o valor de 2
    hasPlayerLeftWon = false; // reestabelece o boleano de vitória do jogador esquerdo como falso
    hasPlayerRightWon = false; // reestabelece o boleano de vitória do jogador direito como falso
    scoreLeft = 0; // reestabelece o valor da pontuação do jogador esquerdo como 0
    scoreRight = 0; // reestabelece o valor da pontuação do jogador direito como 0
    game_reset();
    background(100); // estabelece a cor do fundo como cinzento
    fill(0); // estabelece a cor do texto como preto
    textSize(64); // estabelece o tamanho do texto como 64
    textAlign(CENTER); // estabelece o alinhamento do texto ao centro
    text(savedPlayerLeftName, 320, height/2-100); // mostra o texto guardado na variável, na posição em x de 320, e em y a metade da altura menos 100
    textSize(16); // estabelece o tamanho do texto como 16
    text("lost the second round", 320, height/2-50); // mostra o texto da string, na posição em x de 320, e em y a metade da altura menos 50
    text("Let's give " + savedPlayerRightName + " another chance to redeem himself / herself", 320, height/2); // mostra o texto das strings mais o texto guardado na variável, na posição em x de 320, e em y a metade da altura
    textSize(32); // estabelece o tamanho do texto como 32
    text("Press f to start the next challenge", 320, height/2+150); // mostra o texto da string, na posição em x de 320, e em y a metade da altura mais 150
    noLoop();
    // no caso do jogador direito ser o jogador actual e as suas vidas restantes serem igual a 0
  } else if (life == 0 && hasPlayerRightWon == true) {
    state = 2; // muda para o ecrã guardado no void draw com o valor de 2
    hasPlayerLeftWon = false; // reestabelece o boleano de vitória do jogador esquerdo como falso
    hasPlayerRightWon = false; // reestabelece o boleano de vitória do jogador direito como falso
    scoreLeft = 0; // reestabelece o valor da pontuação do jogador esquerdo como 0
    scoreRight = 0; // reestabelece o valor da pontuação do jogador direito como 0
    game_reset();
    background(100); // estabelece a cor do fundo como cinzento
    fill(0); // estabelece a cor do texto como preto
    textSize(64); // estabelece o tamanho do texto como 64
    textAlign(CENTER); // estabelece o alinhamento do texto ao centro
    text(savedPlayerRightName, 320, height/2-100); // mostra o texto guardado na variável, na posição em x de 320, e em y a metade da altura menos 100
    textSize(16); // estabelece o tamanho do texto como 16
    text("lost the second round", 320, height/2-50); // mostra o texto da string, na posição em x de 320, e em y a metade da altura menos 50
    text("Let's give " + savedPlayerLeftName + " another chance to redeem himself / herself", 320, height/2); // mostra o texto das strings mais o texto guardado na variável, na posição em x de 320, e em y a metade da altura
    textSize(32); // estabelece o tamanho do texto como 32
    text("Press f to start the next challenge", 320, height/2+150); // mostra o texto da string, na posição em x de 320, e em y a metade da altura mais 150
    noLoop();
    // no caso de ainda existirem vidas restantes disponíveis diferentes de zero
  } else if (life != 0){
    life--; // subtrai 1 ao valor das vidas
    new_ball(); // reestabelece a bola
    ball_position = new PVector(width/2, brick_bottom_line+20); // reestabelece a posição inicial da bola
    ball_speed = new PVector(1, 2); // reestabelece o valor da velocidade inicial da bola
  }
}
//===================================
// Void responsável por estabelecer acções a teclas pressionadas pelos jogadores
//===================================
void keyPressed() {
  // no caso de pressionar a tecla R
  if (key == 'r') {
    bricks.clear(); // reestabelece os bricks do arraylist
    game_reset();
  }
  // no caso de pressionar a tecla F
  if (key == 'f'){
    pong_game_reset();
  }
  // controlos do Pong
  // jogador / paddle direito
  // no caso de pressionar a tecla Up Arrow
  if (keyCode == UP) {
    pongPaddleRight.speedY = -3; // estabelece a velocidade em y de -3, ou seja, para cima com o valor de 3
  }
  // no caso de pressionar a tecla Down Arrow
  if (keyCode == DOWN) {
    pongPaddleRight.speedY = 3; // estabelece a velocidade em y de 3, ou seja, para baixo com o valor de 3
  }
  // jogador / paddle esquerdo
  // no caso de pressionar a tecla W
  if (keyCode == 'W') {
    pongPaddleLeft.speedY = -3; // estabelece a velocidade em y de -3, ou seja, para cima com o valor de 3
  }
  // no caso de pressionar a tecla S
  if (keyCode == 'S') {
    pongPaddleLeft.speedY = 3; // estabelece a velocidade em y de 3, ou seja, para baixo com o valor de 3
  }
  // no caso de pressionar a tecla N
  if (keyCode == 'N' && canSwitchStates == true) {
    if (state < 3) { // se o estado for 0 (ecrã inicial), 1 (ecrã controlos / tutorial) ou 2 (ecrã pong)
      state = state + 1; // acrescenta 1 ao valor do estado, permitindo avançar na aplicação
    } else {
      return;
    }
   }
   // no caso de pressionar a tecla B
   if (keyCode == 'B'){
     if (state > 2) { // se o estado for 3 (ecrã Arkanoid)
       state = state - 1; // diminui 1 ao valor do estado, permitindo retroceder na aplicação
     } else {
       return;
     }
   }
   // teclas exclusivas para o state 0
   if (state == 0) {
     // ECRÃ INICIAL - USER TEXT INPUT
     if (key == '\n' && isPlayerLeftNameSaved == false && isPlayerRightNameSaved == false) {
       savedPlayerLeftName = typingPlayerLeftName; // estabelece a variável savedPlayerLeftName como igual ao valor da variável typingPlayerLeftName
       // a string pode ser limpa se for definida como "" (vazia)
       typingPlayerLeftName = ""; 
     } else {
       // caso contrário, faz uma concatenação da string
       // cada caracter introduzido pelo jogador / utilizador é acrescentado ao final da string
       typingPlayerLeftName = typingPlayerLeftName + key;
     }
     if (key == '\n' && isPlayerLeftNameSaved == true && isPlayerRightNameSaved == false) {
         savedPlayerRightName = typingPlayerRightName; // estabelece a variável savedPlayerRightName como igual ao valor da variável typingPlayerRightName
         // a string pode ser limpa se for definida como "" (vazia)
         typingPlayerRightName = ""; 
       } else {
         // caso contrário, faz uma concatenação da string
         // cada caracter introduzido pelo jogador / utilizador é acrescentado ao final da string
         typingPlayerRightName = typingPlayerRightName + key; 
       }
     }
}
//===================================
// Void responsável por estabelecer acções quando os jogadores soltam a tecla pressionada, nomeadamente para certificar por exemplo que o movimento dos paddles é negado
//===================================
void keyReleased() {
  // jogador / paddle direito
  // no caso de soltar a tecla Up Arrow
  if (keyCode == UP) {
    pongPaddleRight.speedY = 0; // pára o movimento do paddle direito
  }
  // no caso de soltar a tecla Down Arrow
  if (keyCode == DOWN) {
    pongPaddleRight.speedY = 0; // pára o movimento do paddle direito
  }
  // jogador / paddle esquerdo
  // no caso de soltar a tecla W
  if (keyCode == 'W') {
    pongPaddleLeft.speedY = 0; // pára o movimento do paddle esquerdo
  }
  // no caso de soltar a tecla S
  if (keyCode == 'S') {
    pongPaddleLeft.speedY = 0; // pára o movimento do paddle esquerdo
  }
  // USER TEXT INPUT
  // no caso de soltar a tecla Enter
  if (keyCode == ENTER && isPlayerLeftNameSaved == false && isPlayerRightNameSaved == false) {
    isPlayerLeftNameSaved = true; // estabelece o boleano do nome do jogador esquerdo como verdadeiro, para servir de trigger noutras áreas do sketch
    typingPlayerRightName = ""; // estabelece que a variável é apagada, pois recebia input da referente ao jogador esquerdo
    savedPlayerRightName = ""; // estabelece que a variável é apagada, pois recebia input da referente ao jogador esquerdo
  } else if (keyCode == ENTER && isPlayerLeftNameSaved == true && isPlayerRightNameSaved == false) {
    isPlayerRightNameSaved = true; // estabelece o boleano do nome do jogador direito como verdadeiro, para servir de trigger noutras áreas do sketch
    canSwitchStates = true;
  }
}
//===================================
// FIM dos voids / funções 
//======================================================================
// INÍCIO das classes / métodos 
// (que poderiam estar numa aba diferente no Processing, mas também podem estar presentes no main sketch desde que fora das chavetas)
//===================================
// Class responsável pelo tijolo do Arkanoid
//===================================
class Brick {
  // declaração das variáveis do tijolo
  int center_x, center_y; // variável numérica inteira com as coordenadas do centro
  int rx = brick_rx;
  int ry = brick_ry;

  // criação do tijolo
  Brick(int c_x, int c_y) { // constructor, constrói um tijolo baseado nas suas coordenadas do centro
    center_x = c_x;
    center_y = c_y;
  }

  void draw() { // desenha o objecto do tijolo
    rectMode(RADIUS);
    strokeWeight(2); // estabelece um contorno com o valor de 2
    rect(center_x, center_y, rx, ry);
  }

  // funções para ajudar com a deteção das colisões da bola com os tijolos do Arkanoid 
  // recapitular que os cantos do ecrã são os seguintes:
  // canto superior esquerdo (0, 0)
  // canto superior direito (width, 0)
  // canto inferior esquerdo (0, height)
  // canto inferior direito (width, height)
  int left() {
    return center_x - rx;
  }
  int right() {
    return center_x + rx;
  }
  int top() {
    return center_y - ry;
  }
  int bottom() {
    return center_y + ry;
  }
}
//===================================
// Class responsável pela bola do Pong
//===================================
class PongBall {
  // declaração das variáveis da bola do Pong
  float x; // posição da bola em x
  float y; // posição da bola em y
  float speedX; // velocidade da bola em x
  float speedY; // velocidade da bola em y
  float diameter; // diâmetro da bola
  color c; // cor da bola
  
  // criação da bola
  PongBall(float tempX, float tempY, float tempDiameter) {
    x = tempX;
    y = tempY;
    diameter = tempDiameter; // diâmetro da bola
    speedX = 0; // velocidade inicial da bola em x
    speedY = 0; // velocidade inicial da bola em y
    c = (255); // estabelece a cor da bola como branca
  }
  
  // movimento da bola
  void move() {
    x = x + speedX; // estabelece a nova posição da bola em x, como a soma da posição x mais a velocidade nesse eixo
    y = y + speedY; // estabelece a nova posição da bola em y, como a soma da posição x mais a velocidade nesse eixo
  }
  
  // desenha a bola no ecrã
  void display() {
    fill(c); // estabelece a cor da bola como a gravada na variável c
    ellipse(x,y,diameter,diameter); // desenha um círculo
  }

  // funções para ajudar com a deteção das colisões
  // recapitular que os cantos do ecrã são os seguintes:
  // canto superior esquerdo (0, 0)
  // canto superior direito (width, 0)
  // canto inferior esquerdo (0, height)
  // canto inferior direito (width, height)
  float left() {
    return x - diameter/2;
  }
  float right() {
    return x + diameter/2;
  }
  float top() {
    return y - diameter/2;
  }
  float bottom() {
    return y + diameter/2;
  }
}
//===================================
// Class responsável pelo paddle do Pong
//===================================
class PongPaddle {
  // declaração das variáveis do paddle do Pong
  float x; // posição do paddle em x
  float y; // posição do paddle em y
  float w; // largura do paddle
  float h; // altura do paddle
  float speedX; // velocidade do paddle em x
  float speedY; // velocidade do paddle em y
  color c; // cor do paddle
  
  // criação do paddle
  PongPaddle(float tempX, float tempY, float tempW, float tempH) {
    x = tempX; // posição do paddle em x
    y = tempY; // posição do paddle em y
    w = tempW; // largura do paddle
    h = tempH; // altura do paddle
    speedX = 0; // velocidade inicial do paddle em x
    speedY = 0; // velocidade inicial do paddle em y
    c = (255); // estabelece a cor do paddle como branca
  }
  
  // movimento do paddle
  void move() {
    x += speedX; // estabelece a nova posição do paddle em x, como a soma da velocidade nesse eixo
    y += speedY; // estabelece a nova posição do paddle em y, como a soma da velocidade nesse eixo
  }
  
  // desenho do paddle no ecrã
  void display() {
    fill(c); // estabelece a cor do paddle como a gravada na variável c
    rect(x-w/2,y-h/2,w,h); // cria um rectângulo
  }
  
  // funções para ajudar com a deteção das colisões
  // recapitular que os cantos do ecrã são os seguintes:
  // canto superior esquerdo (0, 0)
  // canto superior direito (width, 0)
  // canto inferior esquerdo (0, height)
  // canto inferior direito (width, height)
  float left() {
    return x-w/2;
  }
  float right() {
    return x+w/2;
  }
  float top() {
    return y-h/2;
  }
  float bottom() {
    return y+h/2;
  }
}
//===================================
// FIM das classes / métodos
//======================================================================
// FIM
//======================================================================