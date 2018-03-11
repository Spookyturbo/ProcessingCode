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

public class LinearRegression extends PApplet {

Graph graph = new Graph(480, 480);

public void setup() { //The canvas is mapped from 0, 1 in both the x and y directions for the purpose of the slope
  
}

public void draw() {
  graph.update();
  if (graph.points.size() > 1) {
    linearRegression();
  }
}

public void linearRegression() {
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

public void mousePressed() { //When clicked add a point to the graph
  graph.addPoint(new PVector(mouseX, mouseY));
}
class Graph {

  public ArrayList<PVector> points = new ArrayList<PVector>();

  int screenWidth = 0;
  int screenHeight = 0;

  public float m = 0;
  public float b = 0;

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

  public void drawLine() { //Draw the line of best fit
    float p1 = yPoint(0);
    float p2 = yPoint(1);
    stroke(255, 0, 0);
    line(0, map(p1, 0, 1, height, 0), map(1, 0, 1, 0, width), map(p2, 0, 1, height, 0));
  }

  public float yPoint(float x) { //for point x get point y
    return m * x + b;
  }

  public void drawPoints() { //redraw all points placed on canvas
    fill(255, 0, 0);
    stroke(255, 0, 0);
    for (PVector point : points) {
      ellipse(map(point.x, 0, 1, 0, width), map(point.y, 0, 1, height, 0), 10, 10);
    }
  }
}
  public void settings() {  size(480, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "LinearRegression" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
