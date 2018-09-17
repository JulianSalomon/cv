PImage street, car;
float delta, streetWidth, streetHeight, 
  carWidth, carHeight;

void setup() {
  size(1000, 667);
  street = loadImage("street2.jpg");
  car = loadImage("car.png");
  streetWidth = width; 
  streetHeight = street.height * width / street.width;
  carWidth = width / 6;
  carHeight = car.width * height / width / 6;
}

void draw() {
  if (mousePressed) {
    delta += (delta < carHeight * 0.8) ? carHeight * 0.08 : 0;
  }

  image(street, 0, 0, streetWidth, streetHeight);
  translate(width / 10, streetHeight - carHeight);
  image(car, 0, 0, carWidth, carHeight);
  translate(carWidth, - carHeight * 0.8 + delta);
  image(car, 0, 0, carWidth, carHeight);
  translate(carWidth, - carHeight * 0.8 + delta);
  image(car, 0, 0, carWidth, carHeight);
}

void mouseReleased() {
  delta = 0;
}
