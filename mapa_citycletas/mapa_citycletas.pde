import java.util.Date;

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

// Fechas para comprobar en que estacion ocurrio el prestamo de las bicis
Date autumn = new Date(2021, 9, 23);
Date winter = new Date(2021, 12, 21);
Date firstDateOfYear = new Date(2021, 1, 1);
Date lastDayOfYear = new Date(2021, 12, 31);
Date spring = new Date(2021, 3, 21);
Date summer = new Date(2021, 6, 21);

// Strings que se visualizarán en el selector
String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
String[] season = {"Autumn", "Winter", "Spring", "Summer"};
String[] criteria = {"Months", "Seasons"};

// Variables de flujo que nos marcan el estado de la app
int selectionMode = 0;
int selectedMonth = 1;
int selectedStation = 0;
int selectedSeason = 0;
int selectedCriteria = 0;

// Almacenamos las estaciones que se quieren visualizar
ArrayList<Integer> stationShow = new ArrayList<Integer>();


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
  
  // Reset the app
  if (key == 'r' || key == 'R') {
    selectionMode = 0;
    selectedMonth = 1;
    selectedStation = 0;
    selectedSeason = 0;
    selectedCriteria = 0;
    stationShow.clear();
    createLienzo();
  }
  
  // Show/hide travels of the selected station
  if (key == ENTER) {
    if(stationShow.contains(selectedStation)) {
      stationShow.remove(Integer.valueOf(selectedStation));
    } else {
      stationShow.add(selectedStation);
    }
    createLienzo();
  }
  
  // Change between selection menus
  if (key == CODED && keyCode == DOWN) {
    selectionMode++;
    if(selectionMode > 2) selectionMode = 0;
  }
  if (key == CODED && keyCode == UP) {
    selectionMode--;
    if(selectionMode < 0) selectionMode = 2;
  }
  
  // Change the selected value in the menus (depends on which menu is selected
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
     if(selectedCriteria == 0) {
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
        
     } else  {
        if (key == CODED && keyCode == RIGHT) {
          selectedSeason++;
          if(selectedSeason > season.length - 1) selectedSeason = 0;
          createLienzo();
        } 
        if (key == CODED && keyCode == LEFT) {
          selectedSeason--;
          if(selectedSeason < 0) selectedSeason = season.length - 1;
          createLienzo();
        } 
     }
      break;
    case 2:
      if (key == CODED && keyCode == RIGHT) {
        selectedCriteria++;
        if(selectedCriteria > criteria.length - 1) selectedCriteria = 0;
        createLienzo();
      } 
      if (key == CODED && keyCode == LEFT) {
        selectedCriteria--;
        if(selectedCriteria < 0) selectedCriteria = criteria.length - 1;
        createLienzo();
      } 
  }
}

// Zoom
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom += e/10;
  if (zoom<1)
    zoom = 1;
}

// Dibujamos el rectangulo y el texto con todo lo que contienen
void showText() {
  fill(200);
  rect(width/30, height/30, width/5*2, height/30 * 18);
  fill(0);
  
  // Dibujamos triangulos para ayudar al usuario a saber donde se encuentra
  switch(selectionMode) {
    case 0:
      triangle(width/29 *1.5, height/29 * 2.83, width/29 *1.7, height/29 * 3.03,  width/29 *1.7, height/29 * 2.63);
      triangle(width/5*2 - (width/30 - width/29*1.5), height/29 * 2.83, width/5*2 - (width/30 - width/29*1.3), height/29 * 3.03,width/5*2 - (width/30 - width/29*1.3), height/29 * 2.63);
      break;
    case 1:
      triangle(width/29 *1.5, height/29 * 5.83, width/29 *1.7, height/29 * 6.03,  width/29 *1.7, height/29 * 5.63);
      triangle(width/5*2 - (width/30 - width/29*1.5), height/29 * 5.83, width/5*2 - (width/30 - width/29*1.3), height/29 * 6.03,width/5*2 - (width/30 - width/29*1.3), height/29 * 5.63);
      break;
    case 2:
      triangle(width/29 *1.5, height/29 * 8.83, width/29 *1.7, height/29 * 9.03,  width/29 *1.7, height/29 * 8.63);
      triangle(width/5*2 - (width/30 - width/29*1.5), height/29 * 8.83, width/5*2 - (width/30 - width/29*1.3), height/29 * 9.03,width/5*2 - (width/30 - width/29*1.3), height/29 * 8.63);
      break;
  }
 
  text("SELECTED STATION", width/29 *4, height/29 * 2);
  text(nombres[selectedStation], width/29 *2, height/29 * 3);
  
  if (selectedCriteria == 0) {
    text("SELECTED MONTH", width/29 *4, height/29 * 5); 
    text(months[selectedMonth-1], width/29 *2, height/29 * 6);
  } else {
    text("SELECTED SEASON", width/29 *4, height/29 * 5); 
    text(season[selectedSeason], width/29 *2, height/29 * 6);
  }
  
  text("SELECT SELECTION CRITERIA",  width/29 *3, height/29 * 8);
  text(criteria[selectedCriteria], width/29 *2, height/29 * 9);
  
  text("INSTRUCTIONS",  width/29 * 4.5, height/29 * 11);
  
  text("Press R to reset.", width/29 *2, height/29 * 12);
  text("Use the mouse to interact with the map.", width/29 *2, height/29 * 13);
  text("Use the keyboard arrows to navigate", width/29 *2, height/29 * 14);
  text("the menu.", width/29 *2, height/29 * 15);
  text("Press ENTER to show/hide the travels ", width/29 *2, height/29 * 16);
  text("of a station. ", width/29 *2, height/29 * 17);
  //of a station.
  

  
}

