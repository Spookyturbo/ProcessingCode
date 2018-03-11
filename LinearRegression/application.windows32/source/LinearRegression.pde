Graph graph = new Graph(480, 480);

void setup() { //The canvas is mapped from 0, 1 in both the x and y directions for the purpose of the slope
  size(480, 480);
}

void draw() {
  graph.update();
  if (graph.points.size() > 1) {
    linearRegression();
  }
}

void linearRegression() {
  float sumX = 0;
  float sumY = 0;

  for (PVector point : graph.points) { //sum the x and y to get the average
    sumX += point.x;
    sumY += point.y;
  }

  float averageX = sumX / graph.points.size();
  float averageY = sumY / graph.points.size();

  float num = 0;
  float den = 0;

  for (PVector point : graph.points) { //sum for the formula m = (summation((x - averageX) * (y - averageY))) / (summation((x - averageX) * (x - averageX)))
    num += (point.x - averageX) * (point.y - averageY);
    den += (point.x - averageX) * (point.x - averageX);
  }

  float m = num / den;
  float b = averageY - m * averageX;

  graph.m = m;
  graph.b = b;
}

void mousePressed() { //When clicked add a point to the graph
  graph.addPoint(new PVector(mouseX, mouseY));
}