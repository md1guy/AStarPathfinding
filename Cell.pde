class Cell {
  float f = 0;
  float g = 0;
  float h = 0;
  float x, y;
  boolean obstacle = false;

  Cell (int i, int j) {
    this.x = i;
    this.y = j;
  }
  
  void Show (color col) {
    float cellWidth = height / cols;
    float cellHeight = width / rows;
    
    fill(col);
    
    rect(x * cellWidth, y * cellHeight, cellWidth - 1, cellHeight - 1);
  }
}