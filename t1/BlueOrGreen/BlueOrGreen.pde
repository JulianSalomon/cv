float w2, h2;
void setup() {
  size(610, 340, P2D);
  w2 = width/2;
  h2 = height/40.0f;
}

void draw() {
  background(255, 0, 255);
  noStroke();
  fill(107, 255, 255);
  rect(0, height/2, width/2, height/2);
  if (!mousePressed) {
    for (int i=0; i<40; i++) {
      if (i%2 == 0) {
        fill(255, 158, 0);
        rect(0, h2*i, w2, h2);
      } else {
        if (i < 20)
          fill(107, 255, 255);
        rect(w2, h2*i, width, h2);
      }
    }
  } else {
    rect(width/2, 0, width/2, height/2);
  }
}
