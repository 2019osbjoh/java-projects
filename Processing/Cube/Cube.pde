float angle = 0;

PVector[] points = new PVector[8];

void setup() {
  size(680, 460);

  points[0] = new PVector(-0.5, -0.5, -0.5);
  points[1] = new PVector(0.5, -0.5, -0.5);
  points[2] = new PVector(0.5, 0.5, -0.5);
  points[3] = new PVector(-0.5, 0.5, -0.5);
  points[4] = new PVector(-0.5, -0.5, 0.5);
  points[5] = new PVector(0.5, -0.5, 0.5);
  points[6] = new PVector(0.5, 0.5, 0.5);
  points[7] = new PVector(-0.5, 0.5, 0.5);
}

void draw() {
  background(50);
  translate(width / 2, height / 2);


  float[][] rotationZ = {
    {cos(angle), -sin(angle), 0}, 
    {sin(angle), cos(angle), 0}, 
    {0, 0, 1}
  };

  float[][] rotationX = {
    {1, 0, 0}, 
    {0, cos(angle), -sin(angle)}, 
    {0, sin(angle), cos(angle)}
  };

  float[][] rotationY = {
    {cos(angle), 0, -sin(angle)}, 
    {0, 1, 0}, 
    {sin(angle), 0, cos(angle)}
  };

  PVector[] projected = new PVector[8];

  int index = 0;
  for (PVector v : points) {
    PVector rotated = matmul(rotationY, v);
    rotated = matmul(rotationX, rotated);
    rotated = matmul(rotationZ, rotated);
    
    float distance = 2;
    float z = 1 / (distance - rotated.z); 
    float[][] projection = {
      {z, 0, 0}, 
      {0, z, 0}
    };

    PVector projected2d = matmul(projection, rotated);
    projected2d.mult(200);
    projected[index] = projected2d;
    //point(projected2d.x, projected2d.y);
    index++;
  }

  for (PVector v : projected) {
    stroke(180);
    strokeWeight(6);
    noFill();
    point(v.x, v.y);
  }

  for (int i = 0; i < 4; i++) {
    connect(i, (i + 1) % 4, projected);
    connect(i + 4, ((i + 1) % 4) + 4, projected);
    connect(i, i + 4, projected);
  }
  angle += 0.03;
}

void connect(int i, int j, PVector[] points) {
  PVector a = points[i];
  PVector b = points[j];

  strokeWeight(3);
  stroke(180);
  line(a.x, a.y, b.x, b.y);
}
