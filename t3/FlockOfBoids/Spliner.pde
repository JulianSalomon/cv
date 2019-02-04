abstract class Spliner {
  // Number of lines to draw
  final float T = 40;
  // Control points
  ArrayList<Frame> points;

  Spliner() {
    points = new ArrayList();
  }

  Spliner(Spliner s) {
    points = s.points;
  }

  abstract void draw(); 
  abstract String toString();

  void addPoint(Frame v) {
    points.add(v);
  }

  void clear() {
    if (points.size() > 0) {
      points.clear();
    }
  }

  void markControlPoints() {
    pushStyle();
    for (Frame F : points) {
      stroke(255, 0, 0);
      strokeWeight(10);
      Vector V = F.worldLocation(new Vector(0, 0, 0));
      point(V.x(), V.y(), V.z());
    }
    popStyle();
  }

  void markCurve() {
    beginShape();
    noFill();
    for (Frame F : points) {
      stroke(0, 255, 255);
      Vector V = F.worldLocation(new Vector(0, 0, 0));
      vertex(V.x(), V.y(), V.z());
    }
    endShape();
  }
}
