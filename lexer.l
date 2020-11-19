%{
    #include "classes.h"

    int linea = 1;
%}

%option noyywrap

%x CADENA
%x STRINGML

espacio [ \t]

int_type    (uint8|uint16|int8|int16|int32)
float_type  (float32|float64|complex64)
type        ({int_type}|{float_type}|byte|string|bool)

bool (true|false)

digit   [0-9]
id_init [a-zA-Z_]
id      {id_init}({id_init}|{digit})*

int           (0(_0)*|[1-9]([_]?{digit})*)
simple_float  ({int}\.{int}?|\.{int})
exp_end       [Ee][+-]?([0-9]([_]?{digit})*)
exp           ({digit}|{digit}\.{int}?|\.{int}){exp_end}

float   ({exp}|{simple_float})
complex ({int}|{float})i

%%

` {BEGIN(STRINGML);}
<STRINGML>\n {linea++;}
<STRINGML>` {
  fprintf(yyout, "#%d#", STRING);
  BEGIN(INITIAL);
}

\" {BEGIN(CADENA);}
<CADENA>\" {
  fprintf(yyout, "#%d#", STRING);
  BEGIN(INITIAL);
}
<CADENA>\n {
  printf("Error: Salto de linea no válido. Linea: %d\n", linea);
  yyterminate();
}
<CADENA,STRINGML><<EOF>> {
  printf("Error: Cadena sin cerrar. Linea: %d\n", linea);
  yyterminate();
}
<CADENA>\\(.) {}
<STRINGML,CADENA>. {}

if        {fprintf(yyout, "#%d#", IF);}
else      {fprintf(yyout, "#%d#", ELSE);}
break     {fprintf(yyout, "#%d#", BREAK);}
switch    {fprintf(yyout, "#%d#", SWITCH);}
case      {fprintf(yyout, "#%d#", CASE);}
default   {fprintf(yyout, "#%d#", DEFAULT);}
continue  {fprintf(yyout, "#%d#", CONTINUE);}
var       {fprintf(yyout, "#%d#", VAR);}
const     {fprintf(yyout, "#%d#", CONST);}
defer     {fprintf(yyout, "#%d#", DEFER);}
package   {fprintf(yyout, "#%d#", PACKAGE);}
func      {fprintf(yyout, "#%d#", FUNC);}
return    {fprintf(yyout, "#%d#", RETURN);}
struct    {fprintf(yyout, "#%d#", STRUCT);}
for       {fprintf(yyout, "#%d#", FOR);}

"+"   {fprintf(yyout, "#%d#", PLUS);}
"-"   {fprintf(yyout, "#%d#", MINUS);}
"!"   {fprintf(yyout, "#%d#", NEG);}
"*"   {fprintf(yyout, "#%d#", STAR);}
"&"   {fprintf(yyout, "#%d#", AMP);}
"."   {fprintf(yyout, "#%d#", DOT);}
"/"   {fprintf(yyout, "#%d#", DIAG);}
"%"   {fprintf(yyout, "#%d#", REM);}
"="   {fprintf(yyout, "#%d#", ASSIG);}

"=="  {fprintf(yyout, "#%d#", EQ);}
"!="  {fprintf(yyout, "#%d#", NEQ);}
"<="  {fprintf(yyout, "#%d#", LEQ);}
">="  {fprintf(yyout, "#%d#", GEQ);}
"<"   {fprintf(yyout, "#%d#", LE);}
">"   {fprintf(yyout, "#%d#", GE);}

"(" {fprintf(yyout, "#%d#", LPAR);}
")" {fprintf(yyout, "#%d#", RPAR);}
"[" {fprintf(yyout, "#%d#", LBRA);}
"]" {fprintf(yyout, "#%d#", RBRA);}
"{" {fprintf(yyout, "#%d#", LCURL);}
"}" {fprintf(yyout, "#%d#", RCURL);}
";" {fprintf(yyout, "#%d#", SC);}
":" {fprintf(yyout, "#%d#", DDOT);}
"," {fprintf(yyout, "#%d#", COMMA);}

{type}    {fprintf(yyout, "#%d#", TYPE);}
{bool}    {fprintf(yyout, "#%d#", BOOL);}
{float}   {fprintf(yyout, "#%d#", FLOAT);}
{int}     {fprintf(yyout, "#%d#", INT);}
{complex} {fprintf(yyout, "#%d#", IM);}
{id}      {fprintf(yyout, "#%d#", ID);}

{espacio}+ { fprintf(yyout, "%s", yytext); }
. {
  printf("Error: %s Linea: %d\n", yytext, linea);
  yyterminate();
}

\n {
  linea++;
  fprintf(yyout, "\n");
}

%%

int check_ext(char *s, const char *ext) {
  char *e = strrchr(s, '.');
  if(!e || strcmp(e+1, ext)) {
    printf("Extension del archivo debe ser .%s\n", ext);
    return -1;
  }
  return 0;
}

int main(int argc, char *argv[]) {
  if(argc < 3) {
    puts("Se necestian dos archivos de entrada");
    return -1;
  }
  if(check_ext(argv[1], "go")==-1) return -1;
  if(check_ext(argv[2], "tokens")==-1) return -1;

  yyin = fopen(argv[1], "r");
  yyout = fopen(argv[2], "w");
  yylex();
  fclose(yyin);
  fclose(yyout);
  return 0;
}
