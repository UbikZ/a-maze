#!/usr/bin/awk -f

BEGIN {
  initMaze();
}

function initMaze() {
  width = 40;
  height = 100;
  buildMaze(maze, width, height);

  startPosX = _rand(width);
  startPosY = _rand(height);

  maze[startPosX, startPosY] = 0; # 0 <=> Path cell (for starter)

  print "BASE : " startPosX " | " startPosY
  recurseGeneration(maze, startPosX, startPosY, width, height);
  draw(maze, width, height);
}

function _rand(max, val) {
  if (length(val) == 0) {
    val = 1;
  }
  "date +%s" | getline timestamp;
  srand(timestamp * max * val);
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
  printf max " - " length(stack) " - " len " - " val " -> "
  while (length(stack) != len) {
    random = _rand(max, i * val);
    # Check the unicity
    if ((length(stack) == 0) || (index(stack, random) == 0)) {
      array[j] = random;
      stack = stack random;
      j++;
      printf random " "
    }
    i++;
  }
  printf "\n"
}

function buildMaze(maze, width, height) {
  maze[width, height];
  for (x = 0; x < width; x++) {
    for (y = 0; y < height; y++) {
        maze[x, y] = 1; # 1 <=> Wall cell (everywhere)
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

  for (i = 0; i < length(randDirections); i++) {
    randDirection = randDirections[i];

    print "[" depth "] => " randDirection " { " newPosX ", " newPosY " }"

    if (randDirection == 0) { # UP
      if (fromPosX - 2 <= 0) {
        continue;
      }

      newPosX = fromPosX - 2;
      if (maze[newPosX, newPosY] != 0) {
        maze[newPosX, newPosY] = 0;
        maze[fromPosX - 1, newPosY] = 0;
        recurseGeneration(maze, newPosX, newPosY, xMax, yMax, depth);
      }
    }
    if (randDirection == 1) { # RIGHT
      if (fromPosY + 2 >= xMax - 1) {
        continue;
      }

      newPosY = fromPosY + 2;
      if (maze[newPosX, fromPosY + 2] != 0) {
        maze[newPosX, newPosY] = 0;
        maze[newPosX, fromPosY + 1] = 0;
        recurseGeneration(maze, newPosX, newPosY, xMax, yMax, depth);
      }
    }
    if (randDirection == 2) { # BOTTOM
      if (fromPosX + 2 >= yMax - 1) {
        continue;
      }

      newPosX = fromPosX + 2;
      if (maze[newPosX, newPosY] != 0) {
        maze[newPosX, newPosY] = 0;
        maze[fromPosX + 1, newPosY] = 0;
        recurseGeneration(maze, newPosX, newPosY, xMax, yMax, depth);
      }
    }
    if (randDirection == 3) { # LEFT
      if (fromPosY - 2 <= 0) {
        continue;
      }

      newPosY = fromPosY - 2;
      if (maze[newPosX, newPosY] != 0) {
        maze[newPosX, newPosY] = 0;
        maze[newPosX, fromPosY - 1] = 0;
        recurseGeneration(maze, newPosX, newPosY, xMax, yMax, depth);
      }
    }
  }
}

function draw(maze, xMax, yMax) {
  print("\033[H");
  for (x = 0; x < xMax; x++) {
    for (y = 0; y < yMax; y++) {
      if (maze[x, y] == 1) {
        printf("X");
      } else {
        printf(" ");
      }
    }
    printf("\n");
  }
  print("\033[J");
}
