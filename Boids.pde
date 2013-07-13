static final int N_BOIDS = 20;
static final int SIGHT_RANGE = 500;

Boid[] boids;

void setup() {
  size(500, 500);
  background(0);
  noStroke();

  // initial conditions
  boids = new Boid[N_BOIDS];
  for (int i = 0; i < N_BOIDS; i++)
    boids[i] = new Boid(
    (int) random(0, width + 1), 
    (int) random(0, height + 1));
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

    // rule 3: alignment

    // apply velocity changes
    boid.velocity.x += cohesion.x;
    boid.velocity.y += cohesion.y;

    // speed limit
    boid.velocity.x = constrain(boid.velocity.x, -5, 5);
    boid.velocity.y = constrain(boid.velocity.y, -5, 5);

    boid.update();
  }
}

Tuple cohesion(Boid boid) {
  Tuple cohesion = new Tuple(0, 0);
  int n = 0;

  for (Boid other : boids) {
    if (dist(boid.position.x, boid.position.y, 
    other.position.x, other.position.y) < SIGHT_RANGE &&
      other != boid) {

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

  return cohesion;
}

