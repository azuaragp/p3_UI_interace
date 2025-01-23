import processing.pdf.*;
import controlP5.*;

ControlP5 cp5; 
PFont fuente;
int numCircles = 8; 
float rotationAngle = 0; 
float distanceToCenter = 126; 
boolean fillCircles = true; 
boolean reverseColors = false; 
float ellipseWidth = 42; 
boolean isAnimating = false; // Control de animación
boolean record_pdf = false; // Variable para controlar la grabación en PDF

void setup() {
  size(700, 700); 
  noStroke(); 
  fill(#55FFAA); 

  fuente = createFont("IBMPlexMono-Medium.ttf", 34); 

  cp5 = new ControlP5(this);

  // Slider para el número de circunferencias
  cp5.addSlider("numCircles")
     .setPosition(28, 28) 
     .setSize(252, 28) 
     .setRange(4, 28) 
     .setValue(8) 
     .setNumberOfTickMarks(6) 
     .setCaptionLabel("CIRCLE NUMBER") 
     .getCaptionLabel()
     .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE)
     .setPaddingY(18); 

  // Slider para la distancia al centro
  cp5.addSlider("distanceToCenter") 
     .setPosition(28, 100) 
     .setSize(252, 28)
     .setRange(30, 185) 
     .setValue(60) 
     .setNumberOfTickMarks(12) 
     .setCaptionLabel("DISTANCE TO CENTER") 
     .getCaptionLabel()
     .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE)
     .setPaddingY(18); 
     
  // Knob para la rotación
  cp5.addKnob("rotationAngle")
     .setPosition(28, 180) 
     .setRadius(70) 
     .setRange(0, 360) 
     .setValue(0) 
     .setCaptionLabel("ROTATION") 
     .getCaptionLabel()
     .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE); 
     
  // Knob para el ancho de las elipses
  cp5.addKnob("ellipseWidth")
     .setPosition(28, 350) 
     .setRadius(70)
     .setRange(40, 140) 
     .setValue(90) 
     .setCaptionLabel("ELLIPSE WIDTH") 
     .getCaptionLabel()
     .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE); 

  // Toggle para relleno
  cp5.addToggle("fillCircles")
     .setPosition(30, 540) 
     .setSize(70, 28)
     .setValue(true) 
     .setMode(ControlP5.SWITCH) 
     .setCaptionLabel("FILL CIRCLES") 
     .getCaptionLabel()
     .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE)
     .setPaddingY(18); 

  // Toggle para invertir colores
  cp5.addToggle("reverseColors")
     .setPosition(150, 540) 
     .setSize(70, 28)
     .setValue(false) 
     .setMode(ControlP5.SWITCH) 
     .setCaptionLabel("REVERSE COLORS") 
     .getCaptionLabel()
     .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE)
     .setPaddingY(18); 
     
  cp5.addBang("guarda_pdf")
     .setPosition(150, 630)
     .setSize(90, 30)
     .setTriggerEvent(Bang.RELEASE)
     .setLabel("EXPORT PDF");
   
  cp5.addBang("guarda_png")
     .setPosition(30, 630)
     .setSize(90, 30)
     .setTriggerEvent(Bang.RELEASE)
     .setLabel("EXPORT PNG");
}

void draw() {
  if (record_pdf) {
    beginRecord(PDF, "cercles-" + frameCount + ".pdf");
  }
  
  if (reverseColors) {
    background(#55FFAA); 
    fill(0); 
    stroke(0); 
  } else {
    background(0); 
    fill(#55FFAA); 
    stroke(#55FFAA);
  }

  if (isAnimating) {
    rotationAngle += 1.5; 
  }

  // Centro de las elipses
  float centerX = width / 1.6; 
  float centerY = height / 1.8; 

  for (int i = 0; i < numCircles; i++) {
    float angle = TWO_PI / numCircles * i + radians(rotationAngle);

    float x = centerX + cos(angle) * distanceToCenter; 
    float y = centerY + sin(angle) * distanceToCenter; 

    pushMatrix();
    translate(centerX, centerY);
    rotate(angle);
    translate(distanceToCenter, 0);

    if (fillCircles) {
      noStroke();
      ellipse(0, 0, ellipseWidth, 42); 
    } else {
      noFill();
      ellipse(0, 0, ellipseWidth, 42); 
    }
    popMatrix();
  }

  if (record_pdf) {
    endRecord();
    record_pdf = false;
  }

  // Título
  fill(reverseColors ? 0 : #55FFAA); 
  textFont(fuente); 
  textAlign(RIGHT, TOP); 
  text("DIGITAL GARDEN", width - 28, 28); 
}

void keyPressed() {
  if (key == ' ') {
    isAnimating = !isAnimating; 
  }
}

void guarda_pdf() {
  record_pdf = true;
}

void guarda_png() {
  save("digitalGarden-" + frameCount + ".png");
}
