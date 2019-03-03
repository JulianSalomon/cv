import frames.core.*;
import frames.core.constraint.*;
import frames.primitives.*;
import frames.processing.*;
import frames.timing.*;

import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;

PGraphics universePG;
Scene universe;
HashMap<String, Star> stars;
HashMap<String, Planet> planets;
static int rtPixels = 1; // Size of RT in pixels
PGraphics conventions;

Frame selection;
double time = 0;
int w = 1000, h = 800;
String renderer = P3D;
boolean showEarth = true,
  showOrbitalPlane = false;

void settings() {
  // fullScreen(renderer);  // Uncomment to view on fullScreen
  size(w, h, renderer);
}

void setup() {
  w = width;
  h = height;
  initUniverse();
  smooth();
}

void draw() {
  pushMatrix();
  universe.beginDraw();
  universePG.background(0, 0, 35);
  universe.traverse();
  universe.endDraw();
  universe.display();
  universePG.ambientLight(5, 5, 5);
  universePG.directionalLight(255, 255, 255, 0, 1, 100);
  popMatrix();
}

void mouseDragged() {
  if (universe.eye().reference() == null) {
    if (mouseButton == LEFT)
      universe.spin();
    else if (mouseButton == RIGHT)
      universe.translate();
    else
      universe.moveForward(mouseX - pmouseX);
  }
}

void mouseClicked() {
  updateSelection(universe.track("mouseClicked", mouseX, mouseY));
}

void mouseWheel(MouseEvent event) {
  if (keyPressed) {
    time += 1;
  } else
    universe.scale(-event.getCount() * 50);
}

void mouseMoved(MouseEvent event) {
  universe.cast("mouseMoved", mouseX, mouseY);
}

void keyPressed() {
  switch(key) {
  case 'r':
    showOrbitalPlane = !showOrbitalPlane;
    break;
  }
}

void updateSelection(Frame frame) {
  if (frame != selection) {
    selection = frame;
    if (selection != null)
      thirdPerson();
    else if (universe.eye().reference() != null)
      resetEye();
  }
}

void resetEye() {
  universe.eye().resetReference();
  universe.lookAt(universe.center());
  universe.fit(1);
}

void thirdPerson() {
  universe.eye().setReference(selection);
  universe.fit(selection, 1);
}

void initUniverse() {
  universePG = createGraphics(w, h, renderer);
  universe = new Scene(this, universePG);
  universe.setType(Graph.Type.ORTHOGRAPHIC);
  stars = new HashMap(); 
  planets = new HashMap();
  stars.put("sun", new Star(universe, (float) metersToPixels(6957000), loadImage("textures/sun.jpg")));
  createPlanets();
}

void createPlanets() {
  Frame sunFrame = stars.get("sun").frame;
  Orbit orbit = new Orbit(sunFrame, 7.155, 174.9, 0.0167086, 288.1, 0.00273780309);
  planets.put("earth", new Planet(1, loadImage("textures/earth.jpg"), orbit));
  orbit = new Orbit(sunFrame, 3.38, 48.331, 0.205630, 29.124, 0.011367628);
  planets.put("mercury", new Planet((float) metersToPixels(4880000), loadImage("textures/mercury.jpg"), orbit));
  Frame earthFrame = planets.get("earth").frame;
  orbit = new Orbit(earthFrame, 5.15, 125.08, 0.0549, 318.15, 0.0366005417);
  planets.put("moon", new Planet((float) metersToPixels(1738100), loadImage("textures/moon.jpg"), orbit));
}

void drawAngle(float r, float angle) {
  universePG.arc(0, 0, 2 * r, 2 * r, 0, radians(angle), PIE);
}

static double metersToPixels(double meters) {
  return rtPixels * meters / 6378000;
}

static double pixelsToMeters(double pixs) {
  return 6378000 * pixs / rtPixels;
}
