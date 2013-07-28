class Food {
  Tuple position;
  int foodAmount;
  Tuple[] pellets;
  int numPellets;

  public Food(float x, float y) {
    position = new Tuple(x, y);
    foodAmount = 5000;
    numPellets = MAX_PELLETS;
    pellets = new Tuple[MAX_PELLETS];
    for (int i = 0; i < MAX_PELLETS; i++) {
      pellets[i] = new Tuple(0, 0);
      pellets[i].x = position.x + random(-PELLETS_SEPARATION, PELLETS_SEPARATION + 1);
      pellets[i].y = position.y + random(-PELLETS_SEPARATION, PELLETS_SEPARATION + 1);
    }
  }

  public void draw() {
    numPellets = (int) map(foodAmount, 0, 5000, 0, MAX_PELLETS);
    for (int i = 0; i < numPellets; i++) {
      stroke(255);
      strokeWeight(PELLET_SIZE);
      point(pellets[i].x, pellets[i].y);
    }
  }

  public void update() {
    if (this.position.y < height - PELLETS_SEPARATION / 2)
      this.position.y += .8;
    for (Tuple pellet : pellets)
      if (pellet.y < height - PELLET_SIZE / 2)
        pellet.y += .8;
  }
}

