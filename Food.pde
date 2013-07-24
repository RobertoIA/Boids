class Fruit {
  Tuple position;
  int food;
  Tuple[] pellets;
  int numPellets;

  // int pulseRadius;

  public Fruit(float x, float y) {
    position = new Tuple(x, y);
    food = 5000;
    numPellets = MAX_PELLETS;
    pellets = new Tuple[MAX_PELLETS];
    for (int i = 0; i < MAX_PELLETS; i++) {
      pellets[i] = new Tuple(0, 0);
      pellets[i].x = position.x + random(-PELLETS_SEPARATION, PELLETS_SEPARATION + 1);
      pellets[i].y = position.y + random(-PELLETS_SEPARATION, PELLETS_SEPARATION + 1);
    }
  }

  public void draw() {
    numPellets = (int) map(food, 0, 5000, 0, MAX_PELLETS);
    for (int i = 0; i < numPellets; i++) {
      stroke(255);
      strokeWeight(PELLET_SIZE);
      point(pellets[i].x, pellets[i].y);
    }

    // int shade = (int) map(food, 0, 5000, 0, 255);
    // stroke(shade);
    // strokeWeight(1);
    // fill(shade);
    // ellipse(position.x, position.y, FRUIT_SIZE, FRUIT_SIZE);

    //if (frameCount % 2 == 0)
      //pulseRadius = pulseRadius < FEEDING_AREA ? pulseRadius + 1 : 0;
    //noFill();
    //strokeWeight(1);
    //stroke(255);
    //ellipse(position.x, position.y, pulseRadius, pulseRadius);
  }

  public void update() {
    if (this.position.y < height - FRUIT_SIZE / 2)
      this.position.y += .8;
    for (Tuple pellet : pellets) {
      if (pellet.y < height - PELLET_SIZE / 2) {
        pellet.y += .8;
      }
    }
  }
}

