class VertexVertex extends Mesh {
  List<Vertex> vertices;

  VertexVertex() {
    vertices = new ArrayList();
  }

  PShape getImmediate() {
    return meshShape();
  }

  PShape meshShape() {
    PShape s = createShape(GROUP);
    List<Set<Vertex>> visited = new ArrayList();
    for (Vertex vertex : this.vertices) {
      List<Vertex> neighbors = vertex.vertices; // Vertex neighbors
      for (int i = 0; i < neighbors.size(); i++) {
        Vertex neighborI = neighbors.get(i);
        for (int j = i + 1; j < neighbors.size(); j++) {
          Vertex neighborJ = neighbors.get(j);
          if (neighborI.vertices.contains(neighborJ)) {
            Set<Vertex> face = new HashSet<Vertex>();
            face.add(vertex);
            face.add(neighborI);
            face.add(neighborJ);
            if (!visited.contains(face)) {
              visited.add(face);
              PShape sc = createShape();
              sc.beginShape();
              displayVertex(vertex, sc);
              displayVertex(neighborI, sc);
              displayVertex(neighborJ, sc);
              sc.endShape(CLOSE);
              s.addChild(sc);
            }
          }
        }
      }
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

  class Vertex extends Mesh.Vertex {
    List<Vertex> vertices;

    Vertex(float x, float y, float z) {
      this.x = x;
      this.y = y;
      this.z = z;
      this.vertices = new ArrayList();
    }

    void addVertex(Vertex v) {
      this.vertices.add(v);
    }

    void addVertices(Vertex... v) {
      this.vertices.addAll(Arrays.asList(v));
    }
  }
}
