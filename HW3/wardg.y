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
#include <stdlib.h>
#include <stack>
#include"SymbolTable.h"
using namespace std;

int numLines = 1; 

void printRule(const char *, const char *);
int yyerror(const char *s);
void printTokenInfo(const char* tokenType, const char* lexeme);
stack<SYMBOL_TABLE> scopeStack;
// const int UNDEFINED;

extern "C" 
{
    int yyparse(void);
    int yylex(void);
    int yywrap() { return 1; }
}

void beginScope( ) 
{
    scopeStack.push(SYMBOL_TABLE( ));
    printf("\n___Entering new scope...\n\n");
}

void endScope( ) 
{
    scopeStack.pop( );
    printf("\n___Exiting scope...\n\n");
}

bool findEntryInAnyScope(const string theName) 
{
    if (scopeStack.empty( )) return(false);
        bool found = scopeStack.top( ).findEntry(theName);
    if (found)
        return(true);
    else { 
        // check in "next higher" scope
        SYMBOL_TABLE symbolTable = scopeStack.top( );
        scopeStack.pop( );
        found = findEntryInAnyScope(theName);
        scopeStack.push(symbolTable); 

        // restore the stack
        return(found);
    }
}

%}
%union{char* text;};
/* Token declarations */
%token T_IDENT T_INTCONST T_STRCONST T_UNKNOWN T_FOO T_INPUT T_NIL
%token T_MULT T_SUB T_DIV T_ADD T_AND T_OR T_LT T_GT T_LE T_GE T_EQ T_PRINT
%token T_NE T_NOT T_LAMBDA T_LPAREN T_RPAREN T_LETSTAR T_IF T_T
/* Starting point */
%start		START
%type <text> T_IDENT
/* Translation rules */
%%

START		: N_EXPR
			{
			printRule("START", "EXPR");
			printf("\n---- Completed parsing ----\n\n");
			return 0;
			}
			;

N_EXPR		: N_CONST
            {
                printRule("EXPR","CONST");
            }
            | T_IDENT
            {       
                printRule("EXPR","IDENT");
                if(!findEntryInAnyScope($1))
                    yyerror("");
                
            }
            | T_LPAREN N_PARENTHESIZED_EXPR T_RPAREN
            {
                printRule("EXPR","( PARENTHESIZED_EXPR )");
            }
            ;

N_CONST       : T_INTCONST
            {
                printRule("CONST","INTCONST");
            }
            | T_STRCONST 
            {
                printRule("CONST","STRCONST");
            }
            | T_T
            {
                printRule("CONST","t");
            }
            | T_NIL 
            {
                printRule("CONST","nil");
            }
            ;

N_PARENTHESIZED_EXPR  : N_ARITHLOGIC_EXPR
                    {
                        printRule("PARENTHESIZED_EXPR","ARITHLOGIC_EXPR");
                    }
                    | N_IF_EXPR
                    {
                        printRule("PARENTHESIZED_EXPR","IF_EXPR");
                    }
                    | N_LET_EXPR 
                    {
                        printRule("PARENTHESIZED_EXPR","LET_EXPR");
                    }
                    | N_LAMBDA_EXPR
                    {
                        printRule("PARENTHESIZED_EXPR","LAMBDA_EXPR");
                    }
                    | N_PRINT_EXPR
                    {
                        printRule("PARENTHESIZED_EXPR","PRINT_EXPR");
                    }
                    | N_INPUT_EXPR 
                    {
                        printRule("PARENTHESIZED_EXPR","INPUT_EXPR");
                    }
                    | N_EXPR_LIST
                    {
                        printRule("PARENTHESIZED_EXPR","EXPR_LIST");
                    }
                    ;

N_ARITHLOGIC_EXPR : N_UN_OP N_EXPR
                {
                    printRule("ARITHLOGIC_EXPR","UN_OP EXPR");
                }
                | N_BIN_OP N_EXPR N_EXPR 
                {
                    printRule("ARITHLOGIC_EXPR","BIN_OP EXPR EXPR");
                }
                ;

