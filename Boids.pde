static final int MAX_POPULATION = 600;
static final float MAX_SPEED_PARTIAL = .05;
static final float MAX_SPEED_TOTAL = 2;
static final float COHESION_STR = .8;
static final float SEPARATION_STR = 1.8;
static final float ALIGNMENT_STR = 1.;
static final float AVOIDANCE_STR = 2.;
static final float ATTRACTION_STR = 3.5;
static final int SIGHT_RANGE = 60;
static final int PERSONAL_SPACE = 12;
static final int FEEDING_AREA = 50;
static final int HUNGER_TRESHOLD = 200;
static final int TAIL_LENGTH = 4;
static final int MAX_PELLETS = 8;
static final int PELLET_SIZE = 2;
static final float PELLETS_SEPARATION = 20;
static final int MAX_PREDATORS = 5;

ArrayList<Boid> boids;
ArrayList<Food> foodGroups;
PFont displayFont;
int predators;

void setup() {
  size(800, 800);
  frameRate(60);
  smooth();
  background(0);
  noStroke();

  displayFont = createFont("Arial Bold", 18);

  // initial conditions
  boids = new ArrayList<Boid>();
  foodGroups = new ArrayList<Food>();
  predators = 0;
}

void draw() {
  noStroke();
  fill(0);
  rect(0, 0, width, height);

  // move all boids to new positions
  Tuple cohesion, separation, alignment, avoidance, attraction;
  ArrayList<Boid> hungryBoids = new ArrayList<Boid>();
  ArrayList<Boid> deadBoids = new ArrayList<Boid>();
  for (Boid boid: boids) {
    // draw boids
    boid.draw();
    if (!(boid instanceof Predator)) {
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
    } 
    else {
      cohesion = cohesion(boid);
      alignment = alignment(boid);
      avoidance = avoidance(boid);
      boid.velocity.x += cohesion.x * COHESION_STR + alignment.x * ALIGNMENT_STR + avoidance.x * AVOIDANCE_STR;
      boid.velocity.y += cohesion.y * COHESION_STR + alignment.y * ALIGNMENT_STR + avoidance.y * AVOIDANCE_STR;
    }

    feeding(boid);

    boid.update();

    if (boid.health <= 0)
      deadBoids.add(boid);
    else if (boid.hunger <= 0)
      hungryBoids.add(boid);
  }

  // hungry boids become predators
  for (Boid hungryBoid : hungryBoids) {
    if (predators < MAX_PREDATORS) {
      Predator newPredator = new Predator(hungryBoid.position.x, hungryBoid.position.y);
      newPredator.tail = hungryBoid.tail;
      newPredator.health = hungryBoid.health;
      newPredator.hunger = hungryBoid.hunger;
      boids.remove(hungryBoid);
      boids.add(newPredator);
      predators++;
    } 
    else
      hungryBoid.health -= 10;
  }
  // removes dead boids
  for (Boid deadBoid : deadBoids)
    boids.remove(deadBoid);

  // draw fruits
  for (Food food : foodGroups) {
    food.draw();
    food.update();
  }

  frame.setTitle((int) frameRate + "fps - population " + this.boids.size() + " - food " + this.foodGroups.size());
}

void mouseDragged() {
  if (mouseButton == LEFT && this.boids.size() < MAX_POPULATION)
    this.boids.add(new Boid(mouseX, mouseY));
}

void mousePressed() {
  if (mouseButton == RIGHT)
    foodGroups.add(new Food(mouseX, mouseY));
  //  else
  //    this.boids.add(new Predator(mouseX, mouseY));
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

    if (!(other instanceof Predator) && other!= boid && distance < SIGHT_RANGE) {
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

  // Walls impact avoidance.
  if (dist(boid.position.x, boid.position.y, 0, boid.position.y) < SIGHT_RANGE)
    avoidance.x += MAX_SPEED_PARTIAL;
  else if (dist(boid.position.x, boid.position.y, width, boid.position.y) < SIGHT_RANGE)
    avoidance.x -= MAX_SPEED_PARTIAL;
  if (dist(boid.position.x, boid.position.y, boid.position.x, 0) < SIGHT_RANGE)
    avoidance.y += MAX_SPEED_PARTIAL;
  else if (dist(boid.position.x, boid.position.y, boid.position.x, height) < SIGHT_RANGE)
    avoidance.y -= MAX_SPEED_PARTIAL;

  // Impact with food avoidance.
  float distance;
  for (Food food : foodGroups) {
    distance = dist(boid.position.x, boid.position.y, food.position.x, food.position.y);
    if (distance < PERSONAL_SPACE + PELLETS_SEPARATION / 2) {
      avoidance.x += (boid.position.x - food.position.x);
      avoidance.y += (boid.position.y - food.position.y);
    }
  }

  // Predator avoidance.
  for (Boid other : boids) {
    distance = dist(boid.position.x, boid.position.y, other.position.x, other.position.y);
    if (other instanceof Predator && other!= boid && distance < SIGHT_RANGE) {
      avoidance.x += (boid.position.x - other.position.x);
      avoidance.y += (boid.position.y - other.position.y);
    }
  }

  avoidance.setBounds(MAX_SPEED_PARTIAL);
  return avoidance;
}

Tuple attraction(Boid boid) {
  Tuple attraction = new Tuple(0, 0);
  float distance;

  // attraction to mouse pointer
  distance = dist(boid.position.x, boid.position.y, mouseX, mouseY);
  if (distance < SIGHT_RANGE && distance != 0) {
    attraction.x -= (boid.position.x - mouseX) / (distance / PERSONAL_SPACE);
    attraction.y -= (boid.position.y - mouseY) / (distance / PERSONAL_SPACE);
  }
  // attraction to food
  if (boid.hunger < HUNGER_TRESHOLD) {
    for (Food food : foodGroups) {
      distance = dist(boid.position.x, boid.position.y, food.position.x, food.position.y);
      if (distance < SIGHT_RANGE) {
        attraction.x -= (boid.position.x - food.position.x) / (distance / PERSONAL_SPACE);
        attraction.y -= (boid.position.y - food.position.y) / (distance / PERSONAL_SPACE);
      }
    }
  }

  attraction.setBounds(MAX_SPEED_PARTIAL);
  return attraction;
}

void feeding(Boid boid) {
  float distance;
  if (frameCount % 5 == 0) {
    if (!(boid instanceof Predator)) {
      ArrayList<Food> eatenFood = new ArrayList<Food>();
      for (Food food : foodGroups) {
        distance = dist(boid.position.x, boid.position.y, food.position.x, food.position.y);

        if (distance < FEEDING_AREA && food.foodAmount > 0 && boid.health < 255) {
          food.foodAmount--;
          boid.health++;
        }
        if (food.foodAmount == 0)
          eatenFood.add(food);
      }
      // removes fruits that have been completely eaten
      for (Food eaten : eatenFood)
        foodGroups.remove(eaten);
    }
    else if (boid.health < 255) {
      // predator feeding
      ArrayList<Boid> eatenBoids = new ArrayList<Boid>();
      for (Boid other : boids) {
        distance = dist(boid.position.x, boid.position.y, other.position.x, other.position.y);
        if (!(other instanceof Predator) && distance < FEEDING_AREA && other.health > 0) {
          other.health -= 10;
          boid.hunger += 10;
        }
      }
    }
  }
}

