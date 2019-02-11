class Bezier extends Spliner {

  Bezier () {
    super();
  }

  Bezier(Spliner s) {
    super(s);
  }

  void draw() {
    if (points.size() < 2) {
      return;
    }
    beginShape();
    noFill();
    for (float t=0; t<1; t+=1/T) { 
      Vector aux = casteljau(t, points.size());
      stroke(255);
      vertex(aux.x(), aux.y(), aux.z());
    }     
    endShape();
  }

  Vector casteljau(float t, int n) {
    if (n==0) {
      return null;
    }
    Vector[] P = new Vector[n];
    for (int i=0; i < n; i++) {
      P[i] = points.get(i).position();
    }
    for (int i = 1; i < n; i++) {
      for (int j = 0; j < n - i; j++) {
        P[j] =  Vector.add(Vector.multiply(P[j], (1-t)), Vector.multiply(P[j+1], (t)));
      }
    }
    return P[0];
  }

  String toString() {
    return "Grado de la curva de Bezier: " + (points.size()-1);
  }
}
