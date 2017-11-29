import java.util.*;

final Random random = new Random();

public int rows = 50;
public int cols = 50;

Cell[][] grid = new Cell[rows][cols];
Cell start, end;

ArrayList<Cell> openSet = new ArrayList();
ArrayList<Cell> closedSet = new ArrayList();

void setup () {
  size(600, 600);
  
  frameRate(10000);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j] = new Cell(i, j);
      //if(random.nextInt(10) < 3) grid[i][j].obstacle = true;
    }
  }
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j].addNeighbours(grid);
    }
  }
  
  start = grid[0][0];
  end = grid[rows - 1][cols - 1];
  
  openSet.add(start);
}

void draw () {
  if(openSet.size()>0) {
    int lowestIndex = 0;
    
    for(int i = 0; i < openSet.size(); i++) {
      if(openSet.get(i).f < openSet.get(lowestIndex).f) lowestIndex = i;
    }
    
    Cell current = openSet.get(lowestIndex);
    
    if(current == end) println("done");
    
    closedSet.add(current);
    openSet.remove(lowestIndex);
    
    ArrayList<Cell> neighbours = current.neighbours;

    for(int i = 0; i < neighbours.size(); i++) {
      Cell neighbour = neighbours.get(i);
      
      if(!ExistsInArrayList(closedSet, neighbour)) {
        float tempG = current.g + 1;
        
        if(ExistsInArrayList(openSet, neighbour)) {
          if(tempG < neighbour.g) {
            neighbour.g = tempG;
          }
        }
        else {
          neighbour.g = tempG;
          openSet.add(neighbour);
        }
      }
    }
  }
  
  
  
  else {
    //no solution
  }
  
  background(255);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      if(grid[i][j].obstacle) grid[i][j].Show(color(0, 0, 0));
      else grid[i][j].Show(color(255, 255, 255));
    }
  }
  
  for (int i = 0; i < openSet.size(); i++) {
    openSet.get(i).Show(color(0, 255, 0));
  }
  
  for (int i = 0; i < closedSet.size(); i++) {
    closedSet.get(i).Show(color(255, 0, 0));
  }
}

boolean ExistsInArrayList(ArrayList<Cell> list, Cell cell) {
  for(int i = 0; i < list.size(); i++) {
    if(list.get(i) == cell) {
      return true;
    }
  }
  return false;
}