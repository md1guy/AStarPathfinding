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
    float cellWidth = height / cols;
    float cellHeight = width / rows;
    
    fill(col);
    noStroke();
    
    rect(i * cellWidth, j * cellHeight, cellWidth - 1, cellHeight - 1);
  }
  
  void addNeighbours (Cell[][] grid)
  {
    if(i < cols - 1) neighbours.add(grid[i + 1][j]);
    if(i > 0) neighbours.add(grid[i - 1][j]);
    if(j < rows - 1) neighbours.add(grid[i][j + 1]);
    if(j > 0) neighbours.add(grid[i][j - 1]);
  }
}