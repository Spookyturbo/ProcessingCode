/*
* A visual Representation of the
 * A* Pathfinding Algorithm
 */

Map map;
ArrayList<Node> openSet = new ArrayList<Node>();

void setup() {
  size(1000, 600);
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

void draw() {
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


      ArrayList<Node> neighbors = map.getNeighbors(currentNode, false);
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

void mouseClicked() {
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

void findPath() {
  
      while(!foundEnd) {

      Node currentNode = map.startNode;
      try {
        currentNode = cheapestNode();
      } 
      catch(Exception e) {
        println("No solution"); 
        return;
      }


      ArrayList<Node> neighbors = map.getNeighbors(currentNode, false);
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

void initialize() {
  map = new Map(10);
  map.drawMap();

  openSet.add(map.startNode);
}

Node cheapestNode() {
  Node cheap = openSet.get(0);
  for (Node node : openSet) {
    if (node.f < cheap.f) {
      cheap = node;
    }
  }

  return cheap;
}