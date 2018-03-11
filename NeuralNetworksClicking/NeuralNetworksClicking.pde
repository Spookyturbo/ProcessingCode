NeuralNetwork nn = new NeuralNetwork(2, 1000, 2);

void setup() {
  size(400, 400);
}

void draw() {
}

void mousePressed() {
  background(51);
 noStroke();
 fill(255, 0, 0);
 ellipse(mouseX, mouseY, 10, 10);
 float[] guesses = nn.feedForward(new float[] {map(mouseX, 0, width, 0, 1), map(mouseY, 0, height, 0, 1)});
 fill(0, 255, 0);
 ellipse(map(guesses[0], 0, 1, 0, width), map(guesses[1], 0, 1, 0, height), 10, 10);
}

void keyPressed() {
  float[] guesses;
  switch(key) {
  case 'q':
    guesses = nn.feedForward(new float[] {0, 0});
    println(guesses[0]);
    break;
  case 'z':
    guesses = nn.feedForward(new float[] {0, 1});
    println(guesses[0]);
    break;
  case 'e':
    guesses = nn.feedForward(new float[] {1, 0});
    println(guesses[0]);
    break;
  case 'c':
    guesses = nn.feedForward(new float[] {1, 1});
    println(guesses[0]);
    break;
  case 's':
    for (int i = 0; i < 50000; i++) {
      int value = floor(random(4));
      float xRandom = random(1);
      float yRandom = random(1);
      float[] inputs = {xRandom, yRandom};
      float[] outputs = {xRandom, yRandom};
      nn.train(inputs, outputs);
    }
    break;
  }
}

void trainFullScreen() {
 for(int x = 0; x < width; x++) {
   for(int y = 0; y < height; y++) {
     float[] inputs = {map(x, 0, width, 0, 1), map(y, 0, height, 0, 1)};
     float[] outputs = inputs;
     
     nn.train(inputs, outputs);
   }
 }
}