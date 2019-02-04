abstract class Spliner {

  ArrayList<Frame> points;

  Spliner() {
    points = new ArrayList();
  }
  
  abstract void draw(); 

  void addPoint(Frame v) {
    points.add(v);
  }

  void clear() {
    if(points.size() > 0){
      points.clear();
    } 
  }
  
  void markControlPoints(){
    pushStyle();
    for(Frame F:points){
      stroke(255,0,0);
      strokeWeight(10);
      Vector V = F.worldLocation(new Vector(0,0,0));
      point(V.x(), V.y(), V.z());
    }
    popStyle();
  }
  
  void markCurve(){
    beginShape();
    noFill();
    for(Frame F:points){
      stroke(0,255,255);
      Vector V = F.worldLocation(new Vector(0,0,0));
      vertex(V.x(), V.y(), V.z());
    }
    endShape();
  }
  
  Vector casteljau(float t, int n){
    if(n==0){
      return null;
    }
    Vector[] P = new Vector[n];
    for(int i=0; i < n; i++){
      P[i] = points.get(i).worldLocation(new Vector(0,0,0));
    }
    for(int i = 1; i < n; i++){
      for(int j = 0; j < n - i; j++){
        P[j] =  Vector.add(Vector.multiply(P[j],(1-t)), Vector.multiply(P[j+1],(t)));
      }  
    }
    return P[0];
  }
}
