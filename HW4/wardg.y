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


#define NOT_APPLICABLE			-2
#define UNDEFINED 			-1
#define FUNCTION			0
#define INT 				1
#define STR 				2
#define INT_OR_STR 			3
#define BOOL 				4
#define INT_OR_BOOL			5
#define STR_OR_BOOL			6
#define INT_OR_STR_OR_BOOL		7
#define ARITHMETIC_OP   		8
#define LOGICAL_OP			9
#define RELATIONAL_OP			10

int num 	 = 0;
int numLines = 1; 

void printRule(const char *, const char *);
int  yyerror(const char *s);
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
%union{
	char* text;
	TYPE_INFO typeInfo;
	int num;
};
/* Token declarations */
%token T_IDENT  T_STRCONST T_UNKNOWN T_FOO T_INPUT T_NIL T_INTCONST
%token T_MULT T_SUB T_DIV T_ADD T_AND T_OR T_LT T_GT T_LE T_GE T_EQ T_PRINT
%token T_NE T_NOT T_LAMBDA T_LPAREN T_RPAREN T_LETSTAR T_IF T_T

/* Starting point */
%start		N_START

/* Associate identfiers name with identifiers token */
%type <text> T_IDENT
%type <typeInfo> N_CONST N_EXPR N_PARENTHESIZED_EXPR N_IF_EXPR N_ARITHLOGIC_EXPR 
%type <typeInfo> N_LAMBDA_EXPR N_LET_EXPR N_PRINT_EXPR N_EXPR_LIST N_INPUT_EXPR
%type <num>	N_BIN_OP
/* Translation rules */
%%
N_START		: N_EXPR
			{
				printRule("START", "EXPR");
				printf("\n---- Completed parsing ----\n\n");
				return 0;
			}
			;
N_EXPR		: N_CONST
			{
				printRule("EXPR", "CONST");
				$$.type 		= $1.type;
				$$.numParams	= NOT_APPLICABLE;
				$$.returnType	= NOT_APPLICABLE;				
			}
			| T_IDENT
			{
				printRule("EXPR", "IDENT");
				if (!findEntryInAnyScope($1)) {
						yyerror("Undefined identifier");
						return(0);
				}
			}
			| T_LPAREN N_PARENTHESIZED_EXPR T_RPAREN
			{
				printRule("EXPR", "( PARENTHESIZED_EXPR )");
				$$.type 		= $2.type;
				$$.numParams	= $2.numParams;
				$$.returnType	= $2.returnType;
			}
			;
N_CONST		: T_INTCONST
			{
				printRule("CONST", "INTCONST");
				$$.type 		= INT;
				$$.numParams 	= NOT_APPLICABLE;
				$$.returnType 	= NOT_APPLICABLE;
			}
                | T_STRCONST
			{
				printRule("CONST", "STRCONST");
				$$.type 		= STR;
				$$.numParams 	= NOT_APPLICABLE;
				$$.returnType 	= NOT_APPLICABLE;
			}
			| T_T
			{
				printRule("CONST","t");
				$$.type 		= BOOL;
				$$.numParams 	= NOT_APPLICABLE;
				$$.returnType 	= NOT_APPLICABLE;
			}
			| T_NIL
			{
				printRule("CONST", "nil");
				$$.type 		= BOOL;
				$$.numParams 	= NOT_APPLICABLE;
				$$.returnType 	= NOT_APPLICABLE;
			}
			;
