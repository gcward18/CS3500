notGoodToEat(X) :-soldAt(X, Y), skeevyPlace(Y), expirationDate(X, Z), Z > 60.
skeevyPlace(Y) :-sells(Y, gas).
soldAt(X, gasStation) :-color(yellow, X),\+ animal(X).
soldAt(X, farmersMarket) :-\+ color(yellow, X). 
sells(gasStation, gas).   
color(yellow, twinkies).
color(yellow, myCat).
color(green, soylentGreen). % Soylent Green is people!!!
expirationDate(twinkies, 999).
expirationDate(soylentGreen, 666).
animal(myCat).  

%FORWARD CHAINING - Start at the end result and work your way back up
% if X is not good to eat then then X is sold at Y, Y is a 
% skeevy place and the expirationDate of X is Z, Z is greater than 60.
notGoodToEat(X) :- soldAt(X,Y), skeevyPlace(Y), expirationDate(X,Z).

% if X is sold at gasStation, the color of X is yellow and X is not
% an animal
soldAt(X, gasStation) :-color(yellow, X),\+ animal(X).

% if X is sold at farmers market and color of X is not yellow
soldAt(X, farmersMarket) :-\+ color(yellow, X). 

% FACT Color of twinkies is yellow
color(yellow, twinkies).
% therefore the farmers market rule is negated


% if Y is a skeevy place then Y sells gas
skeevyPlace(Y) :-sells(Y, gas).
% yet another reason its not the farmers market

% if expiration date of X is Z and Z > 60 then this statement is true
expirationDate(twinkies, 999).
expirationDate(soylentGreen, 666).
% both of these statements hold true, but soylentGreens color is green, not yellow

% animal my cat is not reached in this expression
animal(myCat).  
                              ____________________________ notGoodToEat(X)______________________________
                            /                                   |                                       \   
                           /                                    |                                        \
               soldAt(X, Y)                                 skeevyPlace(Y)                         expirationDate(X, Z),      
              /           \                                          \                                    Z > 60
             /             \                                       sells(Y, gas).                           |
soldAt(X,farmersMarket)   soldAt(X, gasStation)                         \                                 expirationDate(twinkies, 999).
-\+ color(yellow, X)       color(yellow, X),                            sells(gasStation, gas).                   ^
    |                        \+ animal(X).      twinky ! animal                                                 TRUE
    |                          |                    \                         ^
    X                          |                     x                      TRUE
    |                          |                      \
color(yellow, twinkies).   color(yellow, twinkies).   animal(X)
                                        
                        ^
                      TRUE
ALL STATEMENTS ARE TRUE, THUS TWINKIES ARE NOT GOOD TO EAT...... THEY MAY BE DELCIOUS BUT THEY ARE NOT NUTRITIOUS

BACKWARDS CHAINING: Start at the end r