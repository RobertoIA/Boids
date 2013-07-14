class Boid {

  Tuple position;
  Tuple velocity;

  public Boid(float x, float y) {
    position = new Tuple(x, y);
    velocity = new Tuple(random(-1, 1), 
    random(-1, 1));
  }

  public void update() {
    adjustVelocity();

    this.position.x += this.velocity.x;
    this.position.y += this.velocity.y;
  }

  public void draw() {
    strokeWeight(3);
    stroke(255);
    point(position.x, position.y);
  }

  private void adjustVelocity() {
    if (max(abs(velocity.x), abs(velocity.y)) > MAX_SPEED) {
      float proportion = max(abs(velocity.x), abs(velocity.y)) / MAX_SPEED;
      this.velocity.x /= proportion;
      this.velocity.y /= proportion;

      println("adjusted " + this.velocity.x + " " + this.velocity.y);
    }

    Tuple nextPosition = new Tuple(this.position.x + this.velocity.x, 
    this.position.y + this.velocity.y);

    if (nextPosition.x > width || nextPosition.x < 0)
      this.velocity.x = -this.velocity.x;
    if (nextPosition.y > height || nextPosition.y < 0)
      this.velocity.y = -this.velocity.y;
  }
}

