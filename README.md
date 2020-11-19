# Proyecto Compiladores

Se implemente el lenguaje definido en el archivo `docs/2021-1Gramatica.pdf`.

## Análisis léxico

La descripción de los requerimientos para la sección de análisis leico se puede
encontrar en el archivo `docs/AnalisisLexico.pdf`.

### Compilar

Se requiere de [`flex`](https://github.com/westes/flex/) para generar el
analizador, y de algún compilador de C, por ejemplo
[`gcc`](https://gcc.gnu.org/) para compilar el código generado.

```console
$ lex lexer.l
...
$ gcc lex.yy.c -o lexer
...
```

### Ejecutar analizador léxico

```console
$ ./lexer <input> <output>
...
```

Donde `<input>` es el nombre del archivo de entrada, con extensión `.art`.

Y `<output>` es el archivo donde se escribirán los tokens. Debe tener extensión
`.tokens`.