N_IF_EXPR         : T_IF N_EXPR N_EXPR N_EXPR
                {
                    printRule("IF_EXPR","IF EXPR EXPR EXPR");
                }
                ;

N_LET_EXPR        : T_LETSTAR T_LPAREN N_ID_EXPR_LIST T_RPAREN N_EXPR
                {
                    printRule("LET_EXPR","let* ( ID_EXPR_LIST ) EXPR");
                    endScope();
                }
                ;

N_ID_EXPR_LIST    : /*epsilon*/
                {
                    printRule("ID_EXPR_LIST","EPSILON");
                }
                | N_ID_EXPR_LIST T_LPAREN T_IDENT N_EXPR T_RPAREN
                {
                    printRule("ID_EXPR_LIST","ID_EXPR_LIST ( IDENT EXPR )");
                    printf("___Adding %s to symbol table\n", $3);

                    if(!scopeStack.top().addEntry(SYMBOL_TABLE_ENTRY($3,UNDEFINED)))
                    {
                        yyerror($3);
                    }
                }
                ;

N_LAMBDA_EXPR     : T_LAMBDA T_LPAREN N_ID_LIST T_RPAREN N_EXPR
                {
                    printRule("LAMBDA_EXPR","lambda ( ID_LIST ) EXPR");
                    endScope();
                }
                ;

N_ID_LIST         : /*epsilon*/
                {
                    printRule("ID_LIST","EPSILON");
                }
                | N_ID_LIST T_IDENT
                {
                    printRule("ID_LIST","ID_LIST IDENT");
                    scopeStack.top().addEntry(SYMBOL_TABLE_ENTRY($2, UNDEFINED));
                    printf("___Adding %s to symbol table\n", $2);          
                }
                ;

N_PRINT_EXPR      :   T_PRINT N_EXPR 
                {
                    printRule("PRINT_EXPR","PRINT EXPR");
                }
                ;

N_INPUT_EXPR      :   T_INPUT
                {
                    printRule("INPUT_EXPR","INPUT");
                }
                ;

N_EXPR_LIST       : N_EXPR N_EXPR_LIST 
                {
                    printRule("EXPR_LIST","EXPR EXPR_LIST");
                }
                | N_EXPR 
                {
                    printRule("EXPR_LIST","EXPR");
                }
                ;

N_BIN_OP          : N_ARITH_OP 
                {
                    printRule("BIN_OP","ARITH_OP");
                }
                | N_LOG_OP
                {
                    printRule("BIN_OP","LOG_OP");
                }
                | N_REL_OP
                {
                    printRule("BIN_OP","REL_OP");
                }
                ;

N_ARITH_OP        : T_MULT 
                {
                    printRule("ARITH_OP","*");
                }
                | T_SUB 
                {
                    printRule("ARITH_OP","-");
                }
                | T_DIV
                {
                    printRule("ARITH_OP","/");
                }
                | T_ADD
                {
                    printRule("ARITH_OP","+");
                }
                ;

N_LOG_OP          : T_AND
                {
                    printRule("LOG_OP","AND");
                }
                | T_OR
                {
                    printRule("LOG_OP","OR");
                }
                ;

N_REL_OP          : T_LT 
                {
                    printRule("REL_OP","<");
                }
                | T_GT 
                {
                    printRule("REL_OP",">");
                }
                | T_LE 
                {
                    printRule("REL_OP","<=");
                }
                | T_GE 
                {
                    printRule("REL_OP",">=");
                }
                | T_EQ 
                {
                    printRule("REL_OP","=");
                }
                | T_NE 
                {
                    printRule("REL_OP","/=");
                }
                ;

N_UN_OP           : T_NOT
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
  printf("Line %d: Multply defined identifier\n",numLines);
  exit(1);
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

  return(0);
}
