NeuralNetwork nn;

FileReader imageReader = new FileReader("train-images.idx3-ubyte");

int numberOfRows;
int numberOfCols;

int squareWidth;
int squareHeight;

FileReader labelReader = new FileReader("train-labels.idx1-ubyte");

void setup() {
  size(280, 280);

  readImageHeader();
  nn = new NeuralNetwork(numberOfRows * numberOfCols, 20, 10);
}

void printArray(float[] n) {
  println();
  for (int i = 0; i < n.length; i++) {
    print(n[i] +",");
  }
  println();
}

int guessNumber(int n) { //index of number in the data
  float[] imagePixels = new float[numberOfCols * numberOfRows];
  imageReader.setIndex(16 + ((n - 1) * (numberOfRows * numberOfCols)));
  int i = 0;

  for (int row = 0; row < numberOfRows; row++) {
    for (int col = 0; col < numberOfCols; col++) {
      imagePixels[i] = imageReader.readBytes(1);
    }
  }

  float[] data = nn.feedForward(imagePixels);

  int largest = 0;
  for (int j = 0; j < data.length; j++) {
    if (data[j] > data[largest]) {
      largest = j;
    }
  }

  return largest;
}

void draw() {
}

int imageLabel(int n) { //the label for image n
  labelReader.setIndex(8 + (n - 1));
  return labelReader.readBytes(1);
}

void keyPressed() {
 if(key == 's') {
  train(); 
 }
 if(key == 'a') {
   drawPicture(27);
   println(guessNumber(27));
 }
}

void readImageHeader() {
  imageReader.readBytes(4); //Magic Number
  imageReader.readBytes(4); //Number of pictures
  numberOfRows = imageReader.readBytes(4);
  numberOfCols = imageReader.readBytes(4);

  squareWidth = width / numberOfCols;
  squareHeight = height / numberOfRows;
}

void drawPicture(int n) {
  imageReader.setIndex(16 + ((n - 1) * (numberOfRows * numberOfCols)));

  for (int row = 0; row < numberOfRows; row++) {
    for (int col = 0; col < numberOfCols; col++) {
      fill(imageReader.readBytes(1));
      noStroke();
      rect(col * squareWidth, row * squareHeight, squareWidth, squareHeight);
    }
  }
}

void train() {
  for (int i = 0; i < 1000; i++) {
    int value = floor(random(0, 60001));

    float[] imagePixels = new float[numberOfCols * numberOfRows];
    imageReader.setIndex(16 + ((value - 1) * (numberOfRows * numberOfCols)));
    int i_ = 0;

    for (int row = 0; row < numberOfRows; row++) {
      for (int col = 0; col < numberOfCols; col++) {
        imagePixels[i_] = imageReader.readBytes(1);
      }
    }
    
    int output = imageLabel(value);
    float[] outputs = new float[10];
    
    for(int j = 0; j < outputs.length; j++) {
     outputs[j] = (j == output) ? 1 : 0; 
    }
    
    nn.train(imagePixels, outputs);
  }
  
  println("Done training");
}