static final int N_BOIDS = 200;
static final float MAX_SPEED_PARTIAL = .05;
static final float MAX_SPEED_TOTAL = 2;
static final float COHESION_STR = 1.0;
static final float SEPARATION_STR = 1.0;
static final float ALIGNMENT_STR = 1.0;
static final int SIGHT_RANGE = 60;
static final int PERSONAL_SPACE = 5;

Boid[] boids;

void setup() {
  size(500, 500);
  frameRate(60);
  background(0);
  noStroke();

  // initial conditions
  boids = new Boid[N_BOIDS];
  for (int i = 0; i < N_BOIDS; i++)
    boids[i] = new Boid(
    random(0, width + 1), 
    random(0, height + 1));
}

void draw() {
  noStroke();
  fill(0, 50);
  rect(0, 0, width, height);
  // draw boids
  for (Boid boid : boids)
    boid.draw();
  // move all boids to new positions
  Tuple cohesion, separation, alignment;
  for (Boid boid: boids) {
    // rule 1: cohesion
    cohesion = cohesion(boid);
    // rule 2: separation
    separation = separation(boid);
    // rule 3: alignment
    alignment = alignment(boid);
    // apply velocity changes
    boid.velocity.x += cohesion.x * COHESION_STR + separation.x * SEPARATION_STR + alignment.x * ALIGNMENT_STR;
    boid.velocity.y += cohesion.y * COHESION_STR + separation.y * SEPARATION_STR + alignment.y * ALIGNMENT_STR;

    boid.update();
  }
}

Tuple cohesion(Boid boid) {
  Tuple cohesion = new Tuple(0, 0);
  int n = 0;
  float distance;

  for (Boid other : boids) {
    distance = dist(boid.position.x, boid.position.y, other.position.x, other.position.y);
    if (distance < SIGHT_RANGE && other != boid) {

      cohesion.x += other.position.x;
      cohesion.y += other.position.y;
      n++;
    }
  }

  if (n != 0) {
    cohesion.x /= n;
    cohesion.y /= n;

    cohesion.x -= boid.position.x;
    cohesion.y -= boid.position.y;
  }

  cohesion.adjustSpeed(MAX_SPEED_PARTIAL);
  return cohesion;
}

Tuple separation(Boid boid) {
  Tuple separation = new Tuple(0, 0);
  float distance;

  for (Boid other : boids) {
    distance = dist(boid.position.x, boid.position.y, other.position.x, other.position.y);

    if (other!= boid && distance < SIGHT_RANGE && distance < PERSONAL_SPACE) {
      separation.x -= (boid.position.x - other.position.x) / (distance / PERSONAL_SPACE);
      separation.y -= (boid.position.y - other.position.y) / (distance / PERSONAL_SPACE);
    }
  }

  separation.x = -separation.x;
  separation.y = -separation.y;

  separation.adjustSpeed(MAX_SPEED_PARTIAL);
  return separation;
}

Tuple alignment(Boid boid) {
  Tuple alignment = new Tuple(0, 0);
  int n = 0;
  float distance;

  for (Boid other : boids) {
    distance = dist(boid.position.x, boid.position.y, other.position.x, other.position.y);

    if (other!= boid && distance < SIGHT_RANGE) {
      alignment.x += other.velocity.x;
      alignment.y += other.velocity.y;
      n++;
    }
  }

  if (n != 0) {
    alignment.x /= n;
    alignment.y /= n;
  }

  alignment.adjustSpeed(MAX_SPEED_PARTIAL);
  return alignment;
}

