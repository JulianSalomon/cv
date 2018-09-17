int N=15, MAX=1;
color c;

void setup() {
  size(800, 800, P2D);
  strokeCap(PROJECT);
  colorMode(HSB, 100);
  c = color(15.8333333, 80, 80);
}

void draw() {
  background(c);
  translate(20, 20);
  scale((width-40f)/(10+(N-1)*20));

  for (int i=0; i<N; i++) {
    pushMatrix();
    int con = i, 
      aux = (int) Math.ceil((double) i / MAX);
    for (int j=0; j<N; j++, con++) {
      if (con % MAX == 0) {
        aux++;
      }
      fill(squareColor());
      rect(0, 0, 10, 10);
      if (!mousePressed) {
        pushMatrix();
        translate(5, 5);
        rotate(aux % 4 * PI/2);
        translate(-5, -5);
        stroke(0, 0, 100);
        line(0, 0, 0, 10);
        line(0, 0, 10, 0);
        popMatrix();
        stroke(0);
      } else {
        stroke(squareColor());
      }
      translate(20, 0);
    }  
    popMatrix();
    translate(0, 20);
  }
}

void keyPressed() {
  switch(key) {
  case '+':
    N++;
    break;
  case '-':
    N -= (N > 2) ? 1 : 0;
    break;
  case '>':
    MAX++;
    break;
  case '<':
    MAX -= (MAX > 1) ? 1 : 0;
    break;
  case 'c' | 'C':
    c = color((hue(c) + 1) % 100, saturation(c), brightness(c));
  }
}

void mouseDragged() {
  float inc =  100f*(mouseX-pmouseX)/width % 100;
  c = color((hue(c) + inc), saturation(c), brightness(c));
}

color squareColor() {
  return color((hue(c) + 48.3333334) % 100, saturation(c), brightness(c));
}
