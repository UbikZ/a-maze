#!/usr/bin/awk -f

function initContext() {
  width = 40;
  height = 100;
  buffer[width, height];

  speed = 1;
  moves = 0;
  score = 0;

  KEY_UP = "z";
  KEY_LEFT = "q";
  KEY_RIGHT = "d";
  KEY_DOWN = "s";
  KEY_EXIT = "x";

  deltaX = 1;
  deltaY = 1;

  posX = 30;
  posY = 20;
}

function mainLoop(number) {
  while(1) {
    fillBackground();
    handlePosition();
    draw();

    system("stty -echo");
    cmd = "saved=$(stty -g); stty raw; var=$(dd bs=1 count=1 2>/dev/null); stty \"$saved\"; echo \"$var\"";
    cmd | getline input;
    close(cmd)
    system("stty echo");

    if (input == KEY_EXIT) {
      exit;
    }
  }
}

function fillBackground() {
  for (x = 0; x < width; x++) {
    for (y = 0; y < height; y++) {
      if (x == 0 || y == 0 || x == (width - 1) || y == (height - 1)) {
        buffer[x, y] = "O";
      } else {
          buffer[x, y]= " ";
      }
    }
  }
}

function handlePosition() {
  str = KEY_UP KEY_DOWN KEY_LEFT KEY_RIGHT;
  newPosX = posX;
  newPosY = posY;

  if (input == KEY_UP && posX > 1) {
    moves++;
    newPosX = posX - deltaX * speed;
  } else if (input == KEY_LEFT && posY > 1) {
    moves++;
    newPosY = posY - deltaY * speed;
  } else if (input == KEY_RIGHT && posY < (height - 2)) {
    moves++;
    newPosY = posY + deltaY * speed;
  } else if (input == KEY_DOWN && posX < (width - 2)) {
    moves++;
    newPosX = posX + deltaX * speed;
  }

  posX = newPosX;
  posY = newPosY;
  buffer[newPosX, newPosY] = "X";
}

function draw() {
  print("\033[H");
  for (x = 0; x < width; x++) {
    for (y = 0; y < height; y++) {
      printf(buffer[x, y]);
    }
    printf("\n");
  }
  drawUI();
  print("\033[J");
}

function drawUI() {
  infoKeys = sprintf("> Keys : [↑ %s] [→ %s] [↓ %s] [← %s] [Exit x]", KEY_UP, KEY_RIGHT, KEY_DOWN, KEY_LEFT);
  infoMoves = sprintf("> Position : [x = %d ; y = %d] | Moves : %d", posX, posY, moves);
  printf ("%s\n%s", infoKeys, infoMoves);
}
