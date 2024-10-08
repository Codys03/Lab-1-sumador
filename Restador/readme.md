# ¿Qué es el complemento A 2?

El complemento a 2 es un método utilizado en informática para representar números enteros negativos en sistemas binarios. Es ampliamente utilizado en computadoras debido a su simplicidad para realizar operaciones aritméticas, como la adición y la sustracción.

## ¿Cómo Funciona el Complemento a 2?:
1.  Se comienza con la representación binaria del número positivo que se desea convertir a negativo.
2. Se cambia todos los bits de 0 a 1 y de 1 a 0. Este paso le da el complemento a 1.
3. Finalmente, se suma 1 al resultado del complemento a 1. El resultado es el complemento a 2 del número original, que representa su equivalente negativo.

### Ejemplo:
Apatir de lo explicado se representará el numero -10 en complemento a 2

1. Representación binaria del 10 
```
        10 en binario: 0000 1010
```
2. Complemento a 1

```
        10 en binario: 1111 0101
```
3. Complemento a2 
```    
                       1
                1111 0101
              + 0000 0001
              ------------
                1111 0110
```
## Regla General:

El número de bits (n) determina el rango de valores que puedes representar. En un sistema de n bits:

* Números positivos: Desde 0 hasta 2ⁿ⁻¹ - 1.
* Números negativos: Desde -2ⁿ⁻¹ hasta -1.

Se puede utilizar cualquier cantidad de bits para representar un número en complemento a 2, siempre y cuando tenga en cuenta el rango de números que puede representar con esa cantidad de bits. En sistemas de 4 bits, puede trabajar con números en el rango de -8 a 7, lo que puede ser suficiente para muchas aplicaciones simples.


## ¿Cómo se aplica el complemento a 2 en la resta de binarios?

 En complemento a 2, la suma y la resta de números pueden realizarse sin tener que preocuparse por los signos. Un número negativo sumado a su positivo complementario da como resultado 0.

### Ejemplo
Se plantea realizar la resta de 24 - 10 donde su resultado es 14, representada en binario:

1. Representación de los números en binario
```                        
24 en binario = 0001 1000
-10 en binario = 1111 0110

```

2. Operación suma 
```    
                       
                0001 1000
              + 1111 0110
              ------------
                0000 1110
```
3. Número obtenido en decimal
```               
                   842
              0000 1110

              8+4+2=14              
```
Obteniendo así, gracias al complemento a 2, la resta de números binarios a partir de una simple suma binaria.



# Descripción del Módulo Restador en Verilog

Este módulo Verilog implementa un restador de 4 bits utilizando un sumador de 4 bits y la técnica de complemento a dos para realizar restas.

## Código Verilog

```verilog
`include "sum4b.v"

module Restador(
    input [3:0] A, 
    input [3:0] B,
    output [3:0] Resultado,  // Resultado en binario positivo
    output Signo,  // Indicador de signo: 0 = positivo, 1 = negativo
    input  sel,    // Selector: 0 = suma, 1 = resta
    output C_out   // Carry out
);
    reg [3:0] resul;
    wire [3:0] Suma;
    integer i;

    always @(*) begin  
        // Calcular complemento a uno de B si sel es 1
        for (i = 0; i < 4; i = i + 1) begin
            resul[i] = B[i] ^ sel;
        end
    end

    // Instanciar el sumador de 4 bits
    sum4b S (.A(A), .B(resul), .Ci(sel), .Cout(C_out), .Sum(Suma));

    // El signo se determina por el valor de C_out
    assign Signo = ~C_out;  // Si C_out es 0, significa que hubo borrow, y el resultado es negativo

    // Si el resultado es negativo, obtener el valor absoluto
    assign Resultado = (Signo) ? (~Suma + 1) : Suma;

