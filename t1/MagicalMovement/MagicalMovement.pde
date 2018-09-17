PImage img;

void setup() {
  size(825, 638);
  img = loadImage("leopardo.jpg");
  img.resize(825, 638);
  image(img, 0, 0);
}

void draw() {
  image(img, 0, 0);
  if (!mousePressed) {
    for (int i=0; i<55; i++) {
      fill(0);
      rect(mouseX-width/2, 0, 10, height);
      translate(15, 0);
    }
  }
}

void keyPressed() {
  switch(key) {
  case '1':
    img = loadImage("leopardo.jpg");
    img.resize(825, 638);
    break;
  case '2':
    img = loadImage("esfera.jpg");
    img.resize(825, 638);
    break;
  case '3':
    img = loadImage("minecraft.jpg");
    img.resize(825, 638);
    break;
  case '4':
    img = loadImage("pacman.jpg");
    img.resize(825, 638);
    break;
  case '5':
    img = loadImage("ruedas.jpg");
    img.resize(825, 638);
    break;
  case '6':
    img = loadImage("ruleta.jpg");
    img.resize(825, 638);
    break;
  }
}