// Metodo auxiliar para detectar con que estacion (su indice) se une la seleccionada y asi poder trazar la linea
int getIndexStation(String stationName) {
  for(int i = 0; i < nombres.length; i++) {
    if(stationName.equals(nombres[i])) return i;
  }
  return 0;
}

// Se ha sacado la bici de esa estación
void drawRentalPlaceTravels(TableRow travels, int station) {
    if(travels.getString("Rental_Place").equals(nombres[station])) {
       int otherStationIndex = getIndexStation(travels.getString("Return_Place"));
       lienzo.stroke(0, 0, 128);
       lienzo.strokeWeight(0.4);
       lienzo.line(stationX[station], stationY[station], stationX[otherStationIndex], stationY[otherStationIndex]);
    }
}

// Se ha devuelto la bici de esa estación
void drawReturnPlaceTravels(TableRow travels, int station) {

  if(travels.getString("Return_Place").equals(nombres[station])) {
    int otherStationIndex = getIndexStation(travels.getString("Rental_Place"));
    lienzo.stroke(128, 0, 0);
    lienzo.strokeWeight(0.4);
    lienzo.line(stationX[station], stationY[station], stationX[otherStationIndex], stationY[otherStationIndex]);
  }
}

// draw travels of the selected season
void drawTravelsSeason() {

  for(int i = 0; i < stationShow.size(); i++) {
    int station = stationShow.get(i);
    
    for (TableRow travels : Uso_Citycletas.rows()) {
      
      Date fechaPrestamo = new Date(2021, int(travels.getString("Month")), int(travels.getString("Day")));
      
      switch(selectedSeason) {
        case 0:  //Otoño
          if(fechaPrestamo.after(autumn) && fechaPrestamo.before(winter) || autumn.equals(fechaPrestamo)) {
            drawRentalPlaceTravels(travels, station);
            drawReturnPlaceTravels(travels, station);
            
          }
          break;
          
        case 1:  //Invierno
          if(fechaPrestamo.after(firstDateOfYear) && fechaPrestamo.before(spring) || fechaPrestamo.after(winter) && fechaPrestamo.before(lastDayOfYear) || winter.equals(fechaPrestamo) || firstDateOfYear.equals(fechaPrestamo) || lastDayOfYear.equals(fechaPrestamo)) {
            drawRentalPlaceTravels(travels, station);
            drawReturnPlaceTravels(travels, station);
            //fechaPrestamo.after(winter) && fechaPrestamo.before(lastDayOfYear) || winter.equals(fechaPrestamo) || 
          }
          break;
        case 2:  //Primavera
          if(fechaPrestamo.after(spring) && fechaPrestamo.before(summer) || spring.equals(fechaPrestamo)) {
            drawRentalPlaceTravels(travels, station);
            drawReturnPlaceTravels(travels, station);
            
          }
          break;
          
        case 3:  //Verano
          if(fechaPrestamo.after(summer) && fechaPrestamo.before(autumn) || summer.equals(fechaPrestamo)) {
            drawRentalPlaceTravels(travels, station);
            drawReturnPlaceTravels(travels, station);
            
          }
          break;
        
      } 
    }
  }
}

// draw travels of the selected month
void drawTravelsMonth() {
  for(int i = 0; i < stationShow.size(); i++) {
      
    int station = stationShow.get(i);
    
     for (TableRow travels : Uso_Citycletas.rows()) {
       
       if(int(travels.getString("Month")) == selectedMonth) {
         
         drawRentalPlaceTravels(travels, station);
         drawReturnPlaceTravels(travels, station);
       }
    }
  }
}

// Draw the map, stations and travels 
void createLienzo() {
  lienzo = createGraphics(img.width ,img.height);
  
  lienzo.beginDraw();
  lienzo.image(img, 0,0,img.width,img.height); 
  
  if(selectedCriteria == 0) {
    drawTravelsMonth();
  } else {
    drawTravelsSeason();
  }
    
  for(int i =  0; i < Estaciones.getRowCount(); i++) {
    lienzo.noStroke();
    
    if(i == selectedStation) {
      lienzo.fill(255, 128, 0);
      lienzo.stroke(0);
      lienzo.ellipse(stationX[i], stationY[i], radio*3, radio*3); 
    } else if(stationShow.contains(i)) {
      lienzo.fill(250, 0, 216);
      lienzo.stroke(0);
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
