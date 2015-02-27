%
% TP4 Contraintes 
% Les régates
%
% AIRIAU Pierre-Marie, LERAY Maud
%

:- lib(ic).
:- lib(ic_symbolic).

% Question 4.1 %

getData([5,5,2,1],4,[7,5,2],3,3).

% Question 4.2 %

defineVars(T, NbEquipes, NbConf, NbBateaux) :-
	getData(_,NbEquipes,_,NbBateaux,NbConf),
	dim(T,[NbEquipes,NbConf]).

% Question 4.3 %

getVarList(T, L) :-
	defineVars(T, NbEquipes,NbConf,_),
	(for(I,1,NbConf), param(T,L,NbEquipes)
	do
		(for(J,1,NbEquipes), fromto([],In,Out,L), param(T,I)
		do
			Y is T[J,I],
			append(In,Y,Out)
		)
	).

% Question 4.4 %

solve(T) :-
	getData(TailleEquipes,NbEquipes,CapaBateaux,NbBateaux,NbConf),
	defineVars(T, NbEquipes, NbConf, NbBateaux),
	(foreachelem(X,T), param(NbBateaux)
	do
		X::1..NbBateaux
	),
	labeling(T),
	getVarList(T,L).

/*
	getVarList(T,L),
	labeling(L).*/

/*
=============================
Tests
=============================

==> Question 4.1 

[eclipse 13]: getData(A,B,C,D,E).

A = [5, 5, 2, 1]
B = 4
C = [7, 5, 2]
D = 3
E = 3
Yes (0.00s cpu)

==> Question 4.2

[eclipse 19]: defineVars(T,4,3,3).

T = []([](_199, _200, _201), [](_203, _204, _205), [](_207, _208, _209), [](_211, _212, _213))
Yes (0.00s cpu)

*/

