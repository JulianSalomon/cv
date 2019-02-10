import papaya.*;

class Cubic extends Spliner {

  int n;
  Vector[] result;
  float[][] tridiagonal;

  Cubic() {
    super();
  }

  Cubic(Spliner s) {
    super(s);
  }

  void draw() {
    n = points.size();
    if (n < 2) {
      return;
    }
    noFill();
    beginShape();
    solutionMatrix();
    for (float t=0; t < n - 1; t+=1/T) {
      Vector point = Y(t); 
      stroke(255);
      vertex(point.x(), point.y(), point.z());
    }
    endShape();
  }

  Vector Y(float t) {
    int i = floor(t);
    t = t - i;

    Vector yi = points.get(i).position(), 
      yi1 = points.get(i+1).position(), 
      Di = result[i], 
      Di1 = result[i + 1];

    Vector a = yi, 
      b = Di, 
      c = Vector.subtract(Vector.subtract(
      Vector.multiply(Vector.subtract(yi1, yi), 3), 
      Vector.multiply(Di, 2)
      ), Di1), 
      d = Vector.add(Vector.add(
      Vector.multiply(Vector.subtract(yi, yi1), 2), 
      Di), Di1);

    return Vector.add(
      Vector.add(a, Vector.multiply(b, t)), 
      Vector.add(Vector.multiply(c, t * t), Vector.multiply(d, t * t * t)));
  }

  Vector[] solutionMatrix() {
    float[][] resultRows = new float[n][3];
    for (int i = 0; i < n; i++) {
      int first = i - 1, second = i + 1;
      if (i == 0) 
        first = i;
      if (i == n - 1)
        second = i;
      Vector v1 = points.get(first).position(), 
        v2 = points.get(second).position();
      resultRows[i] = Vector.multiply(Vector.subtract(v2, v1), 3)._vector;
    }

    tridiagonal = tridiagonalMatrix();

    QR qr = new QR(tridiagonal);

    final float[][] x = Cast.doubleToFloat(qr.solve(resultRows));
    result = new Vector[n];
    for (int i = 0; i < n; i++) {
      final int _i = i;
      result[i] = new Vector() {{
          set(x[_i]);
      }};
    }
    return result;
  }

  float[][] tridiagonalMatrix() {
    if (tridiagonal != null && tridiagonal.length == n)
      return tridiagonal;

    float[][] matrix = new float[n][n];
    for (int i = 0; i < n; i++) {
      if (i - 1 >= 0)
        matrix[i][i - 1] = 1;
      if (i + 1 < n)
        matrix[i][i + 1] = 1;
      matrix[i][i] = 4;
    }
    matrix[0][0] = 2;
    matrix[n - 1][n - 1] = 2;
    return matrix;
  }

  String toString() {
    return "Grado de la curva cúbica natural: " + (points.size()-1);
  }
}
