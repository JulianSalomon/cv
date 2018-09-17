/* 
 * Model and animation author: Jayanam
 * https://www.youtube.com/channel/UCs5J4GVRB8s2P4hE-O0izrg
 * Retrieved from: https://www.patreon.com/posts/blender-to-godot-16980501
 */

final int ANIM_FRAMES = 20;
PGraphics pgInfo;
PShape[] myChar;
int nShapes, rotSpeed;
float radianStep, radius, angle, limitW, limitH;
boolean drawShape = false;

void settings() {
  size(1000, 600, P3D);
  initialConfig();
}

void setup() {
  frameRate(60);
  noStroke();
  colorMode(HSB, 100);
  pgInfo = createGraphics(150, 40);
  loadShapes();
}

void draw() {
  background(0);
  lights();  
  pushMatrix();
  translate(width/2, 7*height/11);
  rotateY(angle * PI);
  rotateX(PI/2);
  // Draw gray plate
  fill(0, 0, 100);
  ellipse(0, 0, limitW, limitW);
  drawShapes();
  popMatrix();  
  angle = (angle + 0.001 * rotSpeed) % 2;
  drawInfo();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  rotSpeed += Math.signum(e);
}

void keyPressed() {
  switch (key) {
  case '+':
    increaseNShapes(1);
    break;
  case '-':
    increaseNShapes(-1);
    break;
  case 'r' | 'R':
    initialConfig();
    break;
  case 'e' |'E':
    changeMode();
    break;
  }
}

void increaseNShapes(int n) {
  if (n > 0 && (nShapes < ANIM_FRAMES || ! drawShape)) {
    nShapes++;
  } else if (n < 0 && nShapes > 0) {
    nShapes--;
  }
  loadShapes();
  radianStep = 2 * PI / nShapes;
}

void changeMode() {
  drawShape = !drawShape;
  if (drawShape && nShapes > ANIM_FRAMES) {
    nShapes = 20;
    radianStep = 2 * PI / nShapes;
  }
  loadShapes();
}

void initialConfig() {
  nShapes = 20;
  rotSpeed = 50; 
  angle = 0;
  radianStep = 2 * PI / nShapes; 
  radius = width/50;
  limitW = 3 * width / 5;
  limitH = height/2;
}

void loadShapes() {
  if (drawShape && (myChar == null || myChar.length != nShapes)) {
    myChar = new PShape[nShapes];
    int div = ANIM_FRAMES / nShapes;
    String name;
    for (int i = 0; i < myChar.length; i++) {
      if (i == 0) {
        name = "char_000001.obj";
      } else {
        name = "char_000" + String.format("%03d", div * (i+1)) + ".obj";
      }
      myChar[i] = loadShape(name);
      myChar[i].setFill(color(i*100/nShapes, 50, 100));
      myChar[i].scale(radius * 2.5);
    }
  }
}

void drawShapes() {
  for (int i = 0; i < nShapes; i++) {
    pushMatrix();
    float maxDist = limitW/2 - 10 - radius;
    float x = maxDist * sin(i * radianStep), 
      y = maxDist * cos(i * radianStep);
    translate(x, y, 1);
    fill(0, 0, 80);
    ellipse(0, 0, radius*2, radius*2);
    if (drawShape) {
      rotateX(PI/2);
      rotateY(PI/2 - i * radianStep);
      shape(myChar[i]);
    } else {
      float z = radius + map(((i >= nShapes/2) ? nShapes - (float) (i + 1) : (float) i), 0, nShapes, 0, limitH);    
      translate(0, 0, z);
      fill(#336699);
      sphere(radius);
    }
    popMatrix();
  }
}

void drawInfo() {  
  fill(0, 0, 100);
  pgInfo.beginDraw();
  pgInfo.background(0);
  pgInfo.textSize(16);
  pgInfo.text("Velocidad: " + rotSpeed, 0, 12);
  pgInfo.text("Figuras: " + nShapes, 0, 30);
  pgInfo.endDraw();
  image(pgInfo, 5, 5);
}