N_PARENTHESIZED_EXPR	: N_ARITHLOGIC_EXPR 
				{
					printRule("PARENTHESIZED_EXPR",
									"ARITHLOGIC_EXPR");
					$$.type 		= $1.type;
					$$.numParams 	= NOT_APPLICABLE;
					$$.returnType 	= NOT_APPLICABLE;
				}
                | N_IF_EXPR 
				{
					printRule("PARENTHESIZED_EXPR", "IF_EXPR");
					if($1.type == FUNCTION){
						yyerror("Arg 1 cannot be a function");
					}
					$$.type 		= $1.type;
					$$.numParams 	= NOT_APPLICABLE;
					$$.returnType 	= NOT_APPLICABLE;

				}
                | N_LET_EXPR 
				{
					printRule("PARENTHESIZED_EXPR", 
									"LET_EXPR");
					$$.type 		= FUNCTION;
					// $$.numParams 	= NOT_APPLICABLE;
					// $$.returnType 	= NOT_APPLICABLE;
				}
            	| N_LAMBDA_EXPR 
				{
					printRule("PARENTHESIZED_EXPR", 
							"LAMBDA_EXPR");
					$$.type 		= FUNCTION;
					// $$.numParams 	= NOT_APPLICABLE;
					// $$.returnType 	= NOT_APPLICABLE;
				}
                | N_PRINT_EXPR 
				{
					printRule("PARENTHESIZED_EXPR", 
							"PRINT_EXPR");
					$$.type 		= $1.type;
					$$.numParams 	= NOT_APPLICABLE;
					$$.returnType 	= NOT_APPLICABLE;
				}
                | N_INPUT_EXPR 
				{
					printRule("PARENTHESIZED_EXPR",
							"INPUT_EXPR");
					$$.type 		= $1.type;
					$$.numParams 	= NOT_APPLICABLE;
					$$.returnType 	= NOT_APPLICABLE;
				}
                | N_EXPR_LIST 
				{
					printRule("PARENTHESIZED_EXPR",
							"EXPR_LIST");
					$$.type 		= $1.type;
					$$.numParams 	= NOT_APPLICABLE;
					$$.returnType 	= NOT_APPLICABLE;
				}
				;
N_ARITHLOGIC_EXPR	: N_UN_OP N_EXPR
				{
					printRule("ARITHLOGIC_EXPR", "UN_OP EXPR");
					if($2.type == FUNCTION){
						yyerror("Arg 1 cannot be function");
						return(1);
					}
					$$.type 		= BOOL;
					$$.numParams 	= NOT_APPLICABLE;
					$$.returnType 	= NOT_APPLICABLE;
				}
				| N_BIN_OP N_EXPR N_EXPR
				{
				printRule("ARITHLOGIC_EXPR", 
				          "BIN_OP EXPR EXPR");
					
					if($1 == ARITHMETIC_OP){
						if($2.type&$3.type == INT){
							$$.type 		= INT;
							$$.numParams 	= $2.numParams + $3.numParams;
							$$.returnType 	= INT;
						}
						else if ($2.type != INT){
							yyerror("Arg 1 must be integer");
							return(1);
						}
						yyerror("Arg 2 must be integer");
						return(1);
					}
					else if($1 == RELATIONAL_OP){
						if(($2.type == FUNCTION) || ($2.type != INT && $2.type != STR)){
							yyerror("Arg 1 must be integer or string");
							return(1);
						}
						if(($2.type == FUNCTION) || ($3.type != INT && $3.type != STR)){
							yyerror("Arg 2 must be integer or string");
							return(1);
						}
						else{	
							$$.type 		= BOOL;
							$$.numParams 	= $2.numParams + $3.numParams;
							$$.returnType 	= BOOL;
						}
						
					}
					else if($1 == LOGICAL_OP){
						if ($2.type == FUNCTION){
							yyerror("Arg 1 cannot be function");
							return(1);
						}
						else if ($3.type == FUNCTION){
							yyerror("Arg 2 cannot be function");
							return(1);
						}
						$$.type 		= BOOL;
						$$.numParams 	= $2.numParams + $3.numParams;
						$$.returnType 	= BOOL;
					}
					else{
						yyerror("Something went wrong....");
						return(1);
					}
				}
                     	;
N_IF_EXPR    	: T_IF N_EXPR N_EXPR N_EXPR
			{
				printRule("IF_EXPR", "if EXPR EXPR EXPR");
				if($4.type == FUNCTION){
					yyerror("Arg 3 cannot be a function");
					return(1);
				}
				else if ($3.type == FUNCTION){
					yyerror("Arg 2 cannot be a function");
					return(1);
				}
				else if ($2.type == FUNCTION){
					yyerror("Arg 1 cannot be a function");
					return(1);
				}
				if($3.type&$4.type == INT){
					$$.type 		= INT;
					$$.numParams 	= $2.numParams + $3.numParams;
					$$.returnType  	= INT;
				}
			}
			;
N_LET_EXPR      : T_LETSTAR T_LPAREN N_ID_EXPR_LIST T_RPAREN 
                  N_EXPR
			{
				printRule("LET_EXPR", 
						"let* ( ID_EXPR_LIST ) EXPR");

				if($5.type == FUNCTION){
					yyerror("Arg 5 cannot be a function");
					return(1);
				}

				// if($3.type == FUNCTION){
				// 	yyerror("Arg 3 cannot be a function");
				// 	return(1);
				// }

				$$.type 		= FUNCTION;
				$$.numParams  	= $5.numParams;
				$$.returnType	= NOT_APPLICABLE;

				endScope();
			}
			;
