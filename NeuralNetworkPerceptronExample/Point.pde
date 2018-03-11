class Point {

  float x;
  float y;
  float b;

  float output;

  public Point() {

    this.x = random(-1, 1);
    this.y = random(-1, 1);
    b = 1;

    setOutput();
  }

  public Point(float x, float y) {
    this.x = x;
    this.y = y;
    b = 1;

    setOutput();
  }

  float pixelX() {
    return map(x, -1, 1, 0, width);
  }
  
  float pixelY() {
    return map(y, -1, 1, height, 0);
  }

  void setOutput() {
    if (y > f(x)) {
      output = 1;
    } else {
      output = -1;
    }
  }
  
  public void drawPoint(int dotColor) {
   float x = map(this.x, -1, 1, 0, width);
   float y = map(this.y, -1, 1, height, 0);
   
   noStroke();
   fill(dotColor);
   
   ellipse(x, y, 10, 10);
  }
}