import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AStarPathfinding extends PApplet {



final Random random = new Random();

public int rows = 50;
public int cols = 50;

public float cellWidth;
public float cellHeight;

public boolean debugMode = false;
public boolean randomWeights = false;
public boolean obstacles = true;

Cell[][] grid = new Cell[rows][cols];
Cell start, end;

ArrayList<Cell> openSet = new ArrayList();
ArrayList<Cell> closedSet = new ArrayList();
ArrayList<Cell> path  = new ArrayList();

public void setup () {
  
  
  cellWidth = height / rows;
  cellHeight = width / cols;
  
  frameRate(10000);
  
  for(int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      grid[i][j] = new Cell(i, j);
      if(random.nextInt(100) < 25 && obstacles) grid[i][j].obstacle = true;
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

public void draw () {
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
          neighbour.f = neighbour.staticF + neighbour.g + neighbour.h;
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
      grid[i][j].Show(color(map(grid[i][j].staticF, 1, 100, 255, 75)));
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
  strokeWeight(5);
  beginShape();
  for(int i = 0; i < path.size(); i++) {
    vertex(path.get(i).i * cellWidth + cellWidth / 2, path.get(i).j * cellHeight + cellHeight / 2);
  }
  endShape();
  
}

public boolean ExistsInArrayList(ArrayList<Cell> list, Cell cell) {
  for(int i = 0; i < list.size(); i++) {
    if(list.get(i) == cell) {
      return true;
    }
  }
  return false;
}


public float Heuristic(Cell a, Cell b) {
  //float distance = dist(a.i, a.j, b.i, b.j);
  //float distance = sqrt(pow((a.i - b.i), 2) + pow((a.j - b.j), 2));
  float distance = abs(a.i - b.i) + abs(a.j - b.j);
  return distance;
}
class Cell {
  float staticF = random.nextInt(100);
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
    if(!randomWeights) this.staticF = 1;
  }
  
  public void Show (int col) {
    noStroke();
    
    if(debugMode) stroke(0);
    
    strokeWeight(1);
    fill(col);
    //if(obstacle) fill(0);
    
    if(obstacle) {
      fill(0);
      //ellipse(i * cellWidth, j * cellHeight, 10, 10);
    }
    
    rect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
    fill(0);
    textAlign(BASELINE);
    textSize(10);
    if(debugMode) text(PApplet.parseInt(staticF), i * cellWidth, j * cellHeight + cellHeight); 
  }
  
  public void addNeighbours (Cell[][] grid)
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
      grid[i - 1][j - 1].g += 0.5f;
      neighbours.add(grid[i - 1][j - 1]);
    }
    
    if(i < rows - 1 && j > 0 && !grid[i + 1][j].obstacle && !grid[i][j - 1].obstacle) {
      grid[i + 1][j - 1].g += 0.5f;
      neighbours.add(grid[i + 1][j - 1]);
    }
    
    if(i > 0 && j < cols - 1 && !grid[i - 1][j].obstacle && !grid[i][j + 1].obstacle) {
      grid[i - 1][j + 1].g += 0.5f;
      neighbours.add(grid[i - 1][j + 1]);
    }
    
    if(i < rows - 1 && j < cols - 1 && !grid[i + 1][j].obstacle && !grid[i][j + 1].obstacle) {
      grid[i + 1][j + 1].g += 0.5f;
      neighbours.add(grid[i + 1][j + 1]);
    }
  }
}

  public void settings() {  size(900, 900); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AStarPathfinding" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
