import de.voidplus.leapmotion.*;

import frames.core.*;
import frames.core.constraint.*;
import frames.primitives.*;
import frames.processing.*;
import frames.timing.*;

import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;

Hand prevHand;
Float prevValue;
PGraphics universePG, conventions;
Scene universe;
HashMap<String, Star> stars;
HashMap<String, Planet> planets;
static int rtPixels = 1; // Size of RT in pixels

Frame selection;
double time = 0;
float maxSpeed = 5, 
  maxAngleSpeed = PI / 90;
int w = 1000, h = 800;
String renderer = P3D;
boolean realSize = false, 
  showOrbitalPlane = false;

LeapMotion leap;

void settings() {
  // fullScreen(renderer);  // Uncomment to view on fullScreen
  size(w, h, renderer);
}

void setup() {
  w = width;
  h = height;
  initUniverse();
  smooth();
  leap = new LeapMotion(this);
}

void draw() {
  pushMatrix();
  universe.beginDraw();
  universePG.background(0, 0, 15);
  universe.traverse();
  universe.endDraw();
  universe.display();
  universe.beginHUD();
  leapMotionInteraction();
  universe.endHUD();
  //universePG.ambientLight(5, 5, 5);
  //universePG.directionalLight(255, 255, 255, 0, 1, 100);
  popMatrix();
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    if (universe.eye().reference() == null)
      universe.spin();
    else
      universe.spin(selection);
  } else if (mouseButton == RIGHT) {
    universe.translate();
  } else {
    universe.moveForward(mouseX - pmouseX);
  }
}

void mouseClicked() {
  updateSelection(universe.track("mouseClicked", mouseX, mouseY));
}

void mouseWheel(MouseEvent event) {
  if (keyPressed) {
    time += Math.signum(event.getCount());
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
  case 'e':
    realSize = !realSize;
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

// Leap motion

boolean isHandPicking(Hand hand) {
  if (hand != null && hand.getIndexFinger() != null && hand.getThumb() != null) {
    PVector indexPosition = hand.getIndexFinger().getStabilizedPosition(), 
      thumbPosition = hand.getThumb().getStabilizedPosition();
    if (indexPosition != null && thumbPosition != null) {
      return PVector.dist(indexPosition, thumbPosition) < 30;
    }
  }
  return false;
}

void leapMotionInteraction() {
  Hand left = leap.getLeftHand(), 
    right = leap.getRightHand();
  drawHand(left);
  drawHand(right);
  drawHand(prevHand);
  if (left == null && right == null) {
    return;
  } else if (prevHand == null && leap.getHands().size() == 2 &&
    left != null && left.getOutstretchedFingers().size() == 0 &&
    right != null && right.getOutstretchedFingers().size() == 0) {                     // Reset eye 
    resetEye();
    return;
  } else if (right.isRight() && right.getOutstretchedFingers().size() == 0) {          // Selection
    Frame f = universe.track("LEAP", right.getPosition().x, right.getPosition().y);
    if (f != null)
      updateSelection(f);
  } else if (left.isLeft() && left.getOutstretchedFingers().size() == 0) {             // Increase time 
    float value = left.getPosition().x;
    if (prevValue == null)
      prevValue = value;
    println(prevValue, value);
    time += map(prevValue - value, -width / 2, width / 2, -0.1, 0.1);
  } else {
    boolean leftPicking = false, rightPicking = false;
    if (left != null && left.isLeft())
      leftPicking = isHandPicking(left); 
    if (right != null && right.isRight()) 
      rightPicking = isHandPicking(right);
    if (leftPicking && rightPicking) {                                                 // Scalation
      prevHand = null;
      float distance = PVector.dist(left.getStabilizedPosition(), right.getStabilizedPosition());
      if (prevValue == null)
        prevValue = distance;
      float distMax = sqrt(pow(width, 2) + pow(height, 2));
      float d = map(distance - prevValue, - distMax, distMax, -30, 30);
      universe.scale(d);
    } else if (rightPicking || leftPicking) {
      if (rightPicking) {                                                         // Rotation
        PVector direction = left.getDirection();
        if (prevHand == null)
          prevHand = left;
        PVector delta = PVector.sub(direction, prevHand.getDirection());
        delta.x = map(delta.x, -180, 180, -maxAngleSpeed, maxAngleSpeed);
        delta.y = map(delta.y, -180, 180, -maxAngleSpeed, maxAngleSpeed);
        delta.z = map(delta.z, -180, 180, -maxAngleSpeed, maxAngleSpeed);

        if (universe.eye().reference() == null)
          universe.spin(new Quaternion(delta.x, delta.y, delta.z), universe.eye());
        else
          universe.spin(new Quaternion(delta.x, delta.y, delta.z), selection);
      } else {                                                         // Translation
        PVector position = right.getStabilizedPosition();
        position.z = right.getPosition().z;
        if (prevHand == null)
          prevHand = right;
        PVector delta = PVector.sub(position, prevHand.getPosition());
        if (sqrt(pow(delta.x, 2) + pow(delta.y, 2))  < 50) {
          delta.x = 0;
          delta.y = 0;
        }
        delta.x = map(delta.x, -width / 2, width / 2, -maxSpeed, maxSpeed);
        delta.y = map(delta.y, -height / 2, height / 2, -maxSpeed, maxSpeed);
        delta.z = map(delta.z, 0, 100, -maxSpeed, maxSpeed);
        universe.translate("LEAP", delta.x, delta.y, 0);
      }
    } else {
      prevHand = null;
      prevValue = null;
    }
  }
}

void drawHand(Hand hand) {
  if (hand == null)
    return;
  PVector position = hand.getStabilizedPosition();
  float size = map(hand.getPosition().z, 0, 50, 15, 30);
  pushStyle();
  noFill();
  if (hand == prevHand) {
    stroke(255, 255, 255);
    fill(200, 200, 200, 150);
  } else if (hand.getOutstretchedFingers().size() == 0) {
    stroke(255, 0, 255);
    fill(200, 0, 200, 150);
  } else if (isHandPicking(hand)) {
    stroke(0, 255, 0);
    fill(0, 200, 0, 150);
  } else if (hand.isLeft()) {
    stroke(255, 0, 0);
    fill(200, 0, 0, 150);
  } else {
    stroke(0, 0, 255);
    fill(0, 0, 200, 150);
  }
  ellipse(position.x, position.y, size, size);
  universe.cast("LEAP", position.x, position.y);
  popStyle();
}
