#!/usr/bin/awk -f

function initContext() {
  width = 40;
  height = 100;
  maze[width, height];

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

  posX = 1;
  posY = 1;

  initMaze(maze, width, height, posX, posY);
}

function mainLoop(number) {
  while(1) {
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

function handlePosition() {
  str = KEY_UP KEY_DOWN KEY_LEFT KEY_RIGHT;
  maze[posX][posY] = 0; # Reset position
  newPosX = posX;
  newPosY = posY;

  if (input == KEY_UP && posX > 1) {
    newPosX = posX - deltaX * speed;
  } else if (input == KEY_LEFT && posY > 1) {
    newPosY = posY - deltaY * speed;
  } else if (input == KEY_RIGHT && posY < (height - 2)) {
    newPosY = posY + deltaY * speed;
  } else if (input == KEY_DOWN && posX < (width - 2)) {
    newPosX = posX + deltaX * speed;
  }

  # Check walls collision
  if (maze[newPosX][newPosY] != 1) {
    moves++;
    posX = newPosX;
    posY = newPosY;
    maze[newPosX][newPosY] = 2;
  } else {
    maze[posX][posY] = 2;
  }
}

function draw() {
  print("\033[H");
  for (x = 0; x < width; x++) {
    for (y = 0; y < height; y++) {
      if (maze[x][y] == 1) {
        printPixel("100", "", " ");
      } else if (maze[x][y] == 2) {
        printPixel("102", "", " ");
      } else {
        printPixel("40", "", " ");
      }
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
