Snake snake;

NeuralNetwork nn = new NeuralNetwork(5, 2000, 1); //inputs: object to the left, object ahead, object to the right, suggested direction

void setup() {
  size(400, 400);
  snake = new Snake(10);
  background(51);
  snake.beginGame();
  //trainOnWalls();
  println("Done training");
}

int delayValue = 0;

void draw() {
  println(snake.score);
  training();
  delay(delayValue);
  //println(angleToApple());
}

//float angleToApple() {
//  PVector snakePosition = snake.currentPosition.copy();
//  PVector apple = snake.apple.copy();
//  PVector appleToSnakeVector = new PVector(snakePosition.x - apple.x, snakePosition.y - apple.y);

//  float dot = appleToSnakeVector.dot(new PVector(0, -1));
//  float angle = (float)Math.toDegrees(Math.acos(dot / appleToSnakeVector.mag()));

//  PVector direction = snake.direction.copy();
//  float angleOfDirection = (float)Math.toDegrees(Math.acos(direction.dot(new PVector(0, 1))));
//  if (direction.x < 0 || direction.y < 0) {
//    angleOfDirection *= -1; 
//    if (angleOfDirection == -180) {
//      angleOfDirection *= -1;
//    }
//  }

//  if (appleToSnakeVector.x > 0) {
//    angle *= -1;
//  }
//  return  (angleOfDirection /180) - (angle / 180);
//}

float angleToApple() {
  PVector snakePosition = snakePosition = snake.currentPosition.copy();
  PVector apple = snake.apple.copy();


  PVector appleToSnakeVector = new PVector(snakePosition.x - apple.x, snakePosition.y - apple.y);
  PVector direction = snake.direction.copy();
  float dot = appleToSnakeVector.dot(direction);
  float angle = (float)Math.toDegrees(Math.acos(dot / appleToSnakeVector.mag()));

  if (direction.x == 0 && direction.y == 1) { //up
    if (snakePosition.x < apple.x) {
      //angle -= 180;
      angle *= -1;
    }
  } else if (direction.x == 1 && direction.y == 0) { //right
    if (snakePosition.y > apple.y) {
      //angle -= 180;
      angle *= -1;
    }
  } else if (direction.x == -1 && direction.y == 0) { //left
    if (snakePosition.y < apple.y) {
      //angle -= 180;
      angle *= -1;
    }
  } else if (direction.x == 0 && direction.y == -1) { //down
    if (snakePosition.x > apple.x) {
      //angle -= 180;
      angle *= -1;
    }
  }

  return  angle / 180;
}

void trainOnWalls() {
  for (int j = 0; j < 100000; j++) {
    for (int i = -1; i < 2; i++) {
      float[] inputs = new float[5];
      inputs[0] = floor(random(2));
      inputs[1] = floor(random(2));
      inputs[2] = floor(random(2));
      PVector snakePosition = new PVector(floor(random(snake.dimensions.x)), floor(random(snake.dimensions.y)));
      PVector apple;
      do {
      apple = new PVector(floor(random(snake.dimensions.x)), floor(random(snake.dimensions.y)));
      } while(apple.x == snakePosition.x && apple.y == snakePosition.y);
      PVector direction;
      int value = floor(random(4));
      if (value == 0) {
        direction = new PVector(0, 1);
      } else if (value == 1) {
        direction = new PVector(1, 0);
      } else if (value == 2) {
        direction = new PVector(-1, 0);
      } else {
        direction = new PVector(0, -1);
      }
      inputs[3] = getAngle(apple, snakePosition, direction);
      inputs[4] = i;

      float distanceToApple = getDistance(apple, snakePosition);
      float newDistanceToApple = 0;
      if (i == -1) {
        newDistanceToApple = getDistance(apple, snake.simulateLeft(snakePosition, direction));
      } else if (i == 0) {
        newDistanceToApple = getDistance(apple, snake.simulateForward(snakePosition, direction));
      } else if (i == 1) {
        newDistanceToApple = getDistance(apple, snake.simulateRight(snakePosition, direction));
      }
      float[] answers = new float[1];
      if (inputs[i + 1] == 1) {
        answers[0] = -1;
      } else if (newDistanceToApple > distanceToApple) {
        answers[0] = 0;
      } else {
        answers[0] = 1;
      }
      nn.train(inputs, answers);
    }
  }
}

