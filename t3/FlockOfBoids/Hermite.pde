class Hermite extends Spliner {

  Hermite () {
    super();
  }

  Hermite(Spliner s) {
    super(s);
  }

  void draw() {
    if (points.size() < 2) {
      return;
    }
    beginShape();
    noFill();
    finiteDifference(points.size());
    endShape();
  }

  void finiteDifference(int n) {
    Vector[] P = new Vector[n];
    for (int i=0; i < n; i++) {
      P[i] = points.get(i).worldLocation(new Vector(0, 0, 0));
    }
    Vector C1, C2, C;
    for (int i=1; i < n; i++) {
      for (float t=0; t<1; t+=1/T) {     
        C1 =  Vector.add(Vector.multiply(P[i-1], h00(t)), Vector.multiply(m(P, i-1, t), h10(t)));
        C2 =  Vector.add(Vector.multiply(P[i], h01(t)), Vector.multiply(m(P, i, t), h11(t)));
        C = Vector.add(C1, C2);
        stroke(255, 255, 0);
        vertex(C.x(), C.y(), C.z());
      }
    }
  }

  Vector m(Vector[] P, int k, float t) {
    // Finite difference  
    if (k == 0)
      return Vector.multiply(Vector.subtract( P[k+1], P[k] ), 0.5 );
    if (k == P.length - 1)
      return Vector.multiply(Vector.subtract( P[k], P[k-1] ), 0.5 );
    Vector C1 = Vector.subtract( P[k + 1], P[k] );
    Vector C2 = Vector.subtract( P[k], P[k-1] );
    return Vector.multiply(Vector.add(C1, C2), 0.5);
  }

  float h00(float t) {
    return (1+2*t)*(1-t)*(1-t);
  }
  float h10(float t) {
    return t*(1-t)*(1-t);
  }
  float h01(float t) {
    return t*t*(3-2*t);
  }
  float h11(float t) {
    return -t*t*(1-t);
  }

  String toString() {
    return "Puntos de control: " + (points.size()-1);
  }
}
