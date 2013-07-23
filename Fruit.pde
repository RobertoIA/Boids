class Fruit {
  Tuple position;
  int food;
  int pulseRadius;

  public Fruit(float x, float y) {
    position = new Tuple(x, y);
    food = 5000;
  }

  public void draw() {
    int shade = (int) map(food, 0, 5000, 0, 255);
    stroke(shade);
    strokeWeight(1);
    fill(shade);
    ellipse(position.x, position.y, FRUIT_SIZE, FRUIT_SIZE);

    if (frameCount % 2 == 0)
      pulseRadius = pulseRadius < FEEDING_AREA ? pulseRadius + 1 : 0;
    noFill();
    strokeWeight(1);
    stroke(shade);
    ellipse(position.x, position.y, pulseRadius, pulseRadius);
  }

  public void update() {
    if (this.position.y < height - FRUIT_SIZE / 2)
      this.position.y += .8;
  }
}

