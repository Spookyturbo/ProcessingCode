class Matrix {

  int rows, cols;

  public float[][] data;

  public Matrix(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;

    data = new float[rows][cols];
  }

  public static Matrix multiply(Matrix a, Matrix b, boolean scalar) {

    if (scalar) {
      
    } 
    else {
    }
    
    return new Matrix(3, 2);
  }
}