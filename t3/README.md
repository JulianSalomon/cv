# Taller de representación

## Propósitos

1. Estudiar la relación entre las [aplicaciones de mallas poligonales](https://github.com/VisualComputing/representation), su modo de [representación](https://en.wikipedia.org/wiki/Polygon_mesh) (i.e., estructuras de datos empleadas para representar la malla en RAM) y su modo de [renderizado](https://processing.org/tutorials/pshape/) (i.e., modo de transferencia de la geometría a la GPU).
2. Estudiar algunos tipos de [curvas y superficies paramétricas](https://github.com/VisualComputing/Curves) y sus propiedades.

## Tareas

Empleando el [FlockOfBoids](https://github.com/VisualComputing/frames/tree/master/examples/demos/FlockOfBoids):

1. Represente la malla del [boid](https://github.com/VisualComputing/frames/blob/master/examples/demos/FlockOfBoids/Boid.pde) al menos de dos formas distintas.
2. Renderice el _flock_ en modo inmediato y retenido, implementando la función ```render()``` del [boid](https://github.com/VisualComputing/frames/blob/master/examples/demos/FlockOfBoids/Boid.pde).
3. Implemente las curvas cúbicas de Hermite y Bezier (cúbica y de grado 7), empleando la posición del `frame` del _boid_ como punto de control.

## Opcionales

1. Represente los _boids_ mediante superficies de spline.
2. Implemente las curvas cúbicas naturales.

## Integrantes

Uno, o máximo dos si van a realizar al menos un opcional.

Complete la tabla:


| Integrante 	  | github nick   |
|-----------------|---------------|
| Brayan Garcia   | bsgarciac     |
| Julián Salomón  | JulianSalomon |


## Entrega

* Subir el código al repositorio de la materia antes del 14/10/18 a las 24h.
* Presentar el trabajo en la clase del 17/10/18 o 18/10/18.
