abstract class Mesh {
  PShape retained;

  PShape getShape() {
    if (drawingStyle)
      return this.getImmediate();
    if (this.retained == null)
      this.loadRetained();
    return this.retained;
  }

  abstract PShape getImmediate();
  abstract void loadRetained();

  void displayVertex(Vertex v, PShape s) {
    s.vertex(v.x, v.y, v.z);
  }

  class Vertex {
    float x, y, z;
  }
}
