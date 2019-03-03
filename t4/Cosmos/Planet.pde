class Planet {
  private PShape shape;
  private Frame frame;
  private Orbit orbit;
  private Vector position;

  Planet(float radius, PImage texture, Orbit o) {
    orbit = o;
    frame = new Frame(orbit.frame) {
      @Override
      public void visit() {
        render();
      }
    };
    frame.setOrientation(orbit.frame.orientation());
    shape = createShape(SPHERE, radius);
    shape.setTexture(texture);
    shape.setStroke(255);
    shape.rotateX(-PI / 2);
  }

  Planet(PShape s, Orbit o) {
    frame = new Frame(orbit.frame) {
      @Override
      public void visit() {
        render();
      }
    };
    shape = s;
  }

  void render() {
    frame.setPosition(orbit.getPosition());
    universePG.pushMatrix();
    if (!realSize)
      universePG.scale(15);
    if (universe.trackedFrame("mouseMoved") == frame)
      universePG.scale(1.5);
    universePG.shape(shape);
    universePG.popMatrix();
  }
}