float getDistance(PVector one, PVector two) {
  float a = one.x - two.x;
  float b = one.y - two.y;
  a *= a;
  b *= b;

  return (float)Math.sqrt(a + b);
}

float getAngle(PVector one, PVector two, PVector direction) { //two == snake one == apple

  PVector appleToSnakeVector = new PVector(two.x - one.x, two.y - one.y);

  float dot = appleToSnakeVector.dot(direction);
  float angle = (float)Math.toDegrees(Math.acos(dot / appleToSnakeVector.mag()));

  if (direction.x == 0 && direction.y == 1) { //up
    if (two.x < one.x) {
      //angle -= 180;
      angle *= -1;
    }
  } else if (direction.x == 1 && direction.y == 0) { //right
    if (two.y > one.y) {
      //angle -= 180;
      angle *= -1;
    }
  } else if (direction.x == -1 && direction.y == 0) { //left
    if (two.y < one.y) {
      //angle -= 180;
      angle *= -1;
    }
  } else if (direction.x == 0 && direction.y == -1) { //down
    if (two.x > one.x) {
      //angle -= 180;
      angle *= -1;
    }
  }

  return  angle / 180;
}

void training() {
  float[] options = new float[3];
  for (int i = -1; i < 2; i++) {

    float[] objects = snake.surrounding();
    float[] inputs = new float[5];
    inputs[0] = objects[0];
    inputs[1] = objects[1];
    inputs[2] = objects[2];
    inputs[3] = angleToApple();
    inputs[4] = i;

    //inputs[3] = i;
    float distanceToApple = snake.distanceToApple(snake.currentPosition);
    float newDistanceToApple = 0;
    if (i == -1) {
      newDistanceToApple = snake.distanceToApple(snake.simulateLeft());
    } else if (i == 0) {
      newDistanceToApple = snake.distanceToApple(snake.simulateForward());
    } else if (i == 1) {
      newDistanceToApple = snake.distanceToApple(snake.simulateRight());
    }
    float[] answers = new float[1];
    if (inputs[i + 1] == 1) {
      answers[0] = -1;
    } else if (newDistanceToApple > distanceToApple) {
      answers[0] = 0;
    } else {
      answers[0] = 1;
    }
    nn.train(inputs, answers);
    //nn.train(inputs, new float[] {(inputs[i + 1] == 1) ? 0 : 1});
    options[i + 1] = nn.feedForward(inputs)[0];
  }
  int largest = 0;
  for (int i = 0; i < options.length; i++) {
    if (options[i] > options[largest]) {
      largest = i;
    }
  }

  if (largest == 0) {
    snake.turnLeft();
  } else if (largest == 1) {
    snake.moveForward();
  } else if (largest == 2) {
    snake.turnRight();
  }
}

void playing() {
  for (int i = -1; i < 2; i++) {
    float[] objects = snake.surrounding();
    float[] inputs = new float[4];
    inputs[0] = objects[0];
    inputs[1] = objects[1];
    inputs[2] = objects[2];
    inputs[3] = i;

    float prediction[] = nn.feedForward(inputs);
    if (prediction[0] >= 0.7) {
      if (i == -1) {
        snake.turnLeft();
      } else if (i == 0) {
        snake.moveForward();
      } else if (i == 1) {
        snake.turnRight();
      }

      break;
    }
  }
}

void keyPressed() {
  if (key == 'a') {
    if (delayValue >= 10) {
      delayValue -= 10;
    }
  } else if (key == 'd') {
    delayValue += 10;
  }
}