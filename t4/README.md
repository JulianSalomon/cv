

# Taller Interacción

## Integrantes

| Integrante        | github nick   |
|-------------------|---------------|
| Brayan Garcia     | bsgarciac     |
| Julián Salomón    | JulianSalomon |

## Informe

### Caso de estudio: Sistema Solar

Se decidió crear un modelo del sistema solar para representar las diferentes interacciones:

-  Zoom en el Universo  
- Selección de un planeta 
- Movimiento del ojo a través  del universo
- Rotación del universo
- Traslaciones de los planetas.
- Traslación de la luna.

### Restricciones: 

Para representar de una mejor manera el sistema solar, se tomaron una serie de restricciones:
- El movimiento de los planetas solo puede seguir la trayectoria  de su órbita. (El sol), por otra parte en el caso de la luna, ésta debe hacer su traslación al rededor de la tierra. 
- Siguiendo las leyes de Kepler, todas las órbitas son elípticas, y el planeta está ubicado en uno de los focos de la elipse. 

### Dispositivo usado: Leap Motion 

Es un dispositivo tipo sensor que lee el movimiento de las manos y de los dedos sin necesidad de tener contacto directo, decidimos usarlo porque nos ofrece los 6 grados de libertad que necesitamos para controlar de una manera más fluida nuestra escena del universo.

### Convenciones 

- *Picking:* Gesto de la mano donde el dedo indice y pulgar se tocan mientras los demás permanecen estirados. Similar al simbolo de *Ok*
- *Rojo:* Cursor para la mano izquierda
- *Azul:* Cursor para la mano derecha.
- *Verde:* Cursor haciendo Picking. 
- *Rosado:* Cursor con todos los dedos cerrados.
- *Blanco:* Indica la posición anterior del cursor.

### Interacciones

- **Zoom:** Haciendo *Pick* con ambas manos, se  debe acercarlas o alejarlas del sensor, dependiendo del resultado deseado. Al acercarlas la escena se aleja y al alejarlas la escena se acerca. Consideramos este movimiento intuitivo ya que se asemeja a jalar algún objeto que queramos tener cerca y viceversa. 
- **Mover el cursor:** Aprovechamos el hecho de que se pueden usar las dos manos para tener dos cursores sobre la escena. Moviendo cada mano se puede interactuar con cada cursor. La posición de las manos con respecto al sensor determina la posición del cursor respecto al a escena. 
- **Selección de un planeta:** Manteniendo alguno de los dos cursores sobre un planeta, se cierra la mano para seleccionarlo. Esto nos lleva a una VISTA EN TERCERA PERSONA del planeta
- **Movimiento del ojo:** Se hace *Pick* en cualquier lugar de la escena, de esta manera podemos navegar a través del universo moviendo las manos.
- **Rotación del universo:** Se hace *Pick* con la mano derecha para luego girar la mano izquierda, la dirección en la que se gire la mano será la dirección de rotación.
- **Traslación del planeta o la luna:** Se hace *Pick* con la mano izquierda para luego mover la mano derecha para así trasladar el  objeto través de su respectiva órbita.
- **Resetear el sistema:** Cerrar los dos puños.
