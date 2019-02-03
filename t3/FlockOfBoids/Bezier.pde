class Bezier extends Spliner {
  final double T = 40;
  
  Bezier () {
    super();
  }

  void draw() {
    if(points.size() == 0){
      return;
    }
    beginShape();
    noFill();
    for(float t=0; t<1; t+=1/T){ 
       Vector aux = casteljau(t, points.size());
       stroke(255);
       vertex(aux.x(), aux.y(), aux.z());
       /*println(aux);*/
     }     
     endShape();
  }
}
