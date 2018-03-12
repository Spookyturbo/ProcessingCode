NeuralNetwork nn;

FileReader imageReader = new FileReader("train-images.idx3-ubyte");

int numberOfImages = 60000;

int numberOfRows;
int numberOfCols;

int squareWidth;
int squareHeight;

float[][] images;
float[][] labels;

int[] fileInfo = new int[(28 * 28 * 60000) + 16]; 

FileReader labelReader = new FileReader("train-labels.idx1-ubyte");

void setup() {
  size(280, 280);

  readImageHeader(); //Read the initial header

  images = new float[numberOfImages][numberOfRows * numberOfCols]; //create arrays for storing the inputs and outputs
  labels = new float[numberOfImages][10];

  fileInfo = imageReader.fileInfo; //Store the file in an array to prevent opening inputStreams often

  initImageArray(); //Fill the arrays from the fileInfo
  initLabelArray();

  //Draw the first picture and initialize the neural network
  nn = new NeuralNetwork(784, 64, 10);
}

int numberIndex = 0;
int delay = 0;

boolean show = true;

int largestInLabel(int n) {

  int largest = 0;
  for (int i = 0; i < labels[n].length; i++) {
    if (labels[n][i] > labels[n][largest]) {
      largest = i;
    }
  }

  return largest;
}

float totalCorrect = 0;
float total = 0;
float trainIndex = 0;

void draw() {
  nn.train(images[(int)trainIndex], labels[(int)trainIndex]);

  float prediction = guessNumber((int)trainIndex);

  if (prediction == largestInLabel((int)trainIndex)) {
    totalCorrect++;
  }
  trainIndex++;

  float percent = 100 * (totalCorrect / trainIndex);
  println(percent);

  if (trainIndex == images.length) {
    trainIndex = 0;
    totalCorrect = 0;
    println("Done: " + percent);
  }
}
int[] numbers = {1, 3, 5, 7, 2, 0, 13, 15, 17, 4};
void fakeInitImageArray() {

  for (int i = 0; i < numberOfImages; i++) {

    images[i] = getImage(numbers[i]) ;
  }
}

float[] getImage(int n) {
  imageReader.setIndex(16 + ((n) * (numberOfRows * numberOfCols)));
  float[] picture = new float[numberOfRows * numberOfCols];

  int i = 0;
  for (int row = 0; row < numberOfRows; row++) {
    for (int col = 0; col < numberOfCols; col++) {
      picture[i] = (imageReader.readBytes(1) & 0xFF) / 255f;
      i++;
    }
  }

  return picture;
}

void fakeInitLabelArray() {
  for (int i = 0; i < numberOfImages; i++) {
    labelReader.setIndex(8 + numbers[i]);
    int output = labelReader.readBytes(1);

    for (int j = 0; j < labels[i].length; j++) {
      labels[i][j] = (j == output) ? 1 : 0;
    }
  }
}

void keyPressed() {
  //if (key != 's') {
  //  drawPicture(numbers[Character.getNumericValue(key)]);
  //  println(guessNumber(numbers[Character.getNumericValue(key)]));
  //} else if (key == 's') {
  //  train();
  //}
  //if (key == 'a') {
  //  drawPicture(2);
  //  println(guessNumber(2));
  //}

  if (key == 'a') {
    delay = 1000;
  } else if (key == 'd') {
    delay = 0;
  }

  if (key == 'w') {
    show = true;
  } else if (key == 's') {
    show = false;
  }
}

void initImageArray() {
  for (int i = 0; i < numberOfImages; i++) {
    int index = 16 + ((i) * (numberOfRows * numberOfCols));
    int j = 0;

    for (int row = 0; row < numberOfRows; row++) {
      for (int col = 0; col < numberOfCols; col++) {
        images[i][j] = (fileInfo[index + j] & 0xFF) / 255f;
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

int guessNumber(int n) { //index of number in the data, starts at 0

  float[] data = nn.feedForward(images[n]);

  int largest = 0;
  for (int j = 0; j < data.length; j++) {
    if (data[j] > data[largest]) {
      largest = j;
    }
  }

  return largest;
}

int imageLabel(int n) { //the label for image n, starts at 0
  labelReader.setIndex(8 + (n));
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

void drawPicture(int n, boolean correct) { //starts at index 0
  imageReader.setIndex(16 + ((n) * (numberOfRows * numberOfCols)));

  for (int row = 0; row < numberOfRows; row++) {
    for (int col = 0; col < numberOfCols; col++) {
      fill(imageReader.readBytes(1));
      noStroke();
      rect(col * squareWidth, row * squareHeight, squareWidth, squareHeight);
    }
  }

  if (correct) {
    fill(0, 255, 0);
    rect(0, 0, 50, 50);
  }
}

void drawPicture(float[] pixelValues) {
  int j = 0;
  for (int row = 0; row < numberOfRows; row++) {
    for (int col = 0; col < numberOfCols; col++) {
      fill(pixelValues[j] * 255);
      noStroke();
      rect(col * squareWidth, row * squareHeight, squareWidth, squareHeight);
      j++;
    }
  }
}

void train() {
  int[] order = new int[numberOfImages];

  for (int i = 0; i < order.length; i++) {
    order[i] = i;
  }

  for (int i = 0; i < numberOfImages * 2; i++) {
    int index1 = floor(random(numberOfImages));
    int index2 = floor(random(numberOfImages));

    int tmp = order[index1];
    order[index1] = order[index2];
    order[index2] = tmp;
  }

  float[][] inputs = new float[numberOfImages][images[0].length];
  float[][] answers = new float[numberOfImages][labels[0].length];
  for (int i = 0; i < numberOfImages; i++) {
    nn.train(images[order[i]], labels[order[i]]);
  }
  //for (int i = 0; i < numberOfImages; i++) {
  //  inputs[i] = images[order[i]];
  //  answers[i] = labels[order[i]];
  //}
  //nn.train(inputs, answers);
  println("Done training");
}