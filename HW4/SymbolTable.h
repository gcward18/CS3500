#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <map>
#include <string>
#include "SymbolTableEntry.h"
using namespace std;

class SYMBOL_TABLE 
{
private:
  std::map<string, SYMBOL_TABLE_ENTRY> hashTable;

public:
  //Constructor
  SYMBOL_TABLE( ) { }

  // Add SYMBOL_TABLE_ENTRY x to this symbol table.
  // If successful, return true; otherwise, return false.
  bool addEntry(SYMBOL_TABLE_ENTRY x) 
  {
    // Make sure there isn't already an entry with the same name
    map<string, SYMBOL_TABLE_ENTRY>::iterator itr;
    if ((itr = hashTable.find(x.getName())) == hashTable.end()) 
    {
      hashTable.insert(make_pair(x.getName(), x));
      return(true);
    }
    else return(false);
  }

  // If a SYMBOL_TABLE_ENTRY with name theName is
  // found in this symbol table, then return true;
  // otherwise, return false.
  bool findEntry(string theName) 
  {
    map<string, SYMBOL_TABLE_ENTRY>::iterator itr;
    if ((itr = hashTable.find(theName)) == hashTable.end())
      return(false);
    else return(true);
  }

    // If a SYMBOL_TABLE_ENTRY with name theName is
  // found in this symbol table, then return the entry type
  int getType(string theName) 
  {
    return hashTable[theName].getType();
  }

  // If a SYMBOL_TABLE_ENTRY with name theName is
  // found in this symbol table, then return the entry numParams
  int getNumParams(string theName) 
  {
    return hashTable[theName].getNumParams();
  }

  // If a SYMBOL_TABLE_ENTRY with name theName is
  // found in this symbol table, then return the entry returnType
  int getReturnType(string theName) 
  {
    return hashTable[theName].getReturnType();
  }

  // get the number of bytes in the stack
  int getSize()
  {
    return hashTable.size();
  }
};

#endif  // SYMBOL_TABLE_H
