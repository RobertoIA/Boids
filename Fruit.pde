class Fruit {
  Tuple position;

  public Fruit() {
    position = new Tuple(random(0, width + 1), 
    random(0, height + 1));
  }

  public void draw() {
    strokeWeight(1);
    stroke(255, 0, 0);
    ellipse(position.x, position.y, 10, 10);
  }
}

