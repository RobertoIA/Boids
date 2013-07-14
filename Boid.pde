class Boid {

  Tuple position;
  Tuple velocity;

  public Boid(float x, float y) {
    position = new Tuple(x, y);
    velocity = new Tuple(random(-1, 1), 
    random(-1, 1));
  }

  public void update() {
    this.position.x += this.velocity.x;
    this.position.y += this.velocity.y;

    if (this.position.x > width || this.position.x < 0)
      this.velocity.x = -this.velocity.x;
    if (this.position.y > height || this.position.y < 0)
      this.velocity.y = -this.velocity.y;

    this.velocity.x = constrain(this.velocity.x, -1, 1);
    this.velocity.y = constrain(this.velocity.y, -1, 1);

    println(this.velocity.x + " " + this.velocity.y);
  }

  public void draw() {
    strokeWeight(3);
    stroke(255);
    point(position.x, position.y);
  }
}

