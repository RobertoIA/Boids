class Fruit {
  Tuple position;
  int food;
  int pulseRadius;

  public Fruit() {
    position = new Tuple(random(0, width + 1), 
    random(0, height + 1));
    food = (int) random(500, 1001);
  }

  public void draw() {  
    noStroke();
    fill(map(food, 0, 1000, 0, 255));
    ellipse(position.x, position.y, FRUIT_SIZE, FRUIT_SIZE);

    if (frameCount % 2 == 0)
      pulseRadius = pulseRadius < FRUIT_SIZE * 2 ? pulseRadius + 1 : 0;
    noFill();
    strokeWeight(1);
    stroke(255);
    ellipse(position.x, position.y, pulseRadius, pulseRadius);
  }
}

