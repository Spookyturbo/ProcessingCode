import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AStarPathFinding extends PApplet {

/*
* A visual Representation of the
 * A* Pathfinding Algorithm
 */

Map map;
ArrayList<Node> openSet = new ArrayList<Node>();

public void setup() {
  
  background(51);
  map = new Map(10);
  map.drawMap();

  openSet.add(map.startNode);
  
  //findPath();
  map.drawMap();
}

boolean foundEnd = false;
boolean printed = false;
boolean started = false;

public void draw() {
  if (started) {
    if (!foundEnd) {

      Node currentNode = map.startNode;
      try {
        currentNode = cheapestNode();
      } 
      catch(Exception e) {
        println("No solution"); 
        return;
      }


      ArrayList<Node> neighbors = map.getNeighbors(currentNode);
      for (Node neighbor : neighbors) {
        if (neighbor.type == NodeType.End) {
          neighbor.parent = currentNode;
          foundEnd = true;
        } else if (neighbor.type == NodeType.Open) {
          if (currentNode.g + 1 < neighbor.g) {
            neighbor.parent = currentNode;
            neighbor.g = currentNode.g + 1;
            neighbor.f = neighbor.g + neighbor.h;
          }
        } else if (neighbor.type == NodeType.Walk) {
          openSet.add(neighbor);
          neighbor.type = NodeType.Open;
          neighbor.parent = currentNode;
          neighbor.g = currentNode.g + 1;
          neighbor.f = neighbor.g + neighbor.h;
        }
      }
      map.drawMap();
      currentNode.type = NodeType.Closed;
      openSet.remove(currentNode);
    } else if (!printed) {
      Node currentNode = map.endNode.parent;

      while (currentNode.parent != null) {
        currentNode.type = NodeType.Path;
        currentNode = currentNode.parent;
      }
      map.startNode.type = NodeType.Start;
      map.drawMap();
      println("Found the solution"); 
      printed = true;
    }
  }
}

public void mouseClicked() {
  if(started) {
   map.initializeMap();
   map.drawMap();
   openSet.clear();
   openSet.add(map.startNode);
   foundEnd = false;
   printed = false;
   started = false;
  }
  else {
      started = true;
  }

}

public void findPath() {
  
      while(!foundEnd) {

      Node currentNode = map.startNode;
      try {
        currentNode = cheapestNode();
      } 
      catch(Exception e) {
        println("No solution"); 
        return;
      }


      ArrayList<Node> neighbors = map.getNeighbors(currentNode);
      for (Node neighbor : neighbors) {
        if (neighbor.type == NodeType.End) {
          neighbor.parent = currentNode;
          foundEnd = true;
        } else if (neighbor.type == NodeType.Open) {
          if (currentNode.g + 1 < neighbor.g) {
            neighbor.parent = currentNode;
            neighbor.g = currentNode.g + 1;
            neighbor.f = neighbor.g + neighbor.h;
          }
        } else if (neighbor.type == NodeType.Walk) {
          openSet.add(neighbor);
          neighbor.type = NodeType.Open;
          neighbor.parent = currentNode;
          neighbor.g = currentNode.g + 1;
          neighbor.f = neighbor.g + neighbor.h;
        }
      }
      currentNode.type = NodeType.Closed;
      openSet.remove(currentNode);
    }
      Node currentNode = map.endNode.parent;

      while (currentNode.parent != null) {
        currentNode.type = NodeType.Path;
        currentNode = currentNode.parent;
      }
      map.startNode.type = NodeType.Start;
      map.drawMap();
      println("Found the solution"); 
      printed = true;

}

public void initialize() {
  map = new Map(10);
  map.drawMap();

  openSet.add(map.startNode);
}

public Node cheapestNode() {
  Node cheap = openSet.get(0);
  for (Node node : openSet) {
    if (node.f < cheap.f) {
      cheap = node;
    }
  }

  return cheap;
}
class Map {

  Node[][] nodeMap;

  Node startNode;
  Node endNode;

  int squareSize;

  public Map(int squareSize) {
    this.squareSize = squareSize;
    nodeMap = new Node[width / squareSize][height / squareSize];

    initializeMap();
  }

  public Node getStartNode() {
    for (int x = 0; x < nodeMap.length; x++) {
      for (int y = 0; y < nodeMap[0].length; y++) {
        if (nodeMap[x][y].type == NodeType.Start) {
          return nodeMap[x][y];
        }
      }
    }
    return null;
  }

  public void initializeMap() {
    generateRandomMap();
    startNode = getStartNode();
    endNode = getEndNode();

    startNode.g = 0;

    for (int x = 0; x < nodeMap.length; x++) {
      for (int y = 0; y < nodeMap[0].length; y++) {
        nodeMap[x][y].calculateHeuristic(endNode);
      }
    }
  }

  public ArrayList<Node> getNeighbors(Node node) {
    ArrayList<Node> neighbors = new ArrayList<Node>();
    int x = (int)node.point.x;
    int y = (int)node.point.y;
    if (x != nodeMap.length - 1) { neighbors.add(nodeMap[x + 1][y]); }
    if(x != 0) { neighbors.add(nodeMap[x - 1][y]); }
    if(y != nodeMap[0].length - 1) { neighbors.add(nodeMap[x][y + 1]); }
    if(y != 0) { neighbors.add(nodeMap[x][y - 1]); }
    
    return neighbors;
  }

  public Node getEndNode() {
    for (int x = 0; x < nodeMap.length; x++) {
      for (int y = 0; y < nodeMap[0].length; y++) {
        if (nodeMap[x][y].type == NodeType.End) {
          return nodeMap[x][y];
        }
      }
    }
    return null;
  }

  public void generateRandomMap() {
    PVector start = new PVector((int)random(nodeMap.length), (int)random(nodeMap[0].length));
    PVector end = new PVector((int)random(nodeMap.length), (int)random(nodeMap[0].length));

    for (int x = 0; x < nodeMap.length; x++) {
      NodeType nodeType = NodeType.Default;
      for (int y = 0; y < nodeMap[0].length; y++) {
        if (x == start.x && y == start.y) {
          nodeType = NodeType.Start;
        } else if (x == end.x && y == end.y) {
          nodeType = NodeType.End;
        } else {
          if (random(100) < 65) {
            nodeType = NodeType.Walk;
          } else {
            nodeType = NodeType.Wall;
          }
        }

        nodeMap[x][y] = new Node(nodeType, new PVector(x, y), squareSize);
      }
    }
  }

  public void drawMap() {
    for (int x = 0; x < nodeMap.length; x++) {
      for (int y = 0; y < nodeMap[0].length; y++) {
        nodeMap[x][y].drawNode();
      }
    }
  }
}
class Node {
  
  public NodeType type;
  public Node parent = null;
  
  public double h = 0; //Heuristic
  public double g = Double.POSITIVE_INFINITY; //Distance from start to here
  public double f = 0; //h + g
  
  PVector point;
  int size;
  
  public Node(NodeType type, PVector point, int size) {
    this.point = point;
    this.type = type;
    this.size = size;
  }
  
  public void setValues(Node previousNode) {
   g = 1 + previousNode.g; 
  }
  
  public void calculateHeuristic(Node endNode) {
    h = sq(endNode.point.x - point.x) + sq(endNode.point.y - point.y);
    f = h + g;
  }
  
  public void drawNode() {
    switch(type) {
     case Wall:
       stroke(0xFF000000);
       fill(0xFF000000);
       break;
     case Walk:
       stroke(70);
       fill(70);
       break;
     case Open:
       stroke(0xFF0000FF);
       fill(0xFF0000FF);
       break;
     case Closed:
       stroke(255, 0, 0);
       fill(255, 0, 0);
       break;
     case Start:
       stroke(0xFF00FF00);
       fill(0xFF00FF00);
       break;
     case End:
       stroke(0xFFFF00FF);
       fill(0xFFFF00FF);
       break;
     case Path:
       stroke(0xFFFFFF00);
       fill(0xFFFFFF00);
       break;
    }
    noStroke();
    rect(point.x * size, point.y * size, size, size);
  }
  
}
enum NodeType {
 Open,
 Closed,
 Wall,
 Walk,
 Start,
 End,
 Path,
 Default
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AStarPathFinding" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
