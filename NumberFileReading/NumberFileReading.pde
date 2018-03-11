FileReader reader;
FileReader labelReader;

int number = 1;

void setup() {

  reader = new FileReader("train-images.idx3-ubyte");
  labelReader = new FileReader("train-labels.idx1-ubyte");
  size(280, 280);
  readHeader();
}

void draw() {
  
  drawNumber(number);
  
  number++;
  delay(1000);
}

int magicNumber;
int numberOfImages;
int numberOfRows;
int numberOfCols;

int squareWidth;
int squareHeight;

int labelFor(int n) { //label for nth number in file
  labelReader.setIndex(8 + (n - 1));
  return labelReader.readBytes(1);
}

void readHeader() {

  magicNumber = reader.readBytes(4);
  numberOfImages = reader.readBytes(4);
  numberOfRows = reader.readBytes(4);
  numberOfCols = reader.readBytes(4);

  println(magicNumber + " " + numberOfImages + " " + numberOfRows + " " + numberOfCols);

  squareWidth = width / numberOfCols;
  squareHeight = height / numberOfRows;
}

void drawNumber(int n) { //draws the nth number in the file
  reader.setIndex(16 + ((n - 1) * (numberOfRows * numberOfCols)));

  for (int row = 0; row < numberOfRows; row++) {
    for (int col = 0; col < numberOfCols; col++) {
      fill(reader.readBytes(1));
      noStroke();
      rect(col * squareWidth, row * squareHeight, squareWidth, squareHeight);
    }
  }
  println(labelFor(number));
}

void drawNextNumber() {
  for (int row = 0; row < numberOfRows; row++) {
    for (int col = 0; col < numberOfCols; col++) {
      fill(reader.readBytes(1));
      noStroke();
      rect(col * squareWidth, row * squareHeight, squareWidth, squareHeight);
    }
  }
}