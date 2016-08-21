#!/usr/bin/awk -f

function initMaze(maze, width, height, startPosX, startPosY) {
  buildMaze(maze, width, height);

  recurseGeneration(maze, startPosX, startPosY, width, height);
  maze[startPosX][startPosY] = 2;
}

function _rand(max, val) {
  if (length(val) == 0) {
    val = 1;
  }
  seed = systime() * max * val;
  srand(seed);
  random = rand();
  divider = int(max * 10);
  while (divider >= 1) {
    random *= 10;
    divider = int(divider / 10);
  }
  random %= max;

  return int(random);
}

# Generate array with random numbers
function _randArray(array, max, len, val) {
  if (length(val) == 0) {
    val = 1;
  }
  i = 0; j = 0; stack = "";
  while (length(stack) != len) {
    random = _rand(max, i * val);
    # Check the unicity
    if ((length(stack) == 0) || (index(stack, random) == 0)) {
      array[j] = random;
      stack = stack random;
      j++;
    }
    i++;
  }
}

function buildMaze(maze, width, height) {
  maze[width][height];
  for (x = 0; x < width; x++) {
    for (y = 0; y < height; y++) {
        maze[x][y] = 1; # 1 <=> Wall cell (everywhere)
    }
  }
}

function recurseGeneration(maze, fromPosX, fromPosY, xMax, yMax, depth) {
  _randArray(randDirections, 4, 4, depth); # 0 : UP | 1 : RIGHT | 2 : BOTTOM | 3 : LEFT
  newPosX = fromPosX;
  newPosY = fromPosY;
  disableRecursion = false;
  depth++;

  #if (depth > 6) exit;

  for (i in randDirections) {
    randDirection = randDirections[i];

    #print "[" depth "] => " randDirection " { " newPosX ", " newPosY " }"

    if (randDirection == 0) { # UP
      if (fromPosX - 2 <= 0) {
        continue;
      }

      newPosX = fromPosX - 2;
      if (maze[newPosX][newPosY] != 0) {
        maze[newPosX][newPosY] = 0;
        maze[fromPosX - 1][newPosY] = 0;
        recurseGeneration(maze, newPosX, newPosY, xMax, yMax, depth);
      }
    }
    if (randDirection == 1) { # RIGHT
      if (fromPosY + 2 >= yMax - 1) {
        continue;
      }

      newPosY = fromPosY + 2;
      if (maze[newPosX][fromPosY + 2] != 0) {
        maze[newPosX][newPosY] = 0;
        maze[newPosX][fromPosY + 1] = 0;
        recurseGeneration(maze, newPosX, newPosY, xMax, yMax, depth);
      }
    }
    if (randDirection == 2) { # BOTTOM
      if (fromPosX + 2 >= xMax - 1) {
        continue;
      }

      newPosX = fromPosX + 2;
      if (maze[newPosX][newPosY] != 0) {
        maze[newPosX][newPosY] = 0;
        maze[fromPosX + 1][newPosY] = 0;
        recurseGeneration(maze, newPosX, newPosY, xMax, yMax, depth);
      }
    }
    if (randDirection == 3) { # LEFT
      if (fromPosY - 2 <= 0) {
        continue;
      }

      newPosY = fromPosY - 2;
      if (maze[newPosX][newPosY] != 0) {
        maze[newPosX][newPosY] = 0;
        maze[newPosX][fromPosY - 1] = 0;
        recurseGeneration(maze, newPosX, newPosY, xMax, yMax, depth);
      }
    }
  }
}

function printPixel(bg_color, fg_color, text){
  printf("\033[" bg_color ";" fg_color "m" text "\033[0m");
}
