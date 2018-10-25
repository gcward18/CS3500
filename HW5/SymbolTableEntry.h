#ifndef SYMBOL_TABLE_ENTRY_H
#define SYMBOL_TABLE_ENTRY_H

#include <string>
using namespace std;
#define UNDEFINED -1

typedef struct{
	int type; 	// one of the above type codes
	int numParams;  // number of Parameters and return Type only applicable if type == FUNCTION
	int returnType;
} TYPE_INFO;

class SYMBOL_TABLE_ENTRY 
{
private:
  // Member variables
  string name;
  TYPE_INFO type;  

public:
  // Constructors
  SYMBOL_TABLE_ENTRY( ) { name = ""; type.type = UNDEFINED; }

  SYMBOL_TABLE_ENTRY(const string theName, const int tType, const int numPar, const int returnType) 
  {
    name            = theName;
    type.type       = tType;
    type.numParams  = numPar;
    type.returnType = returnType;
  }

  SYMBOL_TABLE_ENTRY(const string theName, const int theType) 
  {
    name            = theName;
    type.type       = theType;
    type.numParams  = UNDEFINED;
    type.returnType = UNDEFINED;
  }
  // Accessors
  string    getName()       const   { return name;            }
  TYPE_INFO getTypeCode()   const   { return type;            }
  int       getType()       const   { return type.type;       }
  int       getNumParams()  const   { return type.numParams;  }
  int       getReturnType() const   { return type.returnType; }
};

#endif  // SYMBOL_TABLE_ENTRY_H
