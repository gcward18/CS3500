#include <iostream>
#include <string>
using namespace std;

int isPrime(int n, int i=2)
{
    if ( n == i)
        return true;
    if ( n % i == 0 )
        return false;
    else
        return isPrime(n, i+1);
}

int countPrimes(int n, int c=0)
{
    if(n <= 2)
        return 1;
    else if(isPrime(n))
        return c + countPrimes(n-1, c++);
    else
        return c + countPrimes(n-1, c);
}

string convertToString(int n)
{
    return to_string(n);
}

int convertToInt(string s)
{
    return stoi(s);
}

string rotate(string s)
{
    cout << s << endl;
    
    if(s.length() <= 1)
        return s;
    else 
        return s.substr(1) + s.at(0);
}
int main(void)
{
    cout << rotate("45") << endl;
}