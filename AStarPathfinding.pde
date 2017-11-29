import java.util.*;

final Random random = new Random();
int rows = 5, cols = 5;
Cell[][] grid = new Cell[rows][cols];
Cell start, end;

void setup () {
  size(400, 400);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j] = new Cell(i, j);
      //if(random.nextInt(10) < 3) grid[i][j].obstacle = true;
    }
  }
  
  start = grid[0][0];
  end = grid[rows - 1][cols - 1];
}

void draw () {
  background(255);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      if(grid[i][j] == start) grid[i][j].Show(color(0, 200, 200));
      else if(grid[i][j] == end) grid[i][j].Show(color(200, 0, 200));
      else if(grid[i][j].obstacle) grid[i][j].Show(color(0, 0, 0));
      else grid[i][j].Show(color(255, 255, 255));
    }
  }
}