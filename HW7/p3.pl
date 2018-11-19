motive(insanity).
motive(money).
motive(jealousy).

access(X):-weapon_access(X),key_access(X),crime_access(X).


key_access(davis).
key_access(X):-stay  (X,monday   ,"cs office").
crime_access(X):-stay(X,thursday ,"book store").
crime_access(X):-stay(X,friday   ,"book store").

stay(fu, monday, csOffice).
stay(fu, tuesday, csOffice).
stay(fu, wednesday, lab).
stay(fu, thursday, csOffice).
stay(fu, friday, bookstore).
stay(mcmillin, monday, lab).
stay(mcmillin, tuesday, lab).
5stay(mcmillin, wednesday, lab).
stay(mcmillin, thursday, csOffice).
stay(mcmillin, friday, bookstore).
stay(das, monday, bookstore).
stay(das, tuesday, lab).
stay(das, wednesday, bookstore).
stay(das, thursday, bookstore).
stay(das, friday, bookstore).
stay(davis, monday, bookstore).
stay(davis, tuesday, lab).
stay(davis, wednesday, lab).
stay(davis, thursday, csOffice).
stay(davis, friday, bookstore).
stay(sabharwal, monday, bookstore).
stay(sabharwal, tuesday, bookstore).
stay(sabharwal, wednesday, csOffice).
stay(sabharwal, thursday, bookstore).
stay(sabharwal, friday, bookstore).
stay(markowsky, monday, bookstore).
stay(markowsky, tuesday, lab).
stay(markowsky, wednesday, lab).
stay(markowsky, thursday, bookstore).
stay(markowsky, friday, bookstore).
stay(price, monday, csOffice).
stay(price, tuesday, csOffice).
stay(price, wednesday, lab).
stay(price, thursday, csOffice).
stay(price, friday, bookstore).
stay(tauritz, monday, bookstore).
stay(tauritz, tuesday, csOffice).
stay(tauritz, wednesday, csOffice).
stay(tauritz, thursday, csOffice).
stay(tauritz, friday, bookstore).

victim(leopold).


insane(sabharwal).
insane(tauritz).

poor(davis).
poor(fu).
poor(tauritz).
