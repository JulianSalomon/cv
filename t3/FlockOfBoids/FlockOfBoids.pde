/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 *
 * This example displays the famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 [1] and then adapted to Processing by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * The Boid under the mouse will be colored blue. If you click on a boid it will
 * be selected as the scene avatar for the eye to follow it.
 *
 * 1. Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 87.
 * http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
 * 2. Check also this nice presentation about the paper:
 * https://pdfs.semanticscholar.org/73b1/5c60672971c44ef6304a39af19dc963cd0af.pdf
 * 3. Google for more...
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the boid visual mode.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
Interpolator interpolator;
//flock bounding box
static int flockWidth = 1280;
static int flockHeight = 720;
static int flockDepth = 600;
static boolean avoidWalls = true;

int initBoidNum = 900; // amount of boids to start the program with
ArrayList<Boid> flock;
Frame avatar;
boolean animate = true;

Mesh actualMesh;
List<Mesh> boidMeshes;

// true for immediate, false for retained
boolean drawingStyle = false;

void setup() {
  size(1000, 800, P3D);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  scene.setFieldOfView(PI / 3);
  scene.fitBall();
  // create and fill the list of boids
  flock = new ArrayList();

  boidMeshes();

  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));

  interpolator =  new Interpolator(scene);
}

void draw() {
  background(10, 50, 25);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();

  pushStyle();
  strokeWeight(3);
  stroke(255);
  scene.drawPath(interpolator);
  popStyle();
  // uncomment to asynchronously update boid avatar. See mouseClicked()
  // updateAvatar(scene.trackedFrame("mouseClicked"));
}

void walls() {
  pushStyle();
  noFill();
  stroke(255, 255, 0);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void updateAvatar(Frame boid) {
  if (boid != avatar) {
    avatar = boid;
    if (avatar != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  scene.eye().setReference(avatar);
  scene.interpolateTo(avatar);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fitBallInterpolation();
}

// picks up a boid avatar, may be null
void mouseClicked() {
  // two options to update the boid avatar:
  // 1. Synchronously
  updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
  // scene.track("mouseClicked", mouseX, mouseY);
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  // 2. Asynchronously
  // which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
  // scene.cast("mouseClicked", mouseX, mouseY);
}

// 'first-person' interaction
void mouseDragged() {
  if (scene.eye().reference() == null)
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.spin();
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.translate();
    else
      // same as: scene.zoom(mouseX - pmouseX, scene.eye());
      scene.zoom(mouseX - pmouseX);
}

// highlighting and 'third-person' interaction
void mouseMoved(MouseEvent event) {
  // 1. highlighting
  scene.cast("mouseMoved", mouseX, mouseY);
  // 2. third-person interaction
  if (scene.eye().reference() != null)
    // press shift to move the mouse without looking around
    if (!event.isShiftDown())
      scene.lookAround();
}

void mouseWheel(MouseEvent event) {
  // same as: scene.scale(event.getCount() * 20, scene.eye());
  scene.scale(event.getCount() * 20);
}

void keyPressed() {
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case ' ':
    if (scene.eye().reference() != null)
      resetEye();
    else if (avatar != null)
      thirdPerson();
    break;
  case '+':
    int index = int(random(0, initBoidNum));
    interpolator.addKeyFrame(flock.get(index).frame);
    break;
  case '-':
    interpolator.clear();
    break;
  case 'd':
    drawingStyle = !drawingStyle;
    if (drawingStyle)
      println("Immediate style");
    else
      println("Retained style");
    break;
  case 'm':
    int idx = boidMeshes.indexOf(actualMesh);
    actualMesh = boidMeshes.get((idx + 1) % boidMeshes.size());
    println("Using " + actualMesh.getClass().getSimpleName() + " mesh");
    break;
  }
}

void boidMeshes() {
  boidMeshes = new ArrayList();

  {
    WingedEdge we = new WingedEdge();
    WingedEdge.Vertex v0 = we.addVertex(3, 0, 0), 
      v1 = we.addVertex(-3, 2, 0), 
      v2 = we.addVertex(-3, -2, 0), 
      v3 = we.addVertex(-3, 0, 2);

    WingedEdge.Edge e0 = we.addEdge(v0, v1), 
      e1 = we.addEdge(v0, v2), 
      e2 = we.addEdge(v0, v3), 
      e3 = we.addEdge(v1, v2), 
      e4 = we.addEdge(v1, v3), 
      e5 = we.addEdge(v2, v3);

    we.addFace(e0, e1, e3); 
    we.addFace(e0, e2, e4); 
    we.addFace(e1, e2, e5); 
    we.addFace(e3, e4, e5);
    boidMeshes.add(we);

    actualMesh = we;
  }  
  {
    FaceVertex fv = new FaceVertex();
    FaceVertex.Vertex v0 = fv.addVertex(3, 0, 0), 
      v1 = fv.addVertex(-3, 2, 0), 
      v2 = fv.addVertex(-3, -2, 0), 
      v3 = fv.addVertex(-3, 0, 2);

    fv.addFace(v0, v1, v2);
    fv.addFace(v0, v1, v3);
    fv.addFace(v0, v2, v3);
    fv.addFace(v1, v2, v3);

    boidMeshes.add(fv);
  }
  {
    VertexVertex vv = new VertexVertex();
    VertexVertex.Vertex v0 = vv.addVertex(3, 0, 0), 
      v1 = vv.addVertex(-3, 2, 0), 
      v2 = vv.addVertex(-3, -2, 0), 
      v3 = vv.addVertex(-3, 0, 2);

    v0.addVertices(v1, v2, v3);
    v1.addVertices(v0, v2, v3);
    v2.addVertices(v0, v1, v3);
    v3.addVertices(v0, v1, v2);

    boidMeshes.add(vv);
  }
}
