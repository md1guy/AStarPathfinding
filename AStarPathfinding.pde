import java.util.*;

final Random random = new Random();

public int rows = 100;
public int cols = 100;

public float cellWidth;
public float cellHeight;

float xoff = 0.0;
float yoff = 0.0;

public boolean debugMode = false;
public boolean randomWeights = false;
public boolean randomNoiseWeights = true;
public boolean randomObstacles = false;
public boolean randomNoiseObstacles = false;
public boolean showColors = true;

ArrayList<Cell> openSet = new ArrayList();
ArrayList<Cell> closedSet = new ArrayList();
ArrayList<Cell> path  = new ArrayList();

Cell[][] grid = new Cell[rows][cols];
Cell start, end;

void setup () {
  size(900, 900);
  
  cellWidth = height / rows;
  cellHeight = width / cols;
  
  frameRate(10000);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j] = new Cell(i, j);
      if(random.nextInt(100) < 10 && randomObstacles) grid[i][j].obstacle = true;
    }
  }
  
  if(randomNoiseWeights) {
    for(int i = 0; i < rows; i++) {
      xoff = 0.0;
      for(int j = 0; j < cols; j++) {
        grid[j][i].startF = noise(xoff, yoff) * 100;
        xoff += 0.8 / cellWidth;
      }
      yoff += 0.8 / cellHeight;
    }
  }
      
      
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j].addNeighbours(grid);
      if(grid[i][j].startF > 145 && randomNoiseObstacles) grid[i][j].obstacle = true;
    }
  }
  
  start = grid[0][0];
  end = grid[rows - 1][cols - 1];
  
  start.obstacle = false;
  end.obstacle = false;
  
  start.startF = 0;
  end.startF = 0;
  
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
      
      if(neighbour.obstacle) println("obstacle!");
      
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
          neighbour.f = neighbour.startF + neighbour.g + neighbour.h;
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
    noLoop();
    println("no way");
    return;
  }
  
  background(255);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      if(!showColors)grid[i][j].Show(color(map(grid[i][j].startF, 0, 80, 255, 0)));
      else {
        if(grid[i][j].startF > 50) grid[i][j].Show(color(0, 0, map(grid[i][j].startF, 50, 75, 255, 100)));
        else grid[i][j].Show(color(0, map(grid[i][j].startF, 0, 50, 50, 255), 0));
      }
    }
  }
  
  start.Show(color(0, 200, 0));
  end.Show(color(100, 0, 255));
  
  if(debugMode) {
    for (int i = 0; i < openSet.size(); i++) {
      openSet.get(i).Show(color(0, 255, 0));
    }
    
    for (int i = 0; i < closedSet.size(); i++) {
      closedSet.get(i).Show(color(255, 0, 0));
    }
    
    for (int i = 0; i < path.size(); i++) {
      path.get(i).Show(color(0, 0, 255));
    }
  }
  
  noFill();
  stroke(0, 150, 150);
  strokeWeight(3);
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
  //float distance = sqrt(pow((a.i - b.i), 2) + pow((a.j - b.j), 2));
  float distance = abs(a.i - b.i) + abs(a.j - b.j);
  return distance;
}