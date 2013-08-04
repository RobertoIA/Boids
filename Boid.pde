class Boid {

  Tuple position;
  Tuple velocity;
  Tuple[] tail;
  int health;
  int hunger;
  int pulseRadius;

  public Boid(float x, float y) {
    position = new Tuple(x, y);
    velocity = new Tuple(random(-MAX_SPEED_TOTAL, MAX_SPEED_TOTAL), 
    random(-MAX_SPEED_TOTAL, MAX_SPEED_TOTAL));
    tail = new Tuple[TAIL_LENGTH];
    for (int i = 0; i < TAIL_LENGTH; i++)
      tail[i] = new Tuple(position.x, position.y);
    health = 255;
    hunger = (int) random(200, 256);
  }

  public void update() {
    velocity.setBounds(MAX_SPEED_TOTAL * (health / 255.0));
    manageCollisions();

    // update tail
    for (int i = 0; i < TAIL_LENGTH - 1; i++) {
      tail[i].x = tail[i + 1].x;
      tail[i].y = tail[i + 1].y;
    }
    tail[TAIL_LENGTH - 1] = this.position;
    // update position
    this.position.x += this.velocity.x;
    this.position.y += this.velocity.y;

    // starvation
    if (frameCount % 30 == 0 && health > 0)
      hunger--;
  }

  public void draw() {
    strokeWeight(1);
    stroke(health >= 0 ? health : 0);

    for (int i = 0; i < TAIL_LENGTH - 1; i++)
      line(tail[i].x, tail[i].y, tail[i + 1].x, tail[i + 1].y);
    line(tail[TAIL_LENGTH - 1].x, tail[TAIL_LENGTH - 1].y, position.x, position.y);

    if (hunger <= 50) {
      if (frameCount % 2 == 0)
        pulseRadius = pulseRadius < FEEDING_AREA ? pulseRadius + 1 : 0;
      noFill();
      strokeWeight(1);
      stroke(255);
      ellipse(position.x, position.y, pulseRadius, pulseRadius);
    }
    else if (pulseRadius != 0)
      pulseRadius = 0;
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

