class Cell {
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
  }
  
  void Show (color col) {
    stroke(0);
    strokeWeight(1);
    fill(col);
    if(obstacle) fill(0);
    
    rect(i * cellWidth, j * cellHeight, cellWidth - 1, cellHeight - 1);
  }
  
  void addNeighbours (Cell[][] grid)
  {
    if(i < rows - 1) {
      neighbours.add(grid[i + 1][j]);
    }
    if(i > 0) {
      neighbours.add(grid[i - 1][j]);
    }
    if(j < cols - 1) {
      neighbours.add(grid[i][j + 1]);
    }
    if(j > 0) {
      neighbours.add(grid[i][j - 1]);
    }
    
    if(i > 0 && j > 0 && !grid[i - 1][j].obstacle && !grid[i][j - 1].obstacle) {
      grid[i - 1][j - 1].g += 0.1;
      neighbours.add(grid[i - 1][j - 1]);
    }
    
    if(i < rows - 1 && j > 0 && !grid[i + 1][j].obstacle && !grid[i][j - 1].obstacle) {
      grid[i + 1][j - 1].g += 0.1;
      neighbours.add(grid[i + 1][j - 1]);
    }
    
    if(i > 0 && j < cols - 1 && !grid[i - 1][j].obstacle && !grid[i][j + 1].obstacle) {
      grid[i - 1][j + 1].g += 0.1;
      neighbours.add(grid[i - 1][j + 1]);
    }
    
    if(i < rows - 1 && j < cols - 1 && !grid[i + 1][j].obstacle && !grid[i][j + 1].obstacle) {
      grid[i + 1][j + 1].g += 0.1;
      neighbours.add(grid[i + 1][j + 1]);
    }
  }
}