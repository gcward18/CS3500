/*
    Definitions of constants, variables and functions
*/
%{
# define    T_IDENT             1
# define    T_INTEGER_CONSTANT  2
# define    T_STRING_CONSTANT   3
# define    T_UKNOWN            4

// Returns number of lines that are processed
int numLines    =   0;

// Print function to let user know the tokens that are captured
void printTokenInfo(const char* tokenType, char* lexeme);

%}

/* Definitions of regular expressions */

/* Numbers and characters */
DIGIT       [0-9]
MANYDIGITS  [0-9]*
ANYCHAR     \w
LOWERCASE   [a-z]
UPPERCASE   [A-Z]

/* Special Characters */
UNDERSCR    _
INTCONST    ([-+ ]|[0-9])[0-9]+
WHITESPACE  [ \n\t\s]
IDENTCONST  [_a-zA-Z][0-9a-zA-Z_]*
STRCONST    ["][a-zA-Z0-9_!@#$%^&*]*["]
%%

{WHITESPACE}    {
                return T_UKNOWN;
}
"lambda"        {
                printTokenInfo("LAMBDA", yytext);
                return T_IDENT;
} 
"let*"          {
                printTokenInfo("LETSTAR", yytext);
                return T_IDENT;
}
"("             {
                printTokenInfo("LPAREN", yytext);
                return T_IDENT;
}
")"             {
                printTokenInfo("RPAREN", yytext);
                return T_IDENT;
}
"input"         {
                printTokenInfo("INPUT", yytext);
                return T_IDENT;
}
"print"         {
                printTokenInfo("PRINT", yytext);
                return T_IDENT;
}
"if"            {
                printTokenInfo("IF", yytext);
                return T_IDENT;
}
"+"             {
                printTokenInfo("ADD", yytext);
                return T_IDENT;
}
"*"             {
                printTokenInfo("MULTI", yytext);
                return T_IDENT;
}
"/"             {
                printTokenInfo("DIV", yytext);
                return T_IDENT;
}
"-"             {
                printTokenInfo("SUB", yytext);
                return T_IDENT;
}
"and"           {
                printTokenInfo("AND", yytext);
                return T_IDENT;
}
"or"            {
                printTokenInfo("OR", yytext);
                return T_IDENT;
}
"not"           {
                printTokenInfo("NOT", yytext);
                return T_IDENT;
}
"<"             {
                printTokenInfo("LT", yytext);
                return T_IDENT;
}
">"             {
                printTokenInfo("GT", yytext);
                return T_IDENT;
}
"<="            {
                printTokenInfo("LE", yytext);
                return T_IDENT;
}
">="            {
                printTokenInfo("GE", yytext);
                return T_IDENT;
}
"="             {
                printTokenInfo("EQ", yytext);
                return T_IDENT;
}
"/="            {
                printTokenInfo("NE", yytext);
                return T_IDENT;
}
{INTCONST}      {
                printTokenInfo("INTCONST", yytext);
                return T_INTEGER_CONSTANT;
}
{IDENTCONST}    {
                printTokenInfo("IDENT", yytext);
                return T_STRING_CONSTANT;
}
{STRCONST}      {
                printTokenInfo("STRCONST", yytext);
                return T_STRING_CONSTANT;
}
.               {
                printTokenInfo("UNKNOWN", yytext);
                return T_UKNOWN;
}

%%

void printTokenInfo(const char* tokenType, char* leme) {
    printf("TOKEN: %s LEMEME: %s\n", tokenType, leme);
}

int yywrap(void) {
    return 1;
}

int main(void) {
    while ( yylex() );

    printf("Processed %d lines\n", numLines);
    return 0;
}
