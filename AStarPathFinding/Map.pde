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

  public ArrayList<Node> getNeighbors(Node node, boolean diagonal) {
    ArrayList<Node> neighbors = new ArrayList<Node>();
    int x = (int)node.point.x;
    int y = (int)node.point.y;
    if (x != nodeMap.length - 1) { 
      if (diagonal) {
        if (y != nodeMap[0].length - 1) { 
          neighbors.add(nodeMap[x + 1][y + 1]);
        }
        if (y != 0) {
          neighbors.add(nodeMap[x + 1][y - 1]);
        }
      }
      neighbors.add(nodeMap[x + 1][y]);
    }
    if (x != 0) { 
      if (diagonal) {
        if (y != nodeMap[0].length - 1) { 
          neighbors.add(nodeMap[x - 1][ y + 1]);
        }
        if (y != 0) { 
          neighbors.add(nodeMap[x - 1][y - 1]);
        }
      }
      neighbors.add(nodeMap[x - 1][y]);
    }
    if (y != nodeMap[0].length - 1) { 
      neighbors.add(nodeMap[x][y + 1]);
    }
    if (y != 0) { 
      neighbors.add(nodeMap[x][y - 1]);
    }

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