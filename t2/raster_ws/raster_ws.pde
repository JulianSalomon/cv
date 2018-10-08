import frames.timing.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;
// triangle's vertices color
color[] c = {color(255, 255, 0), color(0, 255, 255), color(255, 0, 255)};
int sft = 50;
// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;
boolean squareCap = false;
boolean antialiasing = false;
boolean depthMap = false;
// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

void setup() {
  //use 2^n to change the dimensions
  size(1024, 1024, renderer);

  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
      public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {  
  int limCoord = floor(pow(2, n)/2);
  boolean repeat = true;
  // Iteration through the grid
  for (int i = - limCoord; i < limCoord; i++) {
    for (int j = - limCoord; j < limCoord; j++) {
      pushStyle();
      // Convert vector to world frame to operate with v1, v2 and v3 
      Vector p = frame.worldLocation(new Vector(i + 0.5f, j + 0.5f));
      // Draw point if vector belongs to area 
      if (belongsToArea(p, false)) {
        drawPoint(i, j);
        repeat = false;
        // In case of antialiasing, iterate the neighbors of the vector
        // Any vector outside the triangle is going to get coloured for soft effect
        if (antialiasing) {
          Vector[] n = neighbors(i, j);
          for (int k = 0; k < 8; k++) {
            if (belongsToArea(n[k], true)) {
              int[] po = positions(k);
              drawPoint(i + po[0], j + po[1]);
            }
          }
        }
      }
      popStyle();
    }
    // last iteration and no pixel painted at all 
    if (i == limCoord - 1 && repeat) {
      Vector v = v1;
      v1 = v2;
      v2 = v;
      i = -limCoord;
      // prevents from infinite cycle
      repeat = false;
    }
  }
  // frame.location converts points from world to frame
  // here we convert v1 to illustrate the idea
  if (debug) {
    pushStyle();
    setColor(color(c[1], 150));
    drawPoint(floor(frame.location(v1).x()), floor(frame.location(v1).y()));
    setColor(color(c[2], 150));
    drawPoint(floor(frame.location(v2).x()), floor(frame.location(v2).y()));
    setColor(color(c[0], 150));
    drawPoint(floor(frame.location(v3).x()), floor(frame.location(v3).y()));
    popStyle();
  }
}

// Determines if a vector belongs to the triangle and the color of it
// If used with softMode (antialiasing) will compute the color with transparency of a vector outside the triangle 
boolean belongsToArea(Vector p, boolean softMode) {
  boolean belongsTo;
  float w[] = new float[3];
  belongsTo = (w[0] = edge(p, v1, v2)) >= 0;
  belongsTo &= (belongsTo || softMode) ? (w[1] = edge(p, v2, v3)) >= 0 : false;
  belongsTo &= (belongsTo || softMode) ? (w[2] = edge(p, v3, v1)) >= 0 : false;
  if (belongsTo && !softMode || !belongsTo && softMode) {
    color c = interpolateRGB(w);
    if (depthMap)
      c = depthMap(p, c);
    if (softMode)
      c = color(c, sft);
    setColor(c);
    return true;
  }
  return false;
}

// Computes color of a vector in the triangle
color interpolateRGB(float[] edge) {
  float r = 0, g = 0, b = 0, 
    area = edge(v1, v2, v3);
  for (int i = 0; i < 3; i++) {
    edge[i] /= area;
    r += edge[i] * red(c[i]);
    g += edge[i] * green(c[i]);
    b += edge[i] * blue(c[i]);
  }
  return color(r, g, b);
}

// Computes normalized distance from eye position to a vector p
float distanceToEye(Vector p) {
  Vector eye = scene.eye().position();
  Vector point = scene.eye().location(p);
  // Distances in avg are between 0 and 2000
  float d = eye.distance(point);
  return norm(d, 2000, 0);
}

// Darkens a color c of a vector p with distance to eye
color depthMap(Vector p, color c) {
  float normDistance = distanceToEye(p), 
    r = red(c) * normDistance, 
    g = green(c) * normDistance, 
    b = blue(c) * normDistance;
  return color(r, g, b);
}

// Edge function
float edge(Vector p, Vector vi, Vector vj) {
  float px = frame.location(p).x(), py = frame.location(p).y(), 
    vix = frame.location(vi).x(), viy = frame.location(vi).y(), 
    vjx = frame.location(vj).x(), vjy = frame.location(vj).y();
  return (px - vix) * (vjy - viy) - (py - viy) * (vjx - vix);
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    v1 = new Vector(mouseX-width/2, mouseY-height/2);
  } else if (mouseButton == RIGHT) {
    v2 = new Vector(mouseX-width/2, mouseY-height/2);
  } else {
    v3 = new Vector(mouseX-width/2, mouseY-height/2);
  }
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

// Computes neighbors of a vector
Vector[] neighbors(int i, int j) {
  Vector[] n = new Vector[8];
  for (int k = 0; k < 8; k++) {
    int [] po = positions(k);
    n[k] = frame.worldLocation(new Vector(i + po[0] + 0.5f, j + po[1] + 0.5f));
  }
  return n;
}

int[] positions(int i) {
  int [] po = new int[2];
  switch(i) {
  case 0:
    po[0] = -1;
    po[1] = -1;
    break;
  case 1:
    po[0] = 1;
    po[1] = 1;
    break;
  case 2:
    po[0] = -1;
    po[1] = 1;
    break;
  case 3:
    po[0] = 1;
    po[1] = -1;
    break;
  case 4:
    po[0] = 0;
    po[1] = -1;
    break;
  case 5:
    po[0] = -1;
    po[1] = 0;
    break;
  case 6:
    po[0] = 0;
    po[1] = 1;
    break;
  case 7:
    po[0] = 1;
    po[1] = 0;
    break;
  }
  return po;
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
  if (key == 'c')  // Changes strokeCap to SQUARE
    squareCap = !squareCap;
  if (key == 'a')
    antialiasing = !antialiasing;
  if (key == 'p')
    depthMap = !depthMap;
  if (antialiasing) {
    if (key == 'w')
      sft += 4;
    if (key == 's')
      sft -= 4;
  }
}

void drawPoint(float x, float y) {
  if (squareCap) {
    noStroke();
    rect(x, y, 1, 1);
  } else
    point(x + 0.5, y + 0.5);
}

void setColor(color c) {
  stroke(c);
  fill(c);
}