endmodule
```

## Explicación del Funcionamiento

### Entradas y Salidas
- `A`: Primer operando de 4 bits.
- `B`: Segundo operando de 4 bits.
- `Resultado`: Resultado de la operación en binario positivo.
- `Signo`: Indicador de signo del resultado. 0 indica un resultado positivo, y 1 un resultado negativo.
- `sel`: Selector de operación. Si `sel = 0`, se realiza una suma. Si `sel = 1`, se realiza una resta.
- `C_out`: Indicador de acarreo o préstamo durante la operación de suma/resta.

### Cálculo del Complemento a Dos
El módulo utiliza un ciclo `for` para aplicar una operación XOR entre cada bit de `B` y `sel`. Si `sel = 1`, se genera el complemento a uno de `B` para realizar la resta.

```verilog
always @(*) begin  
    for (i = 0; i < 4; i = i + 1) begin
        resul[i] = B[i] ^ sel;
    end
end
```

### Sumador de 4 Bits
Se instancia un sumador de 4 bits (`sum4b`) que realiza la suma de `A` y el valor calculado `resul`. Dependiendo del valor de `sel`, el sumador realiza una suma normal o una resta.

### Determinación del Signo
El signo del resultado se determina a partir del valor de `C_out`. Si `C_out = 0`, el resultado es negativo (borrow), y si `C_out = 1`, el resultado es positivo.

```verilog
assign Signo = ~C_out;
```

### Cálculo del Valor Absoluto
Si el resultado es negativo, se toma el complemento a dos para obtener el valor absoluto. Si el resultado es positivo, se utiliza directamente el valor de la suma.

```verilog
assign Resultado = (Signo) ? (~Suma + 1) : Suma;
```
## Simulación 
![again](/imagenes/tb_res4.jpeg)


En la simulación presentada, se puede observar la operación de un restador de 4 bits a través de las señales correspondientes a las entradas ``A[3:0]`` y ``B[3:0]``, el resultado ``Resultado[3:0]``, el indicador de signo ``Signo``, y la señal de acarreo de salida ``C_out``. Los valores de las entradas ``A`` y ``B`` se configuran inicialmente como ``A = 4`` (en binario 0100) y ``B = 8`` (en binario 1000), lo que significa que se está realizando la operación ``4−8``.

En la simulación, se observa que:

* El resultado es 4, lo que sugiere que el módulo ha interpretado la resta como negativa y ha tomado el valor absoluto del resultado ``(8 - 4 = 4)``.

* El signo es `` 1``, lo que indica que el resultado de la resta original fue negativo. Dado que ``4−8=−4``, el indicador de signo refleja correctamente este resultado negativo.
* ``C_out`` es ``0``, lo que indica que se ha producido un "borrow" en la operación de resta, ya que el minuendo (A = 4) era menor que el sustraendo (B = 8), lo que requiere un préstamo en el proceso de la operación de resta binaria.

La simulación parece estar funcionando según lo esperado, ya que el indicador de signo refleja correctamente un resultado negativo, y el valor absoluto del resultado también es correcto (4 en lugar de -4, en binario positivo). Sin embargo, es importante notar que ``C_out`` es ``0``, confirmando que en la operación de resta hubo un "borrow", ya que la resta fue de un número menor a uno mayor. Esto implica que la lógica del complemento a dos se está ejecutando correctamente.

### Borrow en Circuitos Lógicos

En el contexto de circuitos digitales, el "borrow" indica que un "préstamo" fue necesario porque la columna de bits del minuendo (el número del que se está restando) era menor que la columna correspondiente del sustraendo (el número que se está restando).

Cuando esto ocurre en una resta de números binarios usando el complemento a dos, el "borrow" puede reflejarse como un bit de acarreo (carry out, ``C_out``) que no es el esperado, o más comúnmente, como un resultado que tiene un bit de signo negativo.

Aquí se muestran mas testbench aplicando restas de manera efectiva 


![simulación](/imagenes/tb_res1%20(1).jpeg)

![simula](/imagenes/tb_res3.jpeg)

De forma mas detallada se muestran las operaciones de forma directa sacadas del codigo del testbench

![op](/imagenes/tb_op%20(1).jpeg)

![op2](/imagenes/tb_op_2.jpeg)