
/*    example.l
 
 	Example of a lex specification file.
     
      To create the lexical analyzer:

      flex example.l
      g++ lex.yy.c -o lexer
      lexer < inputFileName
*/

%{
#define		ADD		    0001
#define		SUB		    0002
#define		MULT	    0003
#define		DIV		    0004
#define		AND		    0005
#define		OR		    0006
#define		NOT		    0007
#define		LT		    0010
#define		GT		    0011
#define		LE		    0012
#define		GE		    0013
#define		EQ		    0014
#define		NE		    0015
#define		LPAREN	  0100
#define		RPAREN	  0101
#define		LETSTAR	  0200
#define		IF		    0201
#define		LAMBDA	  0202
#define		PRINT	    0203
#define		INPUT	    0204
#define		T		      0205
#define		NIL		    0206
#define		IDENT	    0300
#define		INTCONST	0301
#define		STRCONST	0302
#define		UNKNOWN	  0666
%}

/* Defintions of regular expressions go here */


WSPACE		        [ \t\n\r]+

LO_ALPHA		      [a-z]
HI_ALPHA		      [A-Z]
ALPHA			        {LO_ALPHA}|{HI_ALPHA}
DIGIT             [0-9]
ALPHANUM		      {ALPHA}|{DIGIT}
UNDERSCORE		    _

IDENT			        ({UNDERSCORE}|{ALPHA})({ALPHANUM}|{UNDERSCORE})*

NEG_INTCONST	    "-"[0-9]+
POS_INTCONST	    ("+")?[0-9]+
INTCONST          {NEG_INTCONST}|{POS_INTCONST}

DOUBLE_QUOTE      \"
STRCONST          {DOUBLE_QUOTE}[^\"\n]*{DOUBLE_QUOTE} 
COMMENT           ";".*$      

/* Identifiers */
MULT            \*
SUB             -
DIV             \\
ADD             \+
AND             and
OR              or
LT              <
GT              >
LE              <=
GE              >=
EQ              =
NE              \/=
NOT             not
LAMBDA          lambda
LPAREN          \(
RPAREN          \)
LETSTAR         let\*
IF              if
NIL             nil
T               t
PRINT           print
INPUT           input


%%

{LAMBDA}        {
                printTokenInfo("LAMBDA", yytext);
                return IDENT;
} 
{LETSTAR}          {
                printTokenInfo("LETSTAR", yytext);
                return IDENT;
}
{LPAREN}             {
                printTokenInfo("LPAREN", yytext);
                return IDENT;
}
{RPAREN}             {
                printTokenInfo("RPAREN", yytext);
                return IDENT;
}
{INPUT}         {
                printTokenInfo("INPUT", yytext);
                return IDENT;
}
{PRINT}         {
                printTokenInfo("PRINT", yytext);
                return IDENT;
}
{IF}            {
                printTokenInfo("IF", yytext);
                return IDENT;
}
{ADD}             {
                printTokenInfo("ADD", yytext);
                return IDENT;
}
{MULT}             {
                printTokenInfo("MULT", yytext);
                return IDENT;
}
{DIV}             {
                printTokenInfo("DIV", yytext);
                return IDENT;
}
{SUB}             {
                printTokenInfo("SUB", yytext);
                return IDENT;
}
{AND}           {
                printTokenInfo("AND", yytext);
                return IDENT;
}
{OR}            {
                printTokenInfo("OR", yytext);
                return IDENT;
}
{NOT}           {
                printTokenInfo("NOT", yytext);
                return IDENT;
}
{LT}             {
                printTokenInfo("LT", yytext);
                return IDENT;
}
{GT}             {
                printTokenInfo("GT", yytext);
                return IDENT;
}
{LE}            {
                printTokenInfo("LE", yytext);
                return IDENT;
}
{GE}            {
                printTokenInfo("GE", yytext);
                return IDENT;
}
{EQ}             {
                printTokenInfo("EQ", yytext);
                return IDENT;
}
{NE}            {
                printTokenInfo("NE", yytext);
                return IDENT;
}
{T}             {
                printTokenInfo("T", yytext);
                return IDENT;
}
{NIL}           {
                printTokenInfo("NIL", yytext);
                return IDENT;
}
{INTCONST}	     {
			printf("TOKEN: INTCONST  LEXEME: %s\n", yytext);
			return INTCONST;
			}
{STRCONST}	     {
			printf("TOKEN: STRCONST  LEXEME: %s\n", yytext);
			return STRCONST;
			}
{IDENT}		{
			printf("TOKEN: IDENT     LEXEME: %s\n", yytext);
			return IDENT;
			}
{COMMENT}       { }
{WSPACE}		    { }
.			          {
				printTokenInfo("UNKNOWN", yytext);
				return UNKNOWN;
}

%%
