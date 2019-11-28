float MARGIN = 50;
float DOT_SIZE = 100;
float LINE_WEIGHT = 1;

class Dot {
  private float position;
  private float speed;

  private float orientation;
  private float rotation;

  Dot() {
    speed = 0;
    rotation = random(-PI / 100, PI / 100);
    orientation = random(-QUARTER_PI, QUARTER_PI);
    position = random(clearance(), height - clearance());
  }

  float clearance() {
    return (1 + sin(orientation)) * (DOT_SIZE / 2 + LINE_WEIGHT) + MARGIN;
  }

  void update() {
    position += speed;
    orientation += rotation;

    if (position > height - clearance()) {
      speed = abs(speed) * -0.99;

      if (abs(orientation) > QUARTER_PI) {
        rotation *= -0.99;
      }
    } else {
      speed += 0.5;
    }
  }

  void draw(float x) {
    pushMatrix();
    translate(x, position);
    rotate(orientation);
    rect(-DOT_SIZE / 2, -DOT_SIZE / 2, DOT_SIZE, DOT_SIZE);
    popMatrix();
  }
}

Dot[] dots;

void setup() {
  size(1000, 500);
  background(0);

  dots = new Dot[8];
  for (int i = 0; i < dots.length; i++) {
    dots[i] = new Dot();
  }
}

void draw() {
  if (mousePressed) {
    background(0);
  }

  stroke(255, 15);
  strokeWeight(LINE_WEIGHT);
  noFill();

  for (int i = 0; i < dots.length; i++) {
    dots[i].update();
    dots[i].draw(map(i, 0, dots.length - 1, DOT_SIZE / 2 + LINE_WEIGHT + MARGIN, width - DOT_SIZE / 2 - LINE_WEIGHT - MARGIN));
  }
}
