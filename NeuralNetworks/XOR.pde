class XOR {

  NeuralNetwork nn;

  float[][] trainingData = {{0, 0, 0}, {1, 1, 0}, {0, 1, 1}, {1, 0, 1}};
  int squareSize;

  public XOR(int numberOfHidden, int squareSize) {
    nn = new NeuralNetwork(2, numberOfHidden, 1);
    this.squareSize = squareSize;
  }

  public float[] guess(float[] inputs) {
    return nn.feedForward(inputs);
  }

  public void train() {
    for (int i = 0; i < 50000; i++) {
      int value = floor(random(trainingData.length));
      float[] inputs = {trainingData[value][0], trainingData[value][1]};
      float[] outputs = {trainingData[value][2]};

      nn.train(inputs, outputs);
    }
  }

  public void display() {

    int rows = width / squareSize;
    int cols = height / squareSize;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        float[] guesses = guess( new float[] {map(i, 0, rows, 0, 1), map(j, 0, cols, 0, 1)});
        noStroke();
        fill(map(guesses[0], 0, 1, 0, 255));
        
        rect(i * squareSize, j * squareSize, squareSize, squareSize);
      }
    }
  }
}