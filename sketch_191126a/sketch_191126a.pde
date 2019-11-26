int Z_RANGE = 100;
int BOX_SIZE = 100;
int N_BOXES = 10;
int MAX_VELOCITY = 15;

float symmRand(float range) {
  return random(range * 2) - range;
}

class Box {
  private PVector position;
  private PVector velocity;

  private PVector orientation;
  private PVector rotation;

  Box() {
    position = new PVector(random(width), random(height), symmRand(Z_RANGE));
    velocity = PVector.random3D().mult(random(5));

    orientation = new PVector(symmRand(PI), symmRand(PI), symmRand(PI));
    rotation = new PVector(symmRand(PI / 100.), symmRand(PI / 100.), symmRand(PI / 100.));
  }

  void move() {
    position.add(velocity);
    orientation.add(rotation);
  }

  void checkBounds() {
    if (position.x + BOX_SIZE / 2 >= width || position.x <= BOX_SIZE / 2) {
      velocity.x = -velocity.x;
      rotation.y = -rotation.y;
      rotation.z = -rotation.z;
    }

    if (position.y + BOX_SIZE / 2 >= height || position.y <= BOX_SIZE / 2) {
      velocity.y = -velocity.y;
      rotation.x = -rotation.x;
      rotation.z = -rotation.z;
    }

    if (abs(position.z) >= Z_RANGE) {
      velocity.z = -velocity.z;
      rotation.x = -rotation.x;
      rotation.y = -rotation.y;
    }
  }

  void collideWith(Box other) {
    PVector difference = PVector.sub(position, other.position);
    if (difference.mag() <= BOX_SIZE) {
      PVector normed = difference.normalize();
      PVector myProjection = PVector.mult(normed, PVector.dot(velocity, difference) / difference.magSq());
      PVector otherProjection = PVector.mult(normed, PVector.dot(other.velocity, difference) / difference.magSq());

      velocity.sub(myProjection).add(otherProjection).limit(MAX_VELOCITY);
      other.velocity.sub(otherProjection).add(myProjection).limit(MAX_VELOCITY);
    }
  }

  void draw() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateX(orientation.x);
    rotateY(orientation.y);
    rotateZ(orientation.z);
    box(BOX_SIZE);
    popMatrix();
  }
}

Box[] myBoxes;

void setup() {
  size(750, 750, P3D);
  colorMode(HSB);

  myBoxes = new Box[N_BOXES];
  for (int i = 0; i < myBoxes.length; i++) {
    myBoxes[i] = new Box();
  }

  background(0);
}

void draw() {
  int hueSeed = millis() / 100;

  for (int i = 0; i < myBoxes.length; i++) {
    myBoxes[i].move();
    myBoxes[i].checkBounds();
  }

  for (int i = 0; i < myBoxes.length; i++) {
    for (int j = i + 1; j < myBoxes.length; j++) {
      myBoxes[i].collideWith(myBoxes[j]);
    }
  }

  if (mousePressed) {
    background(0);
  }

  for (int i = 0; i < myBoxes.length; i++) {
    float hueVal = hueSeed + map(i, 0, myBoxes.length, 0, 255);
    stroke(hueVal % 255, 127, 127, 63);
    fill((hueVal + 127) % 255, 127, 255, 63);

    myBoxes[i].draw();
  }
}
