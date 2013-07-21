class Boid {

  Tuple position;
  Tuple velocity;
  int health;

  public Boid(float x, float y) {
    position = new Tuple(x, y);
    velocity = new Tuple(random(-MAX_SPEED_TOTAL, MAX_SPEED_TOTAL), 
    random(-MAX_SPEED_TOTAL, MAX_SPEED_TOTAL));
    health = (int) random(200, 256);
  }

  public void update() {
    velocity.setBounds(MAX_SPEED_TOTAL);
    manageCollisions();

    this.position.x += this.velocity.x;
    this.position.y += this.velocity.y;

    // starvation
    if (frameCount % 10 == 0 && health > 0)
      health--;
  }

  public void draw() {
    strokeWeight(3);
    stroke(health);
    point(position.x, position.y);
  }

  private void manageCollisions() {
    Tuple nextPosition = new Tuple(this.position.x + this.velocity.x, 
    this.position.y + this.velocity.y);

    if (nextPosition.x > width || nextPosition.x < 0)
      this.velocity.x = -this.velocity.x;
    if (nextPosition.y > height || nextPosition.y < 0)
      this.velocity.y = -this.velocity.y;
  }
}

