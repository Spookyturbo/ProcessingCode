NeuralNetwork nn = new NeuralNetwork(2, 10, 1);

float[] inputs = {0, 1};
float[] answers = {1};

float[][] training = {{0, 0, 0}, {1, 1, 0}, {0, 1, 1}, {1, 0, 1}};

XOR xor = new XOR(4, 10);

void setup() {
  size(600, 600);
  
}

void draw() {
  xor.display();
}

void keyPressed() {
  float[] guesses;
  switch(key) {
  case 'q':
    guesses = xor.guess(new float[] {0, 0});
    println(guesses[0]);
    break;
  case 'z':
    guesses = xor.guess(new float[] {0, 1});
    println(guesses[0]);
    break;
  case 'e':
    guesses = xor.guess(new float[] {1, 0});
    println(guesses[0]);
    break;
  case 'c':
    guesses = xor.guess(new float[] {1, 1});
    println(guesses[0]);
    break;
  case 's':
    xor.train();
    break;
  case 'v':
    xor.display();
      break;
  }
}