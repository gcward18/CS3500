/*
      mfpl.y

 	Specifications for the MFPL language, YACC input file.

      To create syntax analyzer:

        flex mfpl.l
        bison mfpl.y
        g++ mfpl.tab.c -o mfpl_parser
        mfpl_parser < inputFileName
 */

/*
 *	Declaration section.
 */
%{

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <stack>
#include "SymbolTable.h"
using namespace std;

#define ARITHMETIC_OP	1   // classification for operators
#define LOGICAL_OP   	2
#define RELATIONAL_OP	3

int lineNum = 1;
int INT_TEMP = 0;
char NIL[]= {'n','i','l'};
char T[]={'T'};
stack<SYMBOL_TABLE> scopeStack;    // stack of scope hashtables
stack<char> arith;
stack<string> rel;
bool isIntCompatible(const int theType);
bool isStrCompatible(const int theType);
bool isIntOrStrCompatible(const int theType);

void beginScope();
void endScope();
void cleanUp();
TYPE_INFO findEntryInAnyScope(const string theName);

void printRule(const char*, const char*);
int yyerror(const char* s) {
  printf("Line %d: %s\n", lineNum, s);
  cleanUp();
  exit(1);
}

extern "C" {
    int yyparse(void);
    int yylex(void);
    int yywrap() {return 1;}
}

%}

%union {
  char* text;
  int num;
  TYPE_INFO typeInfo;
};

/*
 *	Token declarations
*/
%token  T_LPAREN T_RPAREN 
%token  T_IF T_LETSTAR T_PRINT T_INPUT
%token  T_ADD  T_SUB  T_MULT  T_DIV
%token  T_LT T_GT T_LE T_GE T_EQ T_NE T_AND T_OR T_NOT	 
%token  T_STRCONST T_T T_NIL T_IDENT T_UNKNOWN
%token  <typeInfo>T_INTCONST

%type <text> T_IDENT 
%type <typeInfo> N_EXPR N_PARENTHESIZED_EXPR N_ARITHLOGIC_EXPR  
%type <typeInfo> N_CONST N_IF_EXPR N_PRINT_EXPR N_INPUT_EXPR 
%type <typeInfo> N_LET_EXPR N_EXPR_LIST
%type <num> N_BIN_OP 

/*
 *	Starting point.
 */
%start  N_START

/*
 *	Translation rules.
 */
%%
N_START		: N_EXPR
			{
			printRule("START", "EXPR");
			printf("\n---- Completed parsing ----\n\n");
			if($1.type == INT)
			{
				printf("\nValue of the expression is %d \n", $1.nval);	
			}
			else if ($1.type == STR)
			{
				printf("\nValue of the expression is %s \n", $1.sval);	
			}
			else
			{
				if($1.bval == true)
				{
					printf("\nValue of the expression is t \n");
				}
				else
				{
					printf("\nValue of the expression is nil \n");
				}
			}
			//printf("\nValue of the expression is %d \n", $1.nval);
			return 0;
			}
			;
N_EXPR		: N_CONST
			{
			printRule("EXPR", "CONST");
			printf("sval %s", $1.sval);
			$$.type = $1.type;
			$$.nval=$1.nval;
			$$.sval=$1.sval;
			$$.bval=$1.bval;
			//if($1.type == INT)
			//{
			//	$$.nval=$1.nval;
			//	printf("Values of $$ and 1$ %d %d", $$.nval, $1.nval);
			//}
			//if($1.type == STR)
			//{
			//	$$.sval=$$.sval;
			//}


			}
                | T_IDENT
                {
			printRule("EXPR", "IDENT");
                string ident = string($1);
                TYPE_INFO exprTypeInfo = 
						findEntryInAnyScope(ident);
                if (exprTypeInfo.type == UNDEFINED) 
                {
                  yyerror("Undefined identifier");
                  return(0);
               	}
                $$.type = exprTypeInfo.type; 
			}
                | T_LPAREN N_PARENTHESIZED_EXPR T_RPAREN
                {
			printRule("EXPR", "( PARENTHESIZED_EXPR )");
			$$.type = $2.type; 
			$$.nval=$2.nval;
			$$.sval=$2.sval;
			if($$.type==BOOL)
			{
				$$.bval=$2.bval;
			}
			}
			;
