
/*    example.l
 
 	Example of a lex specification file.
     
      To create the lexical analyzer:

      flex example.l
      g++ lex.yy.c -o lexer
      lexer < inputFileName
*/

%{

%}

/* Defintions of regular expressions go here */

WSPACE		      [ \t\v\r]+
NEWLINE         \n
COMMENT         ;.*

DIGIT	          [0-9]
LETTER          [a-zA-Z]

IDENT			      [_a-zA-Z][a-zA-Z0-9_]* 
INTCONST        [ +-]{DIGIT}+
STRCONST        \".*\"
INT             [0-9]*


%%

"lambda"        {
                printTokenInfo("LAMBDA", yytext);
                return IDENT;
} 
"let*"          {
                printTokenInfo("LETSTAR", yytext);
                return IDENT;
}
"("             {
                printTokenInfo("LPAREN", yytext);
                return IDENT;
}
")"             {
                printTokenInfo("RPAREN", yytext);
                return IDENT;
}
"input"         {
                printTokenInfo("INPUT", yytext);
                return IDENT;
}
"print"         {
                printTokenInfo("PRINT", yytext);
                return IDENT;
}
"if"            {
                printTokenInfo("IF", yytext);
                return IDENT;
}
"+"             {
                printTokenInfo("ADD", yytext);
                return IDENT;
}
"*"             {
                printTokenInfo("MULT", yytext);
                return IDENT;
}
"/"             {
                printTokenInfo("DIV", yytext);
                return IDENT;
}
"-"             {
                printTokenInfo("SUB", yytext);
                return IDENT;
}
"and"           {
                printTokenInfo("AND", yytext);
                return IDENT;
}
"or"            {
                printTokenInfo("OR", yytext);
                return IDENT;
}
"not"           {
                printTokenInfo("NOT", yytext);
                return IDENT;
}
"<"             {
                printTokenInfo("LT", yytext);
                return IDENT;
}
">"             {
                printTokenInfo("GT", yytext);
                return IDENT;
}
"<="            {
                printTokenInfo("LE", yytext);
                return IDENT;
}
">="            {
                printTokenInfo("GE", yytext);
                return IDENT;
}
"="             {
                printTokenInfo("EQ", yytext);
                return IDENT;
}
"/="            {
                printTokenInfo("NE", yytext);
                return IDENT;
}
"t"             {
                printTokenInfo("T", yytext);
                return IDENT;
}
"nil"           {
                printTokenInfo("NIL", yytext);
                return IDENT;
}
{IDENT}         {
                printTokenInfo("IDENT", yytext);
                return STRCONST;
}
{STRCONST}      {
                printTokenInfo("STRCONST", yytext);
                return STRCONST;
}
{INTCONST}	    {
				printTokenInfo("INTCONST", yytext);
				return INTCONST;
}
{INT}           {
				printTokenInfo("INTCONST", yytext);
				return INTCONST;
}
{NEWLINE}		    { }
{COMMENT}       { }
{WSPACE}		    { }
.			          {
				printTokenInfo("UNKNOWN", yytext);
				return UNKNOWN;
}

%%
