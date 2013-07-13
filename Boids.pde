static final int N_BOIDS = 20;

Boid[] boids;

void setup() {
  size(500, 500);
  background(0);

  // initial conditions
  boids = new Boid[N_BOIDS];
  for (int i = 0; i < N_BOIDS; i++)
    boids[i] = new Boid(
    (int) random(0, width + 1), 
    (int) random(0, height + 1));
}

void draw() {
  // draw boids
  for (Boid boid : boids)
    boid.draw();
  // move all boids to new positions
}

