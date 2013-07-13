class Boid {

  Tuple position;

  public Boid(int x, int y) {
    position = new Tuple(x, y);
  }

  public void draw() {
    strokeWeight(3);
    stroke(255);
    point(position.x, position.y);
  }
}

