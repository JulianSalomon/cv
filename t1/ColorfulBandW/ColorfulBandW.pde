PImage img;
PImage original;
int INITIAL_TIME;

void setup() {
  img = loadImage("img.jpg");
  size(1000, 598, P2D);
  background(0);
  noStroke();
  fill(255);
  textSize(28);
  String s = "1) Stare at the pink point in the negative image.\n" +
    "2) Then we are going to show you the black and white image.";
  text(s, 20, (img.height/2)-70, img.width, 500);
  INITIAL_TIME = millis();
}

void draw() {
  int actual = (millis()-INITIAL_TIME) / 1000;
  switch (actual) {
  case 5:
    printNegativeImage();
    break;
  case 20:
    printGrayImage();
    break;
  case 30:
    printFinalMessage();
    break;
  case 34:
    printFinalFinalMessage();
    break;
  case 40:
    printNegativeImage();
    break;
  case 50:
    printWhiteScreen();
    break;
  case 55:
    printFinalFinalFinalMessage();
    break;
  }
}

void printNegativeImage() {
  PImage negative = img.copy();
  float r, g, b;
  color c;
  for (int i = 0; i < negative.pixels.length; i++) {
    c = negative.pixels[i];
    r = 255 - red(c);
    g = 255 - green(c);
    b = 255 - blue(c);
    negative.pixels[i] = color(r, g, b);
  }
  image(negative, 0, 0);
  fill(255, 192, 203);
  ellipse(negative.width / 2, negative.height / 2, 15, 15);
}

void printGrayImage() {
  PImage gray = img.copy();
  color c;
  colorMode(HSB);
  for (int i = 0; i < gray.pixels.length; i++) {
    c = gray.pixels[i];
    gray.pixels[i] = color(0, 0, brightness(c));
  }
  colorMode(RGB);
  image(gray, 0, 0);
}

void printFinalMessage() {
  String s = "You saw colors, didn't you?";
  fill(255);
  textSize(28);
  background(0);
  text(s, 20, (img.height/2)-70, img.width, 500);
}

void printFinalFinalMessage(){
  String s = "1) Now again stare at the pink point in the negative image.\n" +
    "2) Then we are going to show you a white screen.\n"+
    "3) And finally don't stop blinking.\n";
  fill(255);
  textSize(28);
  background(0);
  text(s, 20, (img.height/2)-70, img.width, 500);
}

void printWhiteScreen(){
  background(255);
}

void printFinalFinalFinalMessage(){
  String s = "It's harder to see the original image again.\n But it still works, amazing!";
  fill(255);
  textSize(28);
  background(0);
  text(s, 20, (img.height/2)-70, img.width, 500);
}
