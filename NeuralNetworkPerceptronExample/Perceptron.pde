int sign(float n) {
  if (n > 0) {
    return 1;
  }

  return -1;
}

class Perceptron {

  float[] weights;
  float learningRate = 0.1;

  public Perceptron(int amountOfInputs) {
    weights = new float[amountOfInputs];

    for (int i = 0; i < weights.length; i++) {
      weights[i] = random(-1, 1);
    }
  }

  void train(float[] inputs, float correct) {
    float guess = guess(inputs);
    float error = correct - guess;
    for (int i = 0; i < weights.length; i++) {
      weights[i] += error * inputs[i];
    }
  }

  float f(float x) {
    return (((-x * weights[0]) / weights[1]) - (weights[2] / weights[1]));
  }

  float sumOfInputs(float[] inputs) {
    float sum = 0;

    for (int i = 0; i < inputs.length; i++) {
      sum += inputs[i] * weights[i];
    }

    return sum;
  }

  float activationFunction(float sum) {
    return sign(sum);
  }

  float guess(float[] inputs) {
    float sum = sumOfInputs(inputs);

    return activationFunction(sum);
  }
}