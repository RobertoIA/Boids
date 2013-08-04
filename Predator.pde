class Predator extends Boid {

  public Predator(float x, float y) {
    super(x, y);
  }

  public void draw() {
    strokeWeight(1);
    stroke(health, 0, 0);
    for (int i = 0; i < TAIL_LENGTH - 1; i++)
      line(tail[i].x, tail[i].y, tail[i + 1].x, tail[i + 1].y);
    line(tail[TAIL_LENGTH - 1].x, tail[TAIL_LENGTH - 1].y, position.x, position.y);

//    stroke(255, 0, 0);
//    noFill();
//    ellipse(position.x, position.y, FEEDING_AREA, FEEDING_AREA);
  }
}

