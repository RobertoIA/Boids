class Boid {

  Tuple position;
  Tuple velocity;

  public Boid(float x, float y) {
    position = new Tuple(x, y);
    velocity = new Tuple(random(-MAX_SPEED_TOTAL, MAX_SPEED_TOTAL), 
    random(-MAX_SPEED_TOTAL, MAX_SPEED_TOTAL));
  }

  public void update() {
    velocity.setBounds(MAX_SPEED_TOTAL);
    manageCollisions();

    this.position.x += this.velocity.x;
    this.position.y += this.velocity.y;
  }

  public void draw() {
    strokeWeight(3);
    stroke(255);
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

