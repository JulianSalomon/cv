class WingedEdge extends Mesh {
  List<Vertex> vertices;
  List<Edge> edges;
  List<Face> faces;

  WingedEdge() {
    vertices = new ArrayList();
    edges = new ArrayList();
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
      for (Edge e : f.edges) {
        if (!visited.contains(e.start)) {
          displayVertex(e.start, sc);
          visited.add(e.start);
        }
        if (!visited.contains(e.end)) {
          displayVertex(e.end, sc);
          visited.add(e.end);
        }
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

  Edge addEdge(Vertex v0, Vertex v1) {
    Edge e = new Edge(v0, v1);
    edges.add(e);
    return e;
  }

  Face addFace(Edge... e) {
    Face f = new Face(e);
    faces.add(f);
    return f;
  }

  class Vertex extends Mesh.Vertex {
    List<Edge> edges;

    Vertex(float x, float y, float z) {
      this.x = x;
      this.y = y;
      this.z = z;
      this.edges = new ArrayList();
    }

    void addEdge(Edge e) {
      this.edges.add(e);
    }
  }

  class Edge {
    Vertex start, end;
    Face left, right;
    Edge leftPrev, leftNext, rightPrev, rightNext; // clockwise ordering

    Edge(Vertex v0, Vertex v1) {
      this.start = v0;
      this.end = v1;
      v0.addEdge(this);
      v1.addEdge(this);
    }

    void setFaces(Face left, Face right) {
      this.left = left;
      this.right = right;
    }

    void setEdges(Edge lP, Edge lN, Edge rP, Edge rN) {
      this.leftPrev = lP;
      this.leftNext = lN;
      this.rightPrev = rP;
      this.rightNext = rN;
    }
  }

  class Face {
    List<Edge> edges;

    Face(Edge... e) {
      edges = Arrays.asList(e);
    }
  }
}
