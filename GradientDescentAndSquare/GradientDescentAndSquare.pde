/*
* Used to model a gradient descent approach to 
 * Linear Regression
 */

Graph graph = new Graph(480, 480);

void setup() {
  size(480, 480);
}

void draw() {
  graph.update();
  if (graph.points.size() > 1) {
    gradientDescent();
    linearRegression();
    
    float squares = calculateSumOfSquares(graph.points, graph.m2, graph.b2);
    float gradient = calculateSumOfSquares(graph.points, graph.m, graph.b);
    
    println("Square: " + squares + " Gradient: " + gradient);
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

  graph.m2 = m;
  graph.b2 = b;
}

float calculateSumOfSquares(ArrayList<PVector> points, float m, float b) {
  float sum = 0;
  
  for(PVector point : points) {
   sum += (point.y - (m * point.x + b)) * (point.y - (m * point.x + b)) ;
  }
  
  return sum;
}

void gradientDescent() {
  
  float learningRate = 0.03;
  
  for(PVector point : graph.points) {
    float guess = graph.yPoint(point.x);
    float error = (1f/2f) * (point.y - guess);
    
    graph.m += error * point.x * learningRate;
    graph.b += error * learningRate;
    
    graph.update();
  }
  
}

void mousePressed() { //When clicked add a point to the graph
  graph.addPoint(new PVector(mouseX, mouseY));
}