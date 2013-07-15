class Tuple {
  float x;
  float y;

  public Tuple(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void adjustSpeed(float maxSpeed) {
    if (max(abs(this.x), abs(this.y)) > maxSpeed) {
      float proportion = max(abs(this.x), abs(this.y)) / maxSpeed;
      this.x /= proportion;
      this.y /= proportion;
    }
  }
}

