class Boid {

  Tuple position;
  Tuple velocity;

  public Boid(int x, int y) {
    position = new Tuple(x, y);
    velocity = new Tuple((int) random(-2, 2), 
    (int) random(-2, 2));
  }

  public void update() {
    this.position.x += this.velocity.x;
    this.position.y += this.velocity.y;

    if (this.position.x > width || this.position.x < 0)
      this.velocity.x = -this.velocity.x;
    if (this.position.y > height || this.position.y < 0)
      this.velocity.y = -this.velocity.y;
  }

  public void draw() {
    strokeWeight(3);
    stroke(255);
    point(position.x, position.y);
  }
}

