
cat(sylvester).
cat(felix).
dog(spike).
dog(fido).
primate(george).
primate("king kong").
bird(tweety).
hawk(tony).
fish(nemo).


mammal(X):-cat(X).
mammal(X):-dog(X).
mammal(X):-primate(X).

animal(X):-mammal(X).
animal(X):-bird(X).
animal(X):-fish(X).

bird(X):-hawk(X).

covering(X, "fur")      :-mammal(X).
covering(X, "feathers") :-bird(X).
covering(X, "scales")   :-fish(X).

legs(X,"2")		:-mammal(X),primate(X).

legs(X,"4")             :-mammal(X),\+primate(X).
legs(X,"2")             :-bird(X).
legs(X,"0")             :-fish(X).


sound(X,purr)           :-cat(X).
sound(X,bark)           :-dog(X).
