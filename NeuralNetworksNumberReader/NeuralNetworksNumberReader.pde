NeuralNetwork nn;

FileReader imageReader = new FileReader("train-images.idx3-ubyte");

int numberOfImages = 2000;

int numberOfRows;
int numberOfCols;

int squareWidth;
int squareHeight;

float[][] images;
float[][] labels;

byte[] fileInfo = new byte[(28 * 28 * 60000) + 16]; 

  FileReader labelReader = new FileReader("train-labels.idx1-ubyte");

void setup() {
  size(280, 280);

  readImageHeader();
  images = new float[numberOfImages][numberOfRows * numberOfCols];
  labels = new float[numberOfImages][10];
  fileInfo = imageReader.readFile();
  println("done");
  initImageArray();
  initLabelArray();
  println("arrays done");
  drawPicture(images[3]);
  println(labels[3]);
  nn = new NeuralNetwork(numberOfRows * numberOfCols, 20, 10);
  println("Ready for input");
  println(fileInfo[2]);
}

void draw() {
}

void keyPressed() {
  if (key == 's') {
    train();
  }
  if (key == 'a') {
    drawPicture(images[0]);
    println(guessNumber(1));
  }
}

void initImageArray() {
  for (int i = 0; i < numberOfImages; i++) {
    int index = 16 + ((i) * (numberOfRows * numberOfCols));
    int j = 0;
    println(i);
    for (int row = 0; row < numberOfRows; row++) {
      for (int col = 0; col < numberOfCols; col++) {
        images[i][j] = (fileInfo[index + j] & 0xFF);
        j++;
      }
    }
  }
}

void initLabelArray() {
  for (int i = 0; i < numberOfImages; i++) {
    labelReader.setIndex(8 + (i));
    int output = labelReader.readBytes(1);

    for (int j = 0; j < labels[i].length; j++) {
      labels[i][j] = (j == output) ? 1 : 0;
    }
  }
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

int imageLabel(int n) { //the label for image n
  labelReader.setIndex(8 + (n - 1));
  return labelReader.readBytes(1);
}

void readImageHeader() {
  imageReader.setIndex(0);
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

void drawPicture(float[] pixelValues) {
  int j = 0;
  for (int row = 0; row < numberOfRows; row++) {
    for (int col = 0; col < numberOfCols; col++) {
      fill(pixelValues[j]);
      noStroke();
      rect(col * squareWidth, row * squareHeight, squareWidth, squareHeight);
      j++;
    }
  }
}

void train() {
  for (int i = 0; i < 10000; i++) {
    int value = floor(random(numberOfImages));

    nn.train(images[value], labels[value]);
  }

  println("Done training");
}