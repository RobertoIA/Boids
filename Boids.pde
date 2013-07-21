static final float MAX_SPEED_PARTIAL = .05;
static final float MAX_SPEED_TOTAL = 2;
static final float COHESION_STR = .8;
static final float SEPARATION_STR = 1.8;
static final float ALIGNMENT_STR = 1.;
static final float AVOIDANCE_STR = 3.0;
static final float ATTRACTION_STR = 3.5;
static final int SIGHT_RANGE = 60;
static final int PERSONAL_SPACE = 12;
static final int FRUIT_SIZE = 10;
static final int FEEDING_AREA = 50;
static final int HUNGER_TRESHOLD = 200;

static final int N_FRUITS = 6;

ArrayList<Boid> boids;
ArrayList<Fruit> fruits;
PFont displayFont;

void setup() {
  size(800, 800);
  frameRate(60);
  smooth();
  background(0);
  noStroke();

  displayFont = createFont("Arial Bold", 18);

  // initial conditions
  boids = new ArrayList<Boid>();
  fruits = new ArrayList<Fruit>();
}

void draw() {
  noStroke();
  fill(0, 50);
  rect(0, 0, width, height);

  // draw fruits
  for (Fruit fruit : fruits)
    fruit.draw();

  // move all boids to new positions
  Tuple cohesion, separation, alignment, avoidance, attraction;
  for (Boid boid: boids) {
    // draw boids
    boid.draw();

    // rule 1: cohesion
    cohesion = cohesion(boid);
    // rule 2: separation
    separation = separation(boid);
    // rule 3: alignment
    alignment = alignment(boid);
    // avoidance
    avoidance = avoidance(boid);
    // attraction
    attraction = attraction(boid);
    // apply velocity changes
    boid.velocity.x += cohesion.x * COHESION_STR + separation.x * SEPARATION_STR + alignment.x * ALIGNMENT_STR +
      avoidance.x * AVOIDANCE_STR + attraction.x * ATTRACTION_STR;
    boid.velocity.y += cohesion.y * COHESION_STR + separation.y * SEPARATION_STR + alignment.y * ALIGNMENT_STR +
      avoidance.y * AVOIDANCE_STR + attraction.y * ATTRACTION_STR;  

    feeding(boid);

    boid.update();
  }

  frame.setTitle((int) frameRate + "fps - " + this.boids.size() + " boids.");
}

void mouseDragged() {
  if (mouseButton == LEFT)
    this.boids.add(new Boid(mouseX, mouseY));
}

void mousePressed() {
  if (mouseButton == RIGHT)
    fruits.add(new Fruit(mouseX, mouseY));
}

Tuple cohesion(Boid boid) {
  Tuple cohesion = new Tuple(0, 0);
  int n = 0;
  float distance;

  for (Boid other : boids) {
    distance = dist(boid.position.x, boid.position.y, other.position.x, other.position.y);
    if (other != boid && distance < SIGHT_RANGE) {

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

  cohesion.setBounds(MAX_SPEED_PARTIAL);
  return cohesion;
}

Tuple separation(Boid boid) {
  Tuple separation = new Tuple(0, 0);
  float distance;

  for (Boid other : boids) {
    distance = dist(boid.position.x, boid.position.y, other.position.x, other.position.y);

    if (other!= boid && distance < PERSONAL_SPACE) {
      separation.x -= (boid.position.x - other.position.x) / (distance / PERSONAL_SPACE);
      separation.y -= (boid.position.y - other.position.y) / (distance / PERSONAL_SPACE);
    }
  }

  separation.x = -separation.x;
  separation.y = -separation.y;

  separation.setBounds(MAX_SPEED_PARTIAL);
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

  alignment.setBounds(MAX_SPEED_PARTIAL);
  return alignment;
}

Tuple avoidance(Boid boid) {
  Tuple avoidance = new Tuple(0, 0);

  if (dist(boid.position.x, boid.position.y, 0, boid.position.y) < SIGHT_RANGE) {
    avoidance.x += MAX_SPEED_PARTIAL;
  }
  else if (dist(boid.position.x, boid.position.y, width, boid.position.y) < SIGHT_RANGE) {
    avoidance.x -= MAX_SPEED_PARTIAL;
  }

  if (dist(boid.position.x, boid.position.y, boid.position.x, 0) < SIGHT_RANGE) {
    avoidance.y += MAX_SPEED_PARTIAL;
  }
  else if (dist(boid.position.x, boid.position.y, boid.position.x, height) < SIGHT_RANGE) {
    avoidance.y -= MAX_SPEED_PARTIAL;
  }

  float distance;
  for (Fruit fruit : fruits) {
    distance = dist(boid.position.x, boid.position.y, fruit.position.x, fruit.position.y);
    if (distance < PERSONAL_SPACE + FRUIT_SIZE / 2) {
      avoidance.x += (boid.position.x - fruit.position.x);
      avoidance.y += (boid.position.y - fruit.position.y);
    }
  }

  return avoidance;
}

Tuple attraction(Boid boid) {
  Tuple attraction = new Tuple(0, 0);
  float distance;

  // attraction to mouse pointer
  distance = dist(boid.position.x, boid.position.y, mouseX, mouseY);
  if (distance < SIGHT_RANGE) {
    attraction.x -= (boid.position.x - mouseX) / (distance / PERSONAL_SPACE);
    attraction.y -= (boid.position.y - mouseY) / (distance / PERSONAL_SPACE);
  }
  // attraction to fruit
  if (boid.health < HUNGER_TRESHOLD) {
    for (Fruit fruit : fruits) {
      distance = dist(boid.position.x, boid.position.y, fruit.position.x, fruit.position.y);
      if (distance < SIGHT_RANGE) {
        attraction.x -= (boid.position.x - fruit.position.x) / (distance / PERSONAL_SPACE);
        attraction.y -= (boid.position.y - fruit.position.y) / (distance / PERSONAL_SPACE);
      }
    }
  }

  attraction.setBounds(MAX_SPEED_PARTIAL);
  return attraction;
}

void feeding(Boid boid) {
  float distance;
  if (frameCount % 5 == 0) {
    for (Fruit fruit : fruits) {
      distance = dist(boid.position.x, boid.position.y, fruit.position.x, fruit.position.y);

      if (distance < FEEDING_AREA && fruit.food > 0 && boid.health < 255) {
        fruit.food--;
        boid.health++;
      }
    }
  }
}

