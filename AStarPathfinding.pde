import java.util.*;

final Random random = new Random();

public int rows = 50;
public int cols = 50;

public float cellWidth;
public float cellHeight;

Cell[][] grid = new Cell[rows][cols];
Cell start, end;

ArrayList<Cell> openSet = new ArrayList();
ArrayList<Cell> closedSet = new ArrayList();
ArrayList<Cell> path  = new ArrayList();

void setup () {
  size(900, 900);
  
  cellWidth = height / rows;
  cellHeight = width / cols;
  
  frameRate(10000);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j] = new Cell(i, j);
      if(random.nextInt(10) < 3) grid[i][j].obstacle = true;
    }
  }
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j].addNeighbours(grid);
    }
  }
  
  start = grid[0][0];
  end = grid[rows - 1][cols - 1];
  
  start.obstacle = false;
  end.obstacle = false;
  
  openSet.add(start);
}

void draw () {
  if(openSet.size() > 0) {
    int lowestIndex = 0;
    
    for(int i = 0; i < openSet.size(); i++) {
      if(openSet.get(i).f < openSet.get(lowestIndex).f) lowestIndex = i;
    }
    
    Cell current = openSet.get(lowestIndex);
    
    if(current == end) {
      path = new ArrayList();
      Cell temp = current;
      path.add(temp);
      while(temp.cameFrom != null) {
        path.add(temp.cameFrom);
        temp = temp.cameFrom;
      }
      noLoop();
      println("done");
    }
    
    closedSet.add(current);
    openSet.remove(lowestIndex);
    
    ArrayList<Cell> neighbours = current.neighbours;

    for(int i = 0; i < neighbours.size(); i++) {
      Cell neighbour = neighbours.get(i);
      
      if(!ExistsInArrayList(closedSet, neighbour) && !neighbour.obstacle) {
        float tempG = current.g + 1;
        
        boolean newPath = false;
        
        if(ExistsInArrayList(openSet, neighbour)) {
          if(tempG < neighbour.g) {
            neighbour.g = tempG;
          }
        }
        
        else {
          neighbour.g = tempG;
          newPath = true;
          openSet.add(neighbour);
        }
        
        if(newPath) {
          neighbour.h = Heuristic(neighbour, end);
          neighbour.f = neighbour.g + neighbour.h;
          neighbour.cameFrom = current;
        }
        
        path = new ArrayList();
        Cell temp = current;
        path.add(temp);
        while(temp.cameFrom != null) {
          path.add(temp.cameFrom);
          temp = temp.cameFrom;
        }
      }
    }
  }
  
  else {
    println("no solution");
    noLoop();
    return;
  }
  
  background(255);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j].Show(color(255, 255, 255));
    }
  }
  /*
  for (int i = 0; i < openSet.size(); i++) {
    openSet.get(i).Show(color(0, 255, 0));
  }
  
  for (int i = 0; i < closedSet.size(); i++) {
    closedSet.get(i).Show(color(255, 0, 0));
  }
  
  for (int i = 0; i < path.size(); i++) {
    path.get(i).Show(color(0, 0, 255));
  }
  */
  noFill();
  stroke(0, 150, 150);
  strokeWeight(5);
  beginShape();
  for(int i = 0; i < path.size(); i++) {
    vertex(path.get(i).i * cellWidth + cellWidth / 2, path.get(i).j * cellHeight + cellHeight / 2);
  }
  endShape();
  
}

boolean ExistsInArrayList(ArrayList<Cell> list, Cell cell) {
  for(int i = 0; i < list.size(); i++) {
    if(list.get(i) == cell) {
      return true;
    }
  }
  return false;
}


float Heuristic(Cell a, Cell b) {
  //float distance = dist(a.i, a.j, b.i, b.j);
  float distance = abs(a.i - b.i) + abs(a.j - b.j); 
  return distance;
}