# Proyecto Compiladores

Se implemente el lenguaje definido en el archivo `docs/2021-1Gramatica.pdf`.

## Análisis léxico

La descripción de los requerimientos para la sección de análisis leico se puede encontrar en el archivo `docs/AnalisisLexico.pdf`.

Lo único que vale la pena resaltar de la implementación son las clases léxicas usadas. Éstas están definidas en el archivo `classes.h`. Son las siguientes.

* Literales
  
    | Clase           | ID  |
    | --------------- | --- |
    | Identificarores | 0   |
    | Enteros         | 1   |
    | Flotantes       | 2   |
    | Imaginarios     | 3   |
    | Cadenas         | 4   |
    | Booleanos       | 5   |

* Operadores

    | Clase | ID  |
    | ----- | --- |
    | `+`   | 6   |
    | `-`   | 7   |
    | `!`   | 8   |
    | `*`   | 9   |
    | `&`   | 10  |
    | `.`   | 11  |
    | `/`   | 12  |
    | `%`   | 13  |
    | `=`   | 14  |
    | `==`  | 15  |
    | `!=`  | 16  |
    | `<=`  | 17  |
    | `>=`  | 18  |
    | `<`   | 19  |
    | `>`   | 20  |

* Palabras reservadas

    | Clase      | ID  |
    | ---------- | --- |
    | `if`       | 21  |
    | `else`     | 22  |
    | `break`    | 23  |
    | `switch`   | 24  |
    | `case`     | 25  |
    | `default`  | 26  |
    | `continue` | 27  |
    | `var`      | 28  |
    | `const`    | 29  |
    | `defer`    | 30  |
    | `package`  | 31  |
    | `func`     | 32  |
    | `return`   | 33  |
    | `struct`   | 34  |
    | `for`      | 35  |

* Separadores

    | Clase | ID  |
    | ----- | --- |
    | `(`   | 36  |
    | `)`   | 37  |
    | `[`   | 38  |
    | `]`   | 39  |
    | `{`   | 40  |
    | `}`   | 41  |
    | `;`   | 42  |
    | `,`   | 43  |
    | `:`   | 44  |

* Tipos

    | Clase           | ID  |
    | --------------- | --- |
    | Todos los tipos | 45  |

### Compilar

Se requiere de [`flex`](https://github.com/westes/flex/) para generar el analizador, y de algún compilador de C, por ejemplo [`gcc`](https://gcc.gnu.org/), para compilar el código generado.

```console
$ flex lexer.l
$ gcc lex.yy.c -o lexer
```

### Ejecutar analizador léxico

```console
$ ./lexer <input> <output>
```

Donde `<input>` es el nombre del archivo de entrada, con extensión `.go`.

Y `<output>` es el archivo donde se escribirán los tokens. Debe tener extensión `.tokens`. En este archivos, se escriben los identificadores de las clases léxicas, separados por `#`.

Por ejemplo, el archivo `examples/test.go` que contiene lo siguiente.

```go
package main
    func main(a, b int32) {
        var int32 b
        b = 4 +6/7
        f(2, 4)
        return
    }
    func f(a, b int32) int32 {
        return a +b
    }
```

Se analiza de la siguiente manera

```console
$ ./lexer examples/test.go out.tokens
```

Y produce el siguiente archivo `out.tokens`

```console
#31# #0#
    #32# #0##36##0##43# #0# #0##37# #40#
        #28# #0# #0#
        #0# #14# #1# #6##1##12##1#
        #0##36##1##43# #1##37#
        #33#
    #41#
    #32# #0##36##0##43# #0# #0##37# #0# #40#
        #33# #0# #6##0#
    #41#
```

Donde cada cadena corresponde a su clase léxica definida anteriormente.
