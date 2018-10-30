class FaceVertex extends Mesh {
  List<Vertex> vertices;
  List<Face> faces;

  FaceVertex() {
    vertices = new ArrayList();
    faces = new ArrayList();
  }

  PShape getImmediate() {
    return meshShape();
  }

  PShape meshShape() {
    PShape s = createShape(GROUP);
    for (Face f : this.faces) {
      List<Vertex> visited = new ArrayList();
      PShape sc = createShape();
      sc.beginShape();
      for (Vertex v : f.vertices) {
        displayVertex(v, sc);
        visited.add(v);
      }
      sc.endShape(CLOSE);
      s.addChild(sc);
    }
    return s;
  }

  void loadRetained() {
    this.retained = meshShape();
  }

  Vertex addVertex(float x, float y, float z) {
    Vertex v = new Vertex(x, y, z);
    vertices.add(v);
    return v;
  }

  Face addFace(Vertex... v) {
    Face f = new Face(v);
    faces.add(f);
    return f;
  }

  class Vertex extends Mesh.Vertex {
    List<Face> faces;

    Vertex(float x, float y, float z) {
      this.x = x;
      this.y = y;
      this.z = z;
      this.faces = new ArrayList();
    }

    void addFace(Face f) {
      this.faces.add(f);
    }
  }

  class Face {
    List<Vertex> vertices;

    Face(Vertex... vertices) {
      this.vertices = Arrays.asList(vertices);
      for (Vertex v : vertices)
        v.addFace(this);
    }
  }
}
