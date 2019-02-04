abstract class Spliner2 {
  final double T = 40;
  ArrayList<Frame> points;

  Spliner2() {
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
    int aux = 1; 
    for(Frame F:points){
      if(aux==points.size())
        break;
      stroke(255,0,0);
      strokeWeight(10);
      Vector V = F.worldLocation(new Vector(0,0,0));
      point(V.x(), V.y(), V.z());
      ++aux;
    }
    popStyle();
  }
  
  void finiteDifference(int n){
    Vector[] P = new Vector[n];
    for(int i=0; i < n; i++){
      P[i] = points.get(i).worldLocation(new Vector(0,0,0));
    }
    Vector C1, C2, C;
    for(int i=1; i<n-1; i++){
      for(float t=0; t<1; t+=1/T){     
        C1 =  Vector.add(Vector.multiply(P[i-1],h00(t)), Vector.multiply(m(P, i, t),h10(t)));
        C2 =  Vector.add(Vector.multiply(P[i],h01(t)), Vector.multiply(m(P, i, t),h11(t)));
        C = Vector.add(C1, C2);
        stroke(255, 255, 0);
        vertex(C.x(), C.y(), C.z());
      }
    }
      
  }
  
  Vector m(Vector[] P, int k, float t){
    Vector C1 = Vector.subtract( P[k + 1],P[k] );
    Vector C2 = Vector.subtract( P[k],P[k-1] );
    return Vector.multiply(Vector.add(C1,C2), 0.5);
  }
  
  float h00(float t){
    return (1+2*t)*(1-t)*(1-t);
  }
  float h10(float t){
    return t*(1-t)*(1-t);
  }
  float h01(float t){
    return t*t*(3-2*t);
  }
  float h11(float t){
    return -t*t*(1-t);
  }
}