N_CONST		: T_INTCONST
			{
			printRule("CONST", "INTCONST");
                $$.type = INT; 
				$$.nval = yylval.typeInfo.nval;
				$$.bval = true;
				printf("Values of $$ and 1$ %d %d", $$.nval, yylval.typeInfo.nval);
				
			}
                | T_STRCONST
			{
			printRule("CONST", "STRCONST");
                $$.type = STR;
				$$.sval = yylval.typeInfo.sval;
				$$.bval = true; 
			}
                | T_T
                {
			printRule("CONST", "t");
                $$.type = BOOL; 
				$$.bval = true;
			}
                | T_NIL
                {
			printRule("CONST", "nil");
			$$.type = BOOL;
			$$.bval = false;
			}
			;
N_PARENTHESIZED_EXPR	: N_ARITHLOGIC_EXPR 
				{
				printRule("PARENTHESIZED_EXPR",
                                "ARITHLOGIC_EXPR");
				$$.type = $1.type;
				$$.nval = $1.nval;
				$$.sval = $1.sval;
				if($$.type==BOOL)
				{
					$$.bval = $1.bval;
					printf("Bval %d", $$.bval);
				} 
				}
                      | N_IF_EXPR 
				{
				printRule("PARENTHESIZED_EXPR", "IF_EXPR");
				$$.type = $1.type; 
				}
                      | N_LET_EXPR 
				{
				printRule("PARENTHESIZED_EXPR", 
                                "LET_EXPR");
				$$.type = $1.type; 
				}
                      | N_PRINT_EXPR 
				{
				printRule("PARENTHESIZED_EXPR", 
					    "PRINT_EXPR");
				printf("Sval %s", $1.sval);
				$$.type = $1.type;
				$$.sval = $1.sval;
				$$.nval = $1.nval;
				$$.bval = $1.bval; 
				}
                      | N_INPUT_EXPR 
				{
				printRule("PARENTHESIZED_EXPR",
					    "INPUT_EXPR");
				$$.type = $1.type; 
				}
                     | N_EXPR_LIST 
				{
				printRule("PARENTHESIZED_EXPR",
				          "EXPR_LIST");
				$$.type = $1.type; 
				$$.sval = $1.sval;
				$$.nval = $1.nval;
				$$.bval = $1.bval;
				printf("sval %s", $1.sval);
				}
				;
