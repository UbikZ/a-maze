#!/usr/bin/awk -f

function initContext() {
  width = 64;
  height = 200;
  buffer[width, height];

  moveSpeed = 1;
  moves = 0;
  score = 0;
  alive=1;

  KEY_UP = "z";
  KEY_LEFT = "q";
  KEY_RIGHT = "d";
  KEY_DOWN = "s";
  KEY_EXIT = "x";

  dirX = 0;
  dirY = 0;

  posX = 30;
  posY = 20;

  inputKey = KEY_UP;
}

function mainLoop(number) {
  while(1) {
    if (alive == 0) {
      break;
    }
    fillBackground();
    draw();
    printf("%s", inputKey);
    inputKey = getline input;
    handlePosition();
    if (input == KEY_EXIT) {
      break;
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
  if (inputKey == KEY_UP) {
    newPosX = posX + dirX * moveSpeed;
    newPosY = posY + dirY * moveSpeed;
  } else if (inputKey == KEY_LEFT) {
    newPosX = posX - dirY * moveSpeed;
    newPosY = posY + dirX * moveSpeed;
  } else if (inputKey == KEY_RIGHT) {
    newPosX = posX + dirY * moveSpeed;
    newPosY = posY - dirX * moveSpeed;
  } else if (inputKey == KEY_DOWN) {
    newPosX = posX - dirX * moveSpeed;
    newPosY = posY - dirY * moveSpeed;
  } else {
    newPosX = posX;
    newPosY = posY;
  }
  posX = newPosX;
  posY = newPosY;
  buffer[posX, posY] = "X";
}

function draw() {
  print "\033[H"
  for (x = 0; x < width; x++) {
    for (y = 0; y < height; y++) {
      printf buffer[x, y];
    }
    printf "\n";
  }
  print "\033[J"
}
