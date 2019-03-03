class Star {
  private Frame frame;
  private PShape shape;

  Star(Scene universe, float radius, PImage texture) {
    frame = new Frame(universe) {
      @Override
      public void visit() {
        render();
      }
    };
    shape = createShape(SPHERE, radius);
    shape.setTexture(texture);
    shape.setStroke(255);
  }

  void render() {
    universePG.pushMatrix();
    if (universe.trackedFrame("mouseMoved") == frame) {
      universePG.scale(1.5);
    }
    universePG.shape(shape);
    universePG.popMatrix();
  }
}
