/*
	example.y

 	Example of a bison specification file.

	Grammar is:

        <expr> -> intconst | ident | foo <identList> 
                  <intconstList>
        <identList> -> lambda | <identList> ident
        <intconstList> -> intconst | <intconstList> intconst

      To create the syntax analyzer:

        flex example.l
        bison example.y
        g++ example.tab.c -o parser
        parser < inputFileName
 */

%{
#include <stdio.h>

int numLines = 1; 

void printRule(const char *, const char *);
int yyerror(const char *s);
void printTokenInfo(const char* tokenType, const char* lexeme);

extern "C" 
{
    int yyparse(void);
    int yylex(void);
    int yywrap() { return 1; }
}

%}

/* Token declarations */
%token IDENT INTCONST STRCONST UNKNOWN FOO INPUT NIL
%token MULT SUB DIV ADD AND OR LT GT LE GE EQ PRINT
%token NE NOT LAMBDA LPAREN RPAREN LETSTAR IF T
/* Starting point */
%start		START

/* Translation rules */
%%

START		: EXPR
			{
			printRule("START", "EXPR");
			printf("\n---- Completed parsing ----\n\n");
			return 0;
			}
			;

EXPR		: CONST
            {
                printRule("EXPR","CONST");
            }
            | IDENT
            {
                printRule("EXPR","IDENT");
            }
            | LPAREN PARENTHESIZED_EXPR RPAREN
            {
                printRule("EXPR","LPAREN PARENTHESIZED_EXPR RPAREN");
            }
            ;

CONST       : INTCONST
            {
                printRule("CONST","INTCONST");
            }
            | STRCONST 
            {
                printRule("CONST","STRCONST");
            }
            | T
            {
                printRule("CONST","t");
            }
            | NIL 
            {
                printRule("CONST","nil");
            }
            ;

PARENTHESIZED_EXPR  : ARITHLOGIC_EXPR
                    {
                        printRule("PARENTHESIZED_EXPR","ARITHLOGIC_EXPR");
                    }
                    | IF_EXPR
                    {
                        printRule("PARENTHESIZED_EXPR","IF_EXPR");
                    }
                    | LET_EXPR 
                    {
                        printRule("PARENTHESIZED_EXPR","LET_EXPR");
                    }
                    | LAMBDA_EXPR
                    {
                        printRule("PARENTHESIZED_EXPR","LAMBDA_EXPR");
                    }
                    | PRINT_EXPR
                    {
                        printRule("PARENTHESIZED_EXPR","PRINT_EXPR");
                    }
                    | INPUT_EXPR 
                    {
                        printRule("PARENTHESIZED_EXPR","INPUT_EXPR");
                    }
                    | EXPR_LIST
                    {
                        printRule("PARENTHESIZED_EXPR","EXPR_LIST");
                    }
                    ;

ARITHLOGIC_EXPR : UN_OP EXPR
                {
                    printRule("ARITHLOGIC_EXPR","UN_OP EXPR");
                }
                | BIN_OP EXPR EXPR 
                {
                    printRule("ARITHLOGIC_EXPR","BIN_OP EXPR EXPR");
                }
                ;

IF_EXPR         : IF EXPR EXPR EXPR
                {
                    printRule("IF_EXPR","IF EXPR EXPR EXPR");
                }
                ;

LET_EXPR        : LETSTAR LPAREN ID_EXPR_LIST RPAREN EXPR
                {
                    printRule("LET_EXPR","LETSTAR LPAREN ID_EXPR_LIST RPAREN EXPR");
                }
                ;

ID_EXPR_LIST    : /*epsilon*/
                {
                    printRule("ID_EXPR_LIST","EPSILON");
                }
                | ID_EXPR_LIST LPAREN IDENT EXPR RPAREN
                {
                    printRule("ID_EXPR_LIST","ID_EXPR_LIST LPAREN IDENT EXPR RPAREN");
                }
                ;

LAMBDA_EXPR     : LAMBDA LPAREN ID_LIST RPAREN EXPR
                {
                    printRule("LAMBDA_EXPR","LAMBDA LPAREN ID_LIST RPAREN EXPR");
                }
                ;

ID_LIST         : /*epsilon*/
                {
                    printRule("ID_LIST","EPSILON");
                }
                | ID_LIST IDENT
                {
                    printRule("ID_LIST","ID_LIST IDENT");
                }
                ;

PRINT_EXPR      :   PRINT EXPR 
                {
                    printRule("PRINT_EXPR","PRINT EXPR");
                }
                ;

INPUT_EXPR      :   INPUT
                {
                    printRule("INPUT_EXPR","INPUT");
                }
                ;

EXPR_LIST       : EXPR EXPR_LIST 
                {
                    printRule("EXPR_LIST","EXPR EXPR_LIST");
                }
                | EXPR 
                {
                    printRule("EXPR_LIST","EXPR");
                }
                ;

BIN_OP          : ARITH_OP 
                {
                    printRule("BIN_OP","ARITH_OP");
                }
                | LOG_OP
                {
                    printRule("BIN_OP","LOG_OP");
                }
                | REL_OP
                {
                    printRule("BIN_OP","REL_OP");
                }
                ;

ARITH_OP        : MULT 
                {
                    printRule("ARITH_OP","MULT");
                }
                | SUB 
                {
                    printRule("ARITH_OP","SUB");
                }
                | DIV
                {
                    printRule("ARITH_OP","DIV");
                }
                | ADD
                {
                    printRule("ARITH_OP","ADD");
                }
                ;

LOG_OP          : AND
                {
                    printRule("LOG_OP","AND");
                }
                | OR
                {
                    printRule("LOG_OP","OR");
                }
                ;

REL_OP          : LT 
                {
                    printRule("REL_OP","LT");
                }
                | GT 
                {
                    printRule("REL_OP","GT");
                }
                | LE 
                {
                    printRule("REL_OP","LE");
                }
                | GE 
                {
                    printRule("REL_OP","GE");
                }
                | EQ 
                {
                    printRule("REL_OP","EQ");
                }
                | NE 
                {
                    printRule("REL_OP","NE");
                }
                ;

UN_OP           : NOT
                {
                    printRule("UN_OP","NOT");
                }





%%

#include "lex.yy.c"
extern FILE *yyin;

void printRule(const char *lhs, const char *rhs) 
{
  printf("%s -> %s\n", lhs, rhs);
  return;
}

int yyerror(const char *s) 
{
  printf("Line %d: %s\n",numLines, s);
  return(1);
}

void printTokenInfo(const char* tokenType, const char* lexeme) 
{
  printf("TOKEN: %s  LEXEME: %s\n", tokenType, lexeme);
}

int main(void) 
{
  do 
  {
	yyparse();
  } while (!feof(yyin));

  printf("%d lines processed\n", numLines);
  return(0);
}
