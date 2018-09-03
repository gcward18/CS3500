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
%token  IDENT INTCONST UNKNOWN FOO

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
                printTokenInfo("IDENT",yylex);
            }
            | "(" PARENTHESIZED_EXPR ")"
            {
                printRule("EXPR","LPAREN PARENTHESIZED_EXPR RPAREN");
            }
            ;

CONST       : INTCONST
            {
                printTokenInfo("INTCONST",yylex);
            }
            | "\".*\"" 
            {
                printTokenInfo("STRCONST",yylex);
            }
            | "t"
            {
                printTokenInfo("T", yylex);
            }
            | "nil" 
            {
                printTokenInfo("NIL", yylex);
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

IF_EXPR         : "if" EXPR EXPR EXPR
                {
                    printRule("IF_EXPR","IF EXPR EXPR EXPR");
                }
                ;

LET_EXPR        : "let*" "(" ID_EXPR_LIST ")" EXPR
                {
                    printRule("LET_EXPR","LETSTAR LPAREN ID_EXPR_LIST RPAREN EXPR");
                }
                ;

ID_EXPR_LIST    : /*epsilon*/
                {
                    printRule("ID_EXPR_LIST","EPSILON");
                }
                | ID_EXPR_LIST "(" IDENT EXPR ")"
                {
                    printRule("ID_EXPR_LIST","ID_EXPR_LIST LPAREN IDENT EXPR RPAREN");
                }
                ;

LAMBDA_EXPR     : "lambda" "(" ID_LIST ")" EXPR
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

PRINT_EXPR      :   "print" EXPR 
                {
                    printRule("PRINT_EXPR","PRINT RULE");
                }
                ;

INPUT_EXPR      :   "input"
                {
                    printTokenInfo("INPUT",yylex);
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

ARITH_OP        : "*" 
                {
                    printTokenInfo("MULT",yylex);
                }
                | "-" 
                {
                    printTokenInfo("SUB",yylex);
                }
                | "/"
                {
                    printTokenInfo("DIV",yylex);
                }
                | "+"
                {
                    printTokenInfo("ADD",yylex);
                }
                ;

LOG_OP          : "and"
                {
                    printTokenInfo("AND",yylex);
                }
                | "or"
                {
                    printTokenInfo("OR",yylex);
                }
                ;

REL_OP          : "<" 
                {
                    printTokenInfo("LT",yylex);
                }
                | ">" 
                {
                    printTokenInfo("GT",yylex);
                }
                | "<=" 
                {
                    printTokenInfo("LE",yylex);
                }
                | ">=" 
                {
                    printTokenInfo("GE",yylex);
                }
                | "=" 
                {
                    printTokenInfo("EQ",yylex);
                }
                | "/=" 
                {
                    printTokenInfo("NE",yylex);
                }
                ;

UN_OP           : "not"
                {
                    printTokenInfo("NOT",yylex);
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
  printf("%s\n", s);
  return(1);
}

void printTokenInfo(const char* tokenType, const char* lexeme) 
{
  printf("TOKEN: %s  LEXEME: %s\n", tokenType, lexeme);
}

int main() 
{
  do 
  {
	yyparse();
  } while (!feof(yyin));

  printf("%d lines processed\n", numLines);
  return(0);
}
