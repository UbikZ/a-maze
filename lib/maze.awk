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
  disableRecursion = false;
  depth++;
  endPoint = 0;

  #if (depth > 6) exit;

  for (i in randDirections) {
    randDirection = randDirections[i];

    #print "[" depth "] => " randDirection " { " newPosX ", " newPosY " }"

    switch (randDirection) {
      case 0: # UP
        if (fromPosX - 2 <= 0) {
          continue;
        }

        if (maze[fromPosX - 2][fromPosY] == 1) {
          debug = "[" depth "] => UP {" (fromPosX - 2) ", " fromPosY "}"
          #system("echo \"" debug "\" >> test")

          maze[fromPosX - 2][fromPosY] = 0;
          maze[fromPosX - 1][fromPosY] = 0;
          recurseGeneration(maze, fromPosX - 2, fromPosY, xMax, yMax, depth);
        } else {
          endPoint++;
        }
        break;
      case 1: # RIGHT
        if (fromPosY + 2 >= yMax - 1) {
          continue;
        }
        if (maze[fromPosX][fromPosY + 2] == 1) {
          debug = "[" depth "] => RIGHT {" (fromPosX) ", " (fromPosY + 2) "}"
          #system("echo \"" debug "\" >> test")

          maze[fromPosX][fromPosY + 2] = 0;
          maze[fromPosX][fromPosY + 1] = 0;
          recurseGeneration(maze, fromPosX, fromPosY + 2, xMax, yMax, depth);
        } else {
          endPoint++;
        }
        break;
      case 2: # BOTTOM
        if (fromPosX + 2 >= xMax - 1) {
          continue;
        }

        if (maze[fromPosX + 2][fromPosY] == 1) {
          debug = "[" depth "] => BOT {" (fromPosX + 2) ", " fromPosY "}"
          #system("echo \"" debug "\" >> test")

          maze[fromPosX + 2][fromPosY] = 0;
          maze[fromPosX + 1][fromPosY] = 0;
          recurseGeneration(maze, fromPosX + 2, fromPosY, xMax, yMax, depth);
        } else {
          endPoint++;
        }
        break;
      case 3: # LEFT
        if (fromPosY - 2 <= 0) {
          continue;
        }

        if (maze[fromPosX][fromPosY - 2] == 1) {
          debug = "[" depth "] => LEFT {" (fromPosY) ", " (fromPosY - 2) "}"
          #system("echo \"" debug "\" >> test")

          maze[fromPosX][fromPosY - 2] = 0;
          maze[fromPosX][fromPosY - 1] = 0;
          recurseGeneration(maze, fromPosX, fromPosY - 2, xMax, yMax, depth);
        } else {
          endPoint++;
        }
        break;
    }
  }

  if (endPoint == length(randDirections)) {
    maze[fromPosX][fromPosY] = 3;
  }
}

function printPixel(bg_color, fg_color, text){
  printf("\033[" bg_color ";" fg_color "m" text "\033[0m");
}
