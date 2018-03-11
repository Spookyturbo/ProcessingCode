class Graph {

  public ArrayList<PVector> points = new ArrayList<PVector>();

  int screenWidth = 0;
  int screenHeight = 0;

  public float m = 0;
  public float b = 0;
  public float m2 = 0;
  public float b2 = 0;

  public Graph(int screenWidth, int screenHeight) {
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
  }

  public void addPoint(PVector point) { //Adds a point to the list and the screen. Takes the mousePosition un mapped
    points.add(new PVector(map(point.x, 0, screenWidth, 0, 1), map(point.y, 0, screenHeight, 1, 0)));
  }

  public void update() { //redraws the graph
    background(51);
    drawLine();
    drawPoints();
  }

  void drawLine() { //Draw the line of best fit
    float p1 = yPoint(0);
    float p2 = yPoint(1);
    stroke(255, 0, 0);
    line(0, map(p1, 0, 1, height, 0), map(1, 0, 1, 0, width), map(p2, 0, 1, height, 0));
    stroke(0, 0, 255);
    line(0, map(_yPoint(0), 0, 1, height, 0), map(1, 0, 1, 0, width), map(_yPoint(1), 0, 1, height, 0));
      
}

  float yPoint(float x) { //for point x get point y
    return m * x + b;
  }

  float _yPoint(float x) {
   return m2 * x + b2; 
  }

  void drawPoints() { //redraw all points placed on canvas
    fill(255, 0, 0);
    stroke(255, 0, 0);
    for (PVector point : points) {
      ellipse(map(point.x, 0, 1, 0, width), map(point.y, 0, 1, height, 0), 10, 10);
    }
  }
}