N_ARITHLOGIC_EXPR	: N_UN_OP N_EXPR
				{
				printRule("ARITHLOGIC_EXPR", 
				          "UN_OP EXPR");
                      $$.type = BOOL; 
					  if($2.bval==false)
					  {
						  $$.bval=true;
					  }
					  else
					  {
						  $$.bval=false; 
					  }
					   printf("newVal %d", $$.bval);
				}
				| N_BIN_OP N_EXPR N_EXPR
				{
				printRule("ARITHLOGIC_EXPR", 
				          "BIN_OP EXPR EXPR");
                      $$.type = BOOL;
                      switch ($1)
                      {  
                      case (ARITHMETIC_OP) :
					    printf("ARTH\n\n");
                        $$.type = INT;
                        if (!isIntCompatible($2.type)) 
                        {
                          yyerror("Arg 1 must be integer");
                          return(0);
                     	  }
                     	  if (!isIntCompatible($3.type)) 
                        {
                          yyerror("Arg 2 must be integer");
                          return(0);
                     	  }
						if(arith.top()=='+')
						{
							$$.nval = $2.nval+$3.nval;
							printf("Values of $$ and 1$ %d %d\n\n", $$.nval, $3.nval);
							arith.pop();
						}
						else if(arith.top() == '-')
						{
							$$.nval = $2.nval-$3.nval;
							printf("Values of $$ and 1$ %d %d\n\n", $$.nval, $3.nval);
							arith.pop();
						}
						else if(arith.top()== '*')
						{
							$$.nval = $2.nval*$3.nval;
							printf("Values of $$ and 1$ %d %d\n\n", $$.nval, $3.nval);
							arith.pop();
						}
					    else if(arith.top()== '/')
						{
							if($3.nval==0)
							{ 
								yyerror("Attempted division by zero");
							}
							$$.nval = $2.nval/$3.nval;
							printf("Values of $$ and 1$ %d %d\n\n", $$.nval, $3.nval);
							arith.pop();
						}
                        break;

				      case (LOGICAL_OP) :
                        break;

                      case (RELATIONAL_OP) :
                        if (!isIntOrStrCompatible($2.type)) 
                        {
                          yyerror("Arg 1 must be integer or string");
                          return(0);
                        }
                        if (!isIntOrStrCompatible($3.type)) 
                        {
                          yyerror("Arg 2 must be integer or string");
                          return(0);
                        }
                        if (isIntCompatible($2.type) &&
                            !isIntCompatible($3.type)) 
                        {
                          yyerror("Arg 2 must be integer");
                          return(0);
                     	  }
                        else if (isStrCompatible($2.type) &&
                                 !isStrCompatible($3.type)) 
                        {
                               yyerror("Arg 2 must be string");
                               return(0);
                             }
						
						if ($2.type||$3.type ==STR)
						{
						   $$.bval = false;
						} 
						else if(rel.top()==">")
						{
							printf("2val %d 3val %d",$2.nval, $3.nval);
							if($2.nval>$3.nval)
							{
								$$.bval = true;
							}
							else
							{
								$$.bval = false;
							}
							rel.pop();
							printf("BVAL IN REL %d", $$.bval);
						}
					    else if(rel.top()=="<")
						{
							if ($2.nval < $3.nval)
							{
								$$.bval = true;
							}
							else
							{
								$$.bval = false;
							}
							rel.pop();
						}
						else if(rel.top()=="<=")
						{
							if ($2.nval <= $3.nval)
							{
								$$.bval = true;
							}
							else
							{
								$$.bval = false;
							}
							rel.pop();
						}
						else if(rel.top()==">=")
						{
							if ($2.nval >= $3.nval)
							{
								$$.bval = true;
							}
							else
							{
								$$.bval = false;
							}
							rel.pop();
						}
						else if(rel.top() == "=")
						{
							printf("val1 %d val2%d", $2.nval, $3.nval);
							if ($2.nval == $3.nval)
							{
								$$.bval = true;
							}
							else
							{
								$$.bval = false;
							}
							printf("Bval %d", $$.bval);
							rel.pop();
						}
						else if(rel.top() == "/=")
						{
							if ($2.nval != $3.nval)
							{
								$$.bval = true;
							}
							else
							{
								$$.bval = false;
							}
							rel.pop();
						}

                        break; 
                      }  // end switch
				}
                     	;
N_IF_EXPR    	: T_IF N_EXPR N_EXPR N_EXPR
			{
			printRule("IF_EXPR", "if EXPR EXPR EXPR");
                $$.type = $3.type | $4.type; 
			}
			;
N_LET_EXPR      : T_LETSTAR T_LPAREN N_ID_EXPR_LIST T_RPAREN 
                  N_EXPR
			{
			printRule("LET_EXPR", 
				    "let* ( ID_EXPR_LIST ) EXPR");
			endScope();
                $$.type = $5.type; 
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
                 TYPE_INFO exprTypeInfo = $4;
                 printf("___Adding %s to symbol table\n", $3);
                 bool success = scopeStack.top().addEntry
                                (SYMBOL_TABLE_ENTRY(lexeme,
									 exprTypeInfo));
                 if (! success) 
                 {
                   yyerror("Multiply defined identifier");
                   return(0);
                 }
			}
			;
