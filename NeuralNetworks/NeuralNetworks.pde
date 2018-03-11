NeuralNetwork nn = new NeuralNetwork(2, 10, 1);

float[] inputs = {0, 1};
float[] answers = {1};

float[][] training = {{0, 0, 0}, {1, 1, 0}, {0, 1, 1}, {1, 0, 1}};

void setup() {
  size(400, 400);
}

void draw() {
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
      float[] inputs = {training[value][0], training[value][1]};
      float[] outputs = {training[value][2]};
      nn.train(inputs, outputs);
    }
    break;
  }
}