public float f(float x) { //This is the slope of the desired line
  return 2 * x + 1;
}

Point[] points = new Point[100];

Perceptron perceptron = new Perceptron(3);

void setup() {
  background(51);
  size(400, 400);
  for (int i = 0; i < points.length; i++) {
    points[i] = new Point(); 
    points[i].drawPoint(0xFFFF0000);
  }
    drawPerceptronLine();
  drawLine();
}

void draw() {
    background(51);
        drawPerceptronLine();
  for (int i = 0; i < points.length; i++) {
    float[] inputs = {points[i].x, points[i].y, points[i].b};
    float guess = perceptron.guess(inputs);
    if (points[i].output == guess) {
      points[i].drawPoint(0xFF00FF00);
    }
    else {
      points[i].drawPoint(0xFFFF0000);
    }
  }
      drawPerceptronLine();
      drawLine();
     // mousePressed();
      delay(100);
}

void mousePressed() {
  for (int i = 0; i < points.length; i++) {
    float[] inputs = {points[i].x, points[i].y, points[i].b};
    perceptron.train(inputs, points[i].output);
  }
}

void drawPerceptronLine() {
  Point startPoint = new Point(-1, perceptron.f(-1));
  Point endPoint = new Point(1, perceptron.f(1));

  line(startPoint.pixelX(), startPoint.pixelY(), endPoint.pixelX(), endPoint.pixelY());
}

void drawLine() {
  stroke(255);
  fill(255);
  Point startPoint = new Point(-1, f(-1));
  Point endPoint = new Point(1, f(1));
  line(startPoint.pixelX(), startPoint.pixelY(), endPoint.pixelX(), endPoint.pixelY());
}