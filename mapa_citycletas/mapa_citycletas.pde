float[] stationX, stationY;
String[] nombres;

PGraphics lienzo;
PImage img;
Table Estaciones, Uso_Citycletas;

float radio = 3;
// Variables para las transformaciones
float zoom = 1;
int x = 0;
int y = 0;

String[] months = {"January", "February", "March", "April", "May", "June", "July", "August"};
int selectionMode = 0;
int selectedMonth = 1;
int selectedStation = 0;



void setup() {
  size(700, 700, P3D);
  
  // Cargamos la información de las tablas
  Estaciones = loadTable("Geolocalización estaciones sitycleta.csv", "header");
  Uso_Citycletas = loadTable("citycleta-2021.csv", "header");

  img = loadImage("mapaLPGC.png");

  getPositionAndNameOfStations();
  createLienzo();
}

void draw() {
  background(220);
  
  if (mousePressed && mouseButton == LEFT) {
    x += (mouseX - pmouseX)/zoom;
    y += (mouseY - pmouseY)/zoom;
  }
  
  pushMatrix();
  
  translate(width/2,height/2,0);
  scale(zoom);

  translate(-img.width/2+x,-img.height/2+y, 0);
  image(lienzo, 0,0);
  
  popMatrix();

  showText();
  
}

void keyPressed() {
  
  if (key == CODED && keyCode == UP) {
    selectionMode++;
    if(selectionMode > 1) selectionMode = 0;
  }
  if (key == CODED && keyCode == DOWN) {
    selectionMode--;
    if(selectionMode < 0) selectionMode = 1;
  }
  
  switch(selectionMode) {
    case 0:
      if (key == CODED && keyCode == RIGHT) {
        selectedStation++;
        if(selectedStation == Estaciones.getRowCount()) selectedStation = 0;
        createLienzo();
      } 
      if (key == CODED && keyCode == LEFT) {
        selectedStation--;
        if(selectedStation < 0) selectedStation = Estaciones.getRowCount() - 1;
        createLienzo();
      } 
      break;
   case 1:
      if (key == CODED && keyCode == RIGHT) {
        selectedMonth++;
        if(selectedMonth > months.length) selectedMonth = 1;
        createLienzo();
      } 
      if (key == CODED && keyCode == LEFT) {
        selectedMonth--;
        if(selectedMonth < 1) selectedMonth = months.length;
        createLienzo();
      } 
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom += e/10;
  if (zoom<1)
    zoom = 1;
}

void showText() {
  fill(200);
  rect(width/30, height/30, width/5*2, height/30 * 15);
  fill(0);
  text("SELECTED STATION", width/29 *4, height/29 * 2);
  text(nombres[selectedStation], width/29 *2, height/29 * 3);
  text("SELECTED MONTH", width/29 *4, height/29 * 5);
  text(months[selectedMonth-1], width/29 *2, height/29 * 6);
}

int getIndexStation(String stationName) {
  for(int i = 0; i < nombres.length; i++) {
    if(stationName.equals(nombres[i])) return i;
  }
  return 0;
}

void getTravelsOfStation() {
   for (TableRow travels : Uso_Citycletas.rows()) {
     
     if(int(travels.getString("Month")) == selectedMonth) {
       
       // Se ha sacado la bici de esa estación
       if(travels.getString("Rental_Place").equals(nombres[selectedStation])) {
         
         int otherStationIndex = getIndexStation(travels.getString("Return_Place"));
         lienzo.stroke(0, 0, 128);
         lienzo.strokeWeight(0.2);
         lienzo.line(stationX[selectedStation], stationY[selectedStation], stationX[otherStationIndex], stationY[otherStationIndex]);
       }
       
        // Se ha devuelto la bici de esa estación
       if(travels.getString("Return_Place").equals(nombres[selectedStation])) {
         int otherStationIndex = getIndexStation(travels.getString("Rental_Place"));
         lienzo.stroke(128, 0, 0);
         lienzo.strokeWeight(0.2);
         lienzo.line(stationX[selectedStation], stationY[selectedStation], stationX[otherStationIndex], stationY[otherStationIndex]);
       }
     }
  
  }
}

void createLienzo() {
  lienzo = createGraphics(img.width ,img.height);
  
  lienzo.beginDraw();
  lienzo.image(img, 0,0,img.width,img.height); 
  
  getTravelsOfStation();
  
  for(int i =  0; i < Estaciones.getRowCount(); i++) {
    lienzo.noStroke();
    
    if(i == selectedStation) {
      lienzo.fill(255, 128, 0);
      lienzo.ellipse(stationX[i], stationY[i], radio*3, radio*3); 
    } else {
      lienzo.fill(0,100,0);
      lienzo.ellipse(stationX[i], stationY[i], radio*2, radio*2); 
    }
    
    lienzo.fill(0,0,0);
  }
  
  lienzo.endDraw();
}

// Extraemos la información que necesitamos de la tabla estaciones
void getPositionAndNameOfStations() {
  float[] lats = new float[Estaciones.getRowCount()];
  float[] lons = new float[Estaciones.getRowCount()];
  nombres = new String[Estaciones.getRowCount()];
  
  // Rellenamos los arrays con la info de "Geolocalización estaciones sitycleta.csv"
  int index = 0;
  for (TableRow est : Estaciones.rows()) {
    nombres[index] = est.getString("nombre");
    lats[index] = float(est.getString("latitud"));
    lons[index] = float(est.getString("altitud"));
    index++;
  }
  
  // Traducimos las longitudes y latitudes a posiciones en el mapa
  stationX = new float[index];
  stationY = new float[index];

  for (int i = 0; i < index; i++){    
    stationX[i] = map(lons[i], -15.5304, -15.3656, 0, img.width);
    stationY[i] = map(lats[i], 28.1817, 28.0705, 0, img.height);
  }
  
}
