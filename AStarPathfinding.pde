import java.util.*;

final Random random = new Random();

public int rows = 100;
public int cols = 100;

public float cellWidth;
public float cellHeight;

float xoff = 0.0;
float yoff = 0.0;

public boolean debugMode = false; //shows openList(green), closedList(red), path(blue), grid and (int)weights
public boolean randomWeights = false; //sets random(1-100) weights for each cell. bigger weight - darker cell color, less weight - lighter color
public boolean randomNoiseWeights = false; //sets weight based on perlin noise for each cell, so grid now looks cool and foggy
public boolean randomObstacles = false; //creates obstacles(denim-blue colored) at random positions
public boolean randomNoiseObstacles = false; //creates obstacles at high values of noise  TODO: define and fix a bug with diagonal going through two obstacles in this mode
public boolean showColors = false; //if used with randomNoiseWeights, shows terrain-like colors on grid(water and grass). darker water for higher weight and darker grass for lower weight values

ArrayList<Cell> openList = new ArrayList();
ArrayList<Cell> closedList = new ArrayList();
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
      if(random.nextInt(100) < 25 && randomObstacles) grid[i][j].obstacle = true;
    }
  }
  
  if(randomNoiseWeights || randomNoiseObstacles) {
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
      if(grid[i][j].startF > 55 && randomNoiseObstacles) grid[i][j].obstacle = true;
      if(!randomNoiseWeights && randomWeights) grid[i][j].startF = random.nextInt(99) + 1;
      if(!randomNoiseWeights && !randomWeights) grid[i][j].startF = 1;
    }
  }
  
  start = grid[0][0];
  end = grid[rows - 1][cols - 1];
  
  start.obstacle = false;
  end.obstacle = false;
  
  start.startF = 0;
  end.startF = 0;
  
  openList.add(start);
}

void draw () {
  if(openList.size() > 0) {
    int lowestIndex = 0;
    
    for(int i = 0; i < openList.size(); i++) {
      if(openList.get(i).f < openList.get(lowestIndex).f) lowestIndex = i;
    }
    
    Cell current = openList.get(lowestIndex);
    
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
    
    closedList.add(current);
    openList.remove(lowestIndex);
    
    ArrayList<Cell> neighbours = current.neighbours;

    for(int i = 0; i < neighbours.size(); i++) {
      Cell neighbour = neighbours.get(i);
      
      if(neighbour.obstacle) println("obstacle!");
      
      if(!ExistsInArrayList(closedList, neighbour) && !neighbour.obstacle) {
        float tempG = current.g + 1;
        
        boolean newPath = false;
        
        if(ExistsInArrayList(openList, neighbour)) {
          if(tempG < neighbour.g) {
            neighbour.g = tempG;
          }
        }
        
        else {
          neighbour.g = tempG;
          newPath = true;
          openList.add(neighbour);
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
    for (int i = 0; i < openList.size(); i++) {
      openList.get(i).Show(color(0, 255, 0));
    }
    
    for (int i = 0; i < closedList.size(); i++) {
      closedList.get(i).Show(color(255, 0, 0));
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

void mousePressed() {
  saveFrame("frame-######.png");
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