

# Taller Shaders

## Integrantes

| Integrante        | github nick   |
|-------------------|---------------|
| Brayan Garcia     | bsgarciac     |
| Julián Salomón    | JulianSalomon |

## Informe

### Convoluciones usadas

- Repujado
- 3 Tipos de detección de bordes
- Nitidez
- Realzado 


### Interacciones

- **Teclas del 0-5:** Varia el tipo de matriz de  convolución que se está usando. 
- **Cualquier otra tecla:** Usa la matriz identidad para no afectar a la imagen original.  

### Resultados
Después de comparar las imágenes obtenidas usando shaders para el cálculo de la convolución con las imagenés calculadas sin usar shaders (usando solo processing), pudimos notar que en la mayoría de los casos no se puede señalar una gran diferencia, excepto en el segundo tipo de detección de bordes, donde la imagen procesada por el shader muestra un resultado más fuerte, en donde ya la imagen no se puede distinguir. 

En cuanto al tiempo de ejecución también se obtuvieron resultados similares, sin embargo en el grado de dificultad, nos llevó más tiempo implementar los shaders para este procesamiento de imágenes que hacerlo directamente desde Processing.
