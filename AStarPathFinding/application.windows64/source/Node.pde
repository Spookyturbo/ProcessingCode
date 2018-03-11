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
  
  void setValues(Node previousNode) {
   g = 1 + previousNode.g; 
  }
  
  void calculateHeuristic(Node endNode) {
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