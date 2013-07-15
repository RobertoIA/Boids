class Tuple {
  float x;
  float y;

  public Tuple(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void setBounds(float maximumValue) {
    if (max(abs(this.x), abs(this.y)) > maximumValue) {
      float proportion = max(abs(this.x), abs(this.y)) / maximumValue;
      this.x /= proportion;
      this.y /= proportion;
    }
  }
}

