class Fruit {
  Tuple position;
  int food;

  public Fruit() {
    position = new Tuple(random(0, width + 1), 
    random(0, height + 1));
    food = (int) random(5000, 10001);
  }

  public void draw() {
    strokeWeight(1);
    stroke(255);
    fill(map(food, 0, 10000, 0, 255));
    ellipse(position.x, position.y, FRUIT_SIZE, FRUIT_SIZE);
  }
}