N_ID_EXPR_LIST  : /* epsilon */
			{
				printRule("ID_EXPR_LIST", "epsilon");
			}
                | N_ID_EXPR_LIST T_LPAREN T_IDENT N_EXPR T_RPAREN 
			{
				printRule("ID_EXPR_LIST", 
							"ID_EXPR_LIST ( IDENT EXPR )");
				string lexeme = string($3);
				printf("___Adding %s to symbol table %d\n\n\n\n", $3, $4.type);
				bool success = scopeStack.top().addEntry(SYMBOL_TABLE_ENTRY(lexeme,$4));
				if (! success) {
					yyerror("Multiply defined identifier");
					return(0);
				}
			}
			;
N_LAMBDA_EXPR   : T_LAMBDA T_LPAREN N_ID_LIST T_RPAREN N_EXPR
			{
				printRule("LAMBDA_EXPR", 
						"lambda ( ID_LIST ) EXPR");

				if($5.type == FUNCTION){
					yyerror("Arg 5 cannot be a function");
					return(1);
				}
				$$.type 		= FUNCTION;
				$$.numParams  	= $5.numParams;
				$$.returnType	= NOT_APPLICABLE;
				endScope();
			}
			;
N_ID_LIST       : /* epsilon */
			{
				printRule("ID_LIST", "epsilon");
			}

			| N_ID_LIST T_IDENT 
			{
					printRule("ID_LIST", "ID_LIST IDENT");
					string lexeme = string($2);
                	printf("___Adding %s to symbol table\n", $2);
                	bool success = scopeStack.top().addEntry(SYMBOL_TABLE_ENTRY(lexeme,UNDEFINED));
                	if (! success) {
						yyerror("Multiply defined identifier");
						return(0);
                	}
			}
			;
N_PRINT_EXPR    : T_PRINT N_EXPR
			{
				printRule("PRINT_EXPR", "print EXPR");
				if($2.type == FUNCTION){
					yyerror("Arg 2 cannot be a function");
					return(1);
				}
				$$.type 		= INT_OR_STR;
				$$.numParams 	= NOT_APPLICABLE;
				$$.returnType 	= INT_OR_STR;
			}
			;
N_INPUT_EXPR    : T_INPUT
			{
				printRule("INPUT_EXPR", "input");
				$$.type 		= INT_OR_STR;
				$$.numParams 	= NOT_APPLICABLE;
				$$.returnType 	= INT_OR_STR;

			}
			;
N_EXPR_LIST     : N_EXPR N_EXPR_LIST  
			{
				printRule("EXPR_LIST", "EXPR EXPR_LIST");
			}
                | N_EXPR
			{
				printRule("EXPR_LIST", "EXPR");
				$$.type 		= $1.type;
				$$.numParams 	= NOT_APPLICABLE;
				$$.returnType	= NOT_APPLICABLE;
			}
			;
N_BIN_OP	     : N_ARITH_OP
			{
				printRule("BIN_OP", "ARITH_OP");
				$$ = ARITHMETIC_OP;
			}	
			|
			N_LOG_OP
			{
				printRule("BIN_OP", "LOG_OP");
				$$ = LOGICAL_OP;				
			}
			|
			N_REL_OP
			{
				printRule("BIN_OP", "REL_OP");
				$$ = RELATIONAL_OP;
			}
			;
N_ARITH_OP	     : T_ADD
			{
				printRule("ARITH_OP", "+");
			}
                | T_SUB
			{
				printRule("ARITH_OP", "-");
			}
			| T_MULT
			{
				printRule("ARITH_OP", "*");
			}
			| T_DIV
			{
				printRule("ARITH_OP", "/");
			}
			;
N_REL_OP	     : T_LT
			{
				printRule("REL_OP", "<");
			}	
			| T_GT
			{
				printRule("REL_OP", ">");
			}	
			| T_LE
			{
				printRule("REL_OP", "<=");
			}	
			| T_GE
			{
				printRule("REL_OP", ">=");
			}	
			| T_EQ
			{
				printRule("REL_OP", "=");
			}	
			| T_NE
			{
				printRule("REL_OP", "/=");
			}
			;	
N_LOG_OP	     : T_AND
			{
				printRule("LOG_OP", "and");
			}	
			| T_OR
			{
				printRule("LOG_OP", "or");
			}
			;
N_UN_OP	     : T_NOT
			{
				printRule("UN_OP", "not");
			}
			;		


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
