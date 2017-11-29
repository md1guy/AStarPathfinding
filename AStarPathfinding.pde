import java.util.*;

final Random random = new Random();
int rows = 5, cols = 5;
Cell[][] grid = new Cell[rows][cols];
Cell start, end;

void setup () {
  size(400, 400);
  background(51);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j] = new Cell();
      //if(random.nextInt(10) < 3) grid[i][j].obstacle = true;
    }
  }
  
  start = grid[0][0];
  end = grid[rows-1][cols-1];
  
  DrawGrid();
}

void draw () {

}

void DrawGrid () {
  int x = 0;
  int y = 0;
  
  float cellWidth = height / cols;
  float cellHeight = width / rows;
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      
      if(grid[i][j] == start) {
        fill(0, 0, 255);
        rect(x, y, cellWidth - 1, cellHeight - 1);
        x += cellWidth; 
      }
       
      else if(grid[i][j] == end) {
        fill(0, 255, 0);
        rect(x, y, cellWidth - 1, cellHeight - 1);
        x += cellWidth; 
      }
      
      else if(grid[i][j].obstacle == true) {
        fill(0, 0, 0);
        rect(x, y, cellWidth - 1, cellHeight - 1);
        x += cellWidth; 
      }
      
      else {
        noFill();
        rect(x, y, cellWidth - 1, cellHeight - 1);
        x += cellWidth;
      }
    }
    
    x = 0;
    y += cellHeight;
  }
}