# Visualización de Datos de Uso de la Sitycleta en 2021

**AVISO IMPORTANTE**, por motivos de tamaño no se ha podido subir la **carpeta data** sin comprimir. **ANTES DE EJECUTAR** la aplicación, seleccione el archivo y extráigalo en la misma posición en la que se encuentra.

Autor: Pablo Morales Gómez

Asignatura: Creando Interfaces de Usuario

Curso: 4º


## Introducción

En estea práctica hemos creado un visualizador de datos de uso de la sitycleta en la ciudad de Las Palmas de Gran Canaria durante el año 2021. Para el desarrollo de la misma se ha partido de la base del proyecto [p5_osm_imagen](https://github.com/otsedom/otsedom.github.io/tree/main/CIU/P5) subido dentro del guión de prácticas de la asignatura.


## Desarrollo

La mayor parte del desarrollo se ha centrado en la visualización de los datos, por ello se decidió no tocar la interacción con el mapa que ya venía incluida en el proyecto que se referencia en la introducción.


### Tratamiento de los datos

Antes de comenzar a realizar la programación del proyecto se hizo un pequeño estudio del contenido que encerraba el excel. Tras el cual se advirtió que los datos que se enlazaban en la tarea se encontraban incompletos, solo se recogían datos hasta el mes de agosto. Por este motivo, gracias al portal de datos abiertos de Sagulpa, se recabo la información faltante y se incluyó en el archivo.

Además, previendo futuras aplicaciones se decidió particionar los campos *Start* y *End* en otra serie de columnas que nos servirían para poder llevar a cabo distintas clasificaciones, estas son: *Day*, *Month*, *Year*, *Date*, *Start_Time* y *End_Time*.


### Menú Selector

Para ayudar a los usuarios a mejorar la visualización de los datos se añadió un menú flotante en la esquina superior izquierda. En él, el cliente puede selecccionar la estación de bicicletas de la que desea conocer la información, un intervalo de tiempo y un criterio para hacer dichos intervalos. Los criterios de creación de los intervalos nos permiten crear diferentes divisiones del tiempo para agrupar los viajes que se llevan a cabo en una estación, en el caso concreto de esta práctica podemos ajustar los intervalos para seleccionar los meses del año o, por el contrario, las estaciones. Estas distintas visualizaciones enriquecen la interacción con los datos de las bicis y permiten la detección de patrones de uso con mayor facilidad.

La interacción con este elemento se realiza con las flechas *UP*, *DOWN*, *LEFT* y *RIGHT*. Para que el usuario tuviera una mejor noción de con que parte del selector estaba interactuando, cuando este se encuentra en uno de los subselectores aparecen unos triángulos a izquierda y derecha. 


### Visualización de los Datos

Para visualizar la actividad de una estación en el periodo escogido el cliente debe pulsar la tecla *ENTER* y cuando se desee dejar de verla se deberá volver a pulsar la tecla. Una vez se seleccione se mostrarán siempre los datos de dicha parada hasta que se deseleccione, de esta forma se pueden mostrar simultáneamente los resultados de varias paradas al mismo tiempo y poder hacer visualizaciones más interesantes como por ejemplo: "el uso de las sitycletas en verano de las estaciones que se encuentran por encima del paseo de chill".

Los viajes aparecen representados por líneas que unen la estación seleccionada con aquella a la que se devuelve o, en su defecto se alquila la bicicleta. Las líneas a su vez pueden mostrar dos colores diferentes: representando las rojas aquellos viajes en los que la estación seleccionada es el sitio donde son devueltas y las azules cuando dicha estación es el inicio del trayecto.


## Previsualización del Programa

<p align="center"> <img src="animacion.gif" alt="gif animado" /> </p>
