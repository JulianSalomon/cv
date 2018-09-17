float MAX, MIN, RANGE, SIZE, STEP, STEP_AUX, DIRECTION, DEG_STEP;
float radius, theta;
int N_LEAFS;
int nEllipses;

void setup() {
  size(1000, 1000, P2D);
  //fullScreen(P2D);
  ellipseMode(CENTER);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  smooth();
  initialConfig();
}

void draw() {
  if (!mousePressed) {
    background(0);
  }
  translate(width/2, height/2);

  float x, y;
  for (int i = 0; i < 2 * nEllipses; i++) {
    // Conversion to cartesian coord.
    x = radius * cos(theta);
    y = radius * sin(theta);
    fill(degrees(2 * PI - theta), 100, 100);
    ellipse(x, y, SIZE, SIZE);

    // Increase degrees to draw next ellipse
    theta = (theta + DEG_STEP) % (2 * PI);
    // Compute position of next ellipse
    sumRadius(STEP_AUX);
  }
  // Move ellipse in line
  sumRadius(STEP);
}

void keyPressed() {
  switch (key) {
  case '+':
    nEllipses += 2;
    break;
  case '-':
    nEllipses -= (nEllipses > 2) ? 2 : 0;
    break;
  case '>':
    N_LEAFS++;
    break;
  case '<':
    N_LEAFS -= (N_LEAFS > 0) ? 1 : 0;
    break;
  default:
    return;
  }
  println("Leafs to display:\t", N_LEAFS, "\tEllipses:\t", nEllipses);
  computeSteps();
  background(0);
}


void initialConfig() {
  nEllipses = 16;
  N_LEAFS = 3;

  int ref = min(width, height);
  MAX = ref * 0.40;
  MIN = ref * 0.1;
  RANGE = MAX - MIN;
  SIZE = ref * 0.02;
  DIRECTION = 1;
  STEP = ref * 0.005;
  radius = MIN;

  computeSteps();
}

/* 
 * Sum a number to radius variable to keep in the interval of [MIN, MAX]
 * step is the number to sum
 * Determines direction of next step
 */
void sumRadius(float step) {
  // Discards sums that will result into the initial value
  if (step > (2 * RANGE)) {
    step %= 2 * RANGE;
  }
  // Sum exceeds limits of interval
  if (radius + step * DIRECTION > MAX || radius + step * DIRECTION < MIN) {
    float limit = (radius + step * DIRECTION >= MAX) ? MAX : MIN;
    step = Math.abs(step * DIRECTION - limit + radius);
    DIRECTION *= -1;
    radius = limit;
    sumRadius(step);
  } else {
    // Base case
    radius += step * DIRECTION;
  }
}

/* Compute:
 * - Degree steps to fill 2PI with nEllipses
 * - Step for next ellipse radius to display N_LEAFS 
 */
void computeSteps() {  
  DEG_STEP = 2 * PI / nEllipses;
  STEP_AUX = Math.signum(STEP) * float(N_LEAFS) * 2 * RANGE / nEllipses;
}
