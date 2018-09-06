
/*    example.l
 
 	Example of a lex specification file.
     
      To create the lexical analyzer:

      flex example.l
      g++ lex.yy.c -o lexer
      lexer < inputFileName
*/

%{
// #define		T_ADD		    0001
// #define		T_SUB		    0002
// #define		T_MULT	    0003
// #define		T_DIV		    0004
// #define		T_AND		    0005
// #define		T_OR		    0006
// #define		T_NOT		    0007
// #define		T_LT		    0010
// #define		T_GT		    0011
// #define		T_LE		    0012
// #define		T_GE		    0013
// #define		T_EQ		    0014
// #define		T_NE		    0015
// #define		T_LPAREN	    0100
// #define		T_RPAREN	    0101
// #define		T_LETSTAR	    0200
// #define		T_IF		    0201
// #define		T_LAMBDA	    0202
// #define		T_PRINT	    0203
// #define		T_INPUT	    0204
// #define		T_T		    0205
// #define		T_NIL		    0206
// #define		T_IDENT	    0300
// #define		T_INTCONST	    0301
// #define		T_STRCONST	    0302
// #define		T_UNKNOWN	    0666
%}

/* Defintions of regular expressions go here */


WSPACE		        [ \t\n\r]+

LO_ALPHA		      [a-z]
HI_ALPHA		      [A-Z]
ALPHA			        {LO_ALPHA}|{HI_ALPHA}
DIGIT             [0-9]
ALPHANUM		      {ALPHA}|{DIGIT}
UNDERSCORE		    _

T_IDENT			        ({UNDERSCORE}|{ALPHA})({ALPHANUM}|{UNDERSCORE})*

NEG_INTCONST	    "-"[0-9]+
POS_INTCONST	    ("+")?[0-9]+
T_INTCONST          {NEG_INTCONST}|{POS_INTCONST}

DOUBLE_QUOTE      \"
T_STRCONST          {DOUBLE_QUOTE}[^\"\n]*{DOUBLE_QUOTE} 
COMMENT           ";".*$      

/* Identifiers */
T_MULT            \*
T_SUB             -
T_DIV             \\
T_ADD             \+
T_AND             and
T_OR              or
T_LT              <
T_GT              >
T_LE              <=
T_GE              >=
T_EQ              =
T_NE              \/=
T_NOT             not
T_LAMBDA          lambda
T_LPAREN          \(
T_RPAREN          \)
T_LETSTAR         let\*
T_IF              if
T_NIL             nil
T_T               t
T_PRINT           print
T_INPUT           input


%%

{T_LAMBDA}        {
                printTokenInfo("LAMBDA", yytext);
                return T_LAMBDA;
} 
{T_LETSTAR}          {
                printTokenInfo("LETSTAR", yytext);
                return T_LETSTAR;
}
{T_LPAREN}             {
                printTokenInfo("LPAREN", yytext);
                return T_LPAREN;
}
{T_RPAREN}             {
                printTokenInfo("RPAREN", yytext);
                return T_RPAREN;
}
{T_INPUT}         {
                printTokenInfo("INPUT", yytext);
                return T_INPUT;
}
{T_PRINT}         {
                printTokenInfo("PRINT", yytext);
                return T_PRINT;
}
{T_IF}            {
                printTokenInfo("IF", yytext);
                return T_IF;
}
{T_ADD}             {
                printTokenInfo("ADD", yytext);
                return T_ADD;
}
{T_MULT}             {
                printTokenInfo("MULT", yytext);
                return T_MULT;
}
{T_DIV}             {
                printTokenInfo("DIV", yytext);
                return T_DIV;
}
{T_SUB}             {
                printTokenInfo("SUB", yytext);
                return T_IDENT;
}
{T_AND}           {
                printTokenInfo("AND", yytext);
                return T_AND;
}
{T_OR}            {
                printTokenInfo("OR", yytext);
                return T_OR;
}
{T_NOT}           {
                printTokenInfo("NOT", yytext);
                return T_NOT;
}
{T_LT}             {
                printTokenInfo("LT", yytext);
                return T_LT;
}
{T_GT}             {
                printTokenInfo("GT", yytext);
                return T_GT;
}
{T_LE}            {
                printTokenInfo("LE", yytext);
                return T_LE;
}
{T_GE}            {
                printTokenInfo("GE", yytext);
                return T_GE;
}
{T_EQ}             {
                printTokenInfo("EQ", yytext);
                return T_EQ;
}
{T_NE}            {
                printTokenInfo("NE", yytext);
                return T_NE;
}
{T_T}             {
                printTokenInfo("T", yytext);
                return T_T;
}
{T_NIL}           {
                printTokenInfo("NIL", yytext);
                return T_NIL;
}
{T_INTCONST}	     {
			printf("TOKEN: INTCONST  LEXEME: %s\n", yytext);
			return T_INTCONST;
			}
{T_STRCONST}	     {
			printf("TOKEN: STRCONST  LEXEME: %s\n", yytext);
			return T_STRCONST;
			}
{T_IDENT}		{
			printf("TOKEN: IDENT     LEXEME: %s\n", yytext);
			return T_IDENT;
			}
{COMMENT}       { }
{WSPACE}		    { }
.			          {
				printTokenInfo("UNKNOWN", yytext);
				return T_UNKNOWN;
}

%%
