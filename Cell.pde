class Cell {
  float startF = random.nextInt(99) + 1;
  float f = 0;
  float g = 0;
  float h = 0;
  int i;
  int j;

  Cell cameFrom = null;

  boolean obstacle = false;

  ArrayList<Cell> neighbours = new ArrayList();

  Cell (int i, int j) {
    this.i = i;
    this.j = j;
    if (!randomWeights) this.startF = 1;
  }

  void Show (color col) {
    noStroke();

    if (debugMode) stroke(0);

    strokeWeight(1);
    fill(col);

    if (obstacle) {
      fill(0, 100, 255);
    }

    rect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
    fill(0);
    textAlign(BASELINE);
    textSize(cellWidth / 2);
    if (debugMode) text(int(startF), i * cellWidth, j * cellHeight + cellHeight);
  }

  void addNeighbours (Cell[][] grid)
  {
    if (i < rows - 1) {
      neighbours.add(grid[i + 1][j]);
    }
    if (i > 0) {
      neighbours.add(grid[i - 1][j]);
    }
    if (j < cols - 1) {
      neighbours.add(grid[i][j + 1]);
    }
    if (j > 0) {
      neighbours.add(grid[i][j - 1]);
    }

    if (i > 0 && j > 0 && !grid[i - 1][j].obstacle && !grid[i][j - 1].obstacle) {
      neighbours.add(grid[i - 1][j - 1]);
    }

    if (i < rows - 1 && j > 0 && !grid[i + 1][j].obstacle && !grid[i][j - 1].obstacle) {
      neighbours.add(grid[i + 1][j - 1]);
    }

    if (i > 0 && j < cols - 1 && !grid[i - 1][j].obstacle && !grid[i][j + 1].obstacle) {
      neighbours.add(grid[i - 1][j + 1]);
    }

    if (i < rows - 1 && j < cols - 1 && !grid[i + 1][j].obstacle && !grid[i][j + 1].obstacle) {
      neighbours.add(grid[i + 1][j + 1]);
    }
  }
}