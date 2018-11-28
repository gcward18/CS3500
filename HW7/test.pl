letterGrade(X, 'A') :- X >= 90.
letterGrade(X, 'B') :- X < 90, X >= 80.
letterGrade(X, 'C') :- X < 80, X >= 70.
letterGrade(X, 'D') :- X < 70, X >= 60.
letterGrade(X, 'F') :- X < 60.


addOdds(N,0) :- N >= 20.
addOdds(N, Sum) :- N < 20, M is N+2, addOdds(M, SumM), Sum is N + SumM.
