# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo; y,
2. Sombrear su superficie a partir de los colores de sus vértices.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Opcionales:

1. Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas; y,
2. Sombrear su superficie mediante su [mapa de profundidad](https://en.wikipedia.org/wiki/Depth_map).

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/frames/releases).

## Integrantes

Dos, o máximo tres si van a realizar al menos un opcional.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|   Brayan Garcia         |    bsgarciac         |
|   Julián Salomón         |   JulianSalomon          |

## Interacción

'a': Activar/Desactivar el antialiasing.</br>
'w': Aumentar el nivel de suavizado.</br>
's': Disminuir el nivel de suavizado.</br>

## Discusión

Luego de realizados los ejercicios propuestos pudimos sacar las siguientes conclusiones:
1) La calidad en la representación de una figura, en este caso del triangulo, se ve muy afectada por la distancia del observador y la cantidad de pixeles usados. En el ejercicio, cuando alejabamos el punto de vista se podia ver el triangulo más claramente, sin tener que usar las ayudas visuales; y además sus bordes se hacían cada vez más rectos. 
2) Esteticamente el antialiasing es una gran ayuda ya que al suavizar los bordes de la figura, esta se puede observar más claramente, a pesar de la distancia del observador. 
3) El Anti-aliasing implica más operaciones, por ende requiere mayor poder de computo. Pudimos observar una caida leve en el rendimiento cuando el antialising estaba activo, por esta razón infinidad de juegos tienen opciones para desactivarlo y así mejorar los FPS y la experiencia de usuario.

- Anti-aliasing: </br>
Descubrimos que existen diversos algoritmos de Anti-aliasing, los cuales cuentan con enfoques diferentes y dependiendo el contexto algunos son mejores que otros.
 Primero empezamos a mirar el algoritmo de linea de  [Xiaolin Wu's](https://en.wikipedia.org/wiki/Xiaolin_Wu%27s_line_algorithm), el cual consiste en movernos a través de una linea y pintar pixeles en escala de grises a su alrededor, estando los pixeles blancos más lejos de la linea y los negros más cerca. El problema es que al no contar con una linea como tal, no lo vimos muy útil en el ejercicio, además de que el suavizado no tiene en cuenta el sombreado del color de los vertices.</br>
Luego decidimos usar la idea con la que trabaja [FAA](https://en.wikipedia.org/wiki/Fast_approximate_anti-aliasing), la cual es moverse por el borde de la figura mientras se va suavizando cada pixel. Nos pareció esta aproximación perfecta para el ejercicio, ya que al suavizar cada pixel, podiamos seguir manteniendo el sombreado de los colores de los vertices. 

## Entrega

* Modo de entrega: [Fork](https://help.github.com/articles/fork-a-repo/) la plantilla en las cuentas de los integrantes.
* Plazo: 30/9/18 a las 24h.
