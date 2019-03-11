public class Orbit {
  public Frame frame;
  private float i, RAAN, e, 
    argPerigee, a, b;
  private double meanMotion, t;

  public Orbit(Graph frame, float inclination, float RAAN, 
    float eccentricity, float argPerigee, double meanMotion) {
    this.frame = new Frame(frame) {
      @Override
        public void visit() {
        render();
      }
    };
    setValues(inclination, RAAN, eccentricity, argPerigee, meanMotion);
  }

  public Orbit(Frame frame, float inclination, float RAAN, 
    float eccentricity, float argPerigee, double meanMotion) {
    this.frame = new Frame(frame) {
      @Override
        public void visit() {
        render();
      }
    };
    setValues(inclination, RAAN, eccentricity, argPerigee, meanMotion);
  }

  private void setValues(float inclination, float RAAN, 
    float eccentricity, float argPerigee, double meanMotion) {
    this.i = inclination;
    this.RAAN = RAAN;
    this.e = eccentricity;
    this.argPerigee = argPerigee;
    this.meanMotion = meanMotion;
    float g = 6.67 * pow(10, -11);
    float m1 = 5.96 * pow(10, 24);
    double n = this.meanMotion / (24 * 60 * 60);
    this.t = 1 / this.meanMotion;
    this.a = (float) metersToPixels(Math.pow(Math.E, Math.log((g * m1)/(4 * Math.pow(PI, 2) * Math.pow(n, 2)))/3));
    this.b = (float) (Math.sqrt(Math.pow(this.a, 2) - Math.pow(this.a * this.e, 2)));
    
    frame.rotate(0, 0, 1, radians(RAAN));
    frame.rotate(1, 0, 0, radians(i));
    frame.rotate(0, 0, 1, radians(argPerigee));
  }

  public float r(float theta) {
    return a * (1 - pow(e, 2)) / (1 + e * cos(theta));
  }

  public void render() {
    if (showOrbitalPlane) {
      drawOrbitPlane();
    }
    drawOrbit();
  }

  public void drawOrbitPlane() {
    universePG.pushStyle();
    universePG.fill(0, 150, 0, 20);
    universePG.stroke(0, 180, 0);

    universePG.beginShape();
    universePG.vertex(-1.3 * a, 1.3 * a);
    universePG.vertex(-1.3 * a, -1.3 * a);
    universePG.vertex(1.3 * a, -1.3 * a);
    universePG.vertex(1.3 * a, 1.3 * a);
    universePG.endShape(CLOSE);
    universePG.popStyle();
  }

  public void drawOrbit() {
    universePG.pushStyle();
    universePG.strokeWeight(2);
    universePG.noFill();
    universePG.stroke(50, 50, 50);
    universePG.beginShape();
    for (int p = 0; p < 360; p++) {
      float angle = 2 * p * PI / 360, 
        r = r(angle), 
        x = r * cos(angle), 
        y = r * sin(angle);
      universePG.vertex(x, y);
    }
    universePG.endShape(CLOSE);
    universePG.popStyle();
  }

  Vector getPosition() {
    float angle = radians((float) (time * 360 / t));
    float r = r(angle), 
      x = r * cos(angle), 
      y = r * sin(angle);
    return frame.worldLocation(new Vector(x, y, 0));
  }
}
