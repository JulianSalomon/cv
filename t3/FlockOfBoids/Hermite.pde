class Hermite extends Spliner2 {
  
  Hermite () {
    super();
  }

  void draw() {
     if(points.size() == 0){
       return;
     }
     beginShape();
     noFill();
     finiteDifference(points.size());
     /*println(aux);*/   
     endShape();
  }
}
