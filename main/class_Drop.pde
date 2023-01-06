float drop_alpha = 0;

class Drop{
  // Retrieved from https://openprocessing.org/sketch/398951
  float x = random(width);
  float y = random(-height, 0);
  float z = random(0, 20);
  float yv = random(60, 65);
  float len = map(z, 0, 20, 90, 100);
  void fall() {
    y += yv;
    yv += 0.2;
    if (y > height) {
      y = random(-height, 0);
      yv = random(60, 65);
    }
  }
  void show() {
    stroke(40, drop_alpha);
    line(x, y, -1, x, y+len, -1);
  }
}