N_PRINT_EXPR    : T_PRINT N_EXPR
			{
			printRule("PRINT_EXPR", "print EXPR");
			printf("Sval %s", $2.sval);
                $$.type = $2.type;
				$$.sval = $2.sval;
				$$.nval = $2.nval;
				$$.bval = $2.bval;
			}
			;
N_INPUT_EXPR    : T_INPUT
			{
			printRule("INPUT_EXPR", "input");
			$$.type = INT_OR_STR;
			}
			;
N_EXPR_LIST     : N_EXPR N_EXPR_LIST  
			{
			printRule("EXPR_LIST", "EXPR EXPR_LIST");
                $$.type = $2.type;
				$$.sval = $2.sval;
				$$.nval = $2.nval;
				$$.bval = $2.bval;
				printf("sval %s", $2.sval);
			}
                | N_EXPR
			{
			printRule("EXPR_LIST", "EXPR");
                $$.type = $1.type;
				$$.sval = $1.sval;
				$$.nval = $1.nval;
				$$.bval = $1.bval;
				printf("sval %s", $1.sval);

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
			arith.push('+');
			}
                | T_SUB
			{
			printRule("ARITH_OP", "-");
			arith.push('-');
			}
			| T_MULT
			{
			printRule("ARITH_OP", "*");
			arith.push('*');
			}
			| T_DIV
			{
			printRule("ARITH_OP", "/");
			arith.push('/');
			}
			;
N_REL_OP	     : T_LT
			{
			printRule("REL_OP", "<");
			rel.push("<");
			}	
			| T_GT
			{
			printRule("REL_OP", ">");
			rel.push(">");
			}
				
			| T_LE
			{
			printRule("REL_OP", "<=");
			rel.push("<=");
			}	
			| T_GE
			{
			printRule("REL_OP", ">=");
			rel.push(">=");
			}	
			| T_EQ
			{
			printRule("REL_OP", "=");
			rel.push("=");
			}	
			| T_NE
			{
			printRule("REL_OP", "/=");
			rel.push("/=");
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

bool isIntCompatible(const int theType) 
{
  return((theType == INT) || (theType == INT_OR_STR) ||
         (theType == INT_OR_BOOL) || 
         (theType == INT_OR_STR_OR_BOOL));
}

bool isStrCompatible(const int theType) 
{
  return((theType == STR) || (theType == INT_OR_STR) ||
         (theType == STR_OR_BOOL) || 
         (theType == INT_OR_STR_OR_BOOL));
}

bool isIntOrStrCompatible(const int theType) 
{
  return(isStrCompatible(theType) || isIntCompatible(theType));
}

void printRule(const char* lhs, const char* rhs) 
{
  printf("%s -> %s\n", lhs, rhs);
  return;
}

void beginScope() {
  scopeStack.push(SYMBOL_TABLE());
  printf("\n___Entering new scope...\n\n");
}

void endScope() {
  scopeStack.pop();
  printf("\n___Exiting scope...\n\n");
}

TYPE_INFO findEntryInAnyScope(const string theName) 
{
  TYPE_INFO info = {UNDEFINED};
  if (scopeStack.empty( )) return(info);
  info = scopeStack.top().findEntry(theName);
  if (info.type != UNDEFINED)
    return(info);
  else { // check in "next higher" scope
	   SYMBOL_TABLE symbolTable = scopeStack.top( );
	   scopeStack.pop( );
	   info = findEntryInAnyScope(theName);
	   scopeStack.push(symbolTable); // restore the stack
	   return(info);
  }
}

void cleanUp() 
{
  if (scopeStack.empty()) 
    return;
  else {
        scopeStack.pop();
        cleanUp();
  }
}

int main(int argc,char** argv) 
{
  if(argc<2)
  {
	  printf("You must specify a file in the command line!\n");
	  exit(1);
  }
  yyin = fopen(argv[1], "r");
  do {
	yyparse();
  } while (!feof(yyin));

  cleanUp();
  return 0;
}
