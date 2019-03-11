PImage img;
PShape texImg;

PShader texShader;

void setup() {
  size(720,720, P2D);
  img = loadImage("brayan.jpg");
  texImg = createShape(img);
  texShader = loadShader("normal.glsl");
}

void draw() {
  background(0);
  shader(texShader);
  shape(texImg);
}

PShape createShape(PImage tex) {
  textureMode(NORMAL);
  PShape shape = createShape();
  shape.beginShape();
  shape.noStroke();
  textureMode(NORMAL);
  shape.texture(tex);
  shape.vertex(0, 0, 0, 0);
  shape.vertex(width, 0, 1, 0);
  shape.vertex(width, height, 1, 1);
  shape.vertex(0, height, 0, 1);
  shape.endShape();
  return shape;
}

void keyPressed() {
  if (key == '0') {  //Sharpness
     texShader = loadShader("sharpness.glsl");
  }else if(key == '1'){ //Edge detection 1
    texShader = loadShader("edge1.glsl");
  }else if(key == '2'){ //Edge detection 2
    texShader = loadShader("edge2.glsl");
  }else if(key == '3'){ //Edge detection 3
    texShader = loadShader("edge3.glsl");
  }else if(key == '4'){ //Emboss
    texShader = loadShader("emboss.glsl");
  }else if(key == '5'){ //Repujado
   texShader = loadShader("repujado.glsl");
  }else{ //Normal
    texShader = loadShader("normal.glsl");
  }
}
