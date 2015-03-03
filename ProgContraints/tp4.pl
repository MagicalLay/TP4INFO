%
% TP4 Contraintes 
% Les régates
%
% AIRIAU Pierre-Marie, LERAY Maud
%

:- lib(ic).
:- lib(ic_symbolic).
% Question 4.1 %

getData(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf):-
        TailleEquipes = [](5,5,2,1),
        CapaBateaux= [](7,6,5),
        dim(TailleEquipes, [NbEquipes]),
        dim(CapaBateaux,[NbBateaux]),
        NbConf is 3.

% Question 4.2 %

defineVars(T, NbEquipes, NbConf, NbBateaux) :-
	getData(_, NbEquipes, _, NbBateaux, NbConf),
	dim(T,[NbEquipes,NbConf]),
	T #:: 1..NbBateaux.

% Question 4.3 %

getVarList(T, L) :-
        dim(T,[NbEquipes,NbConf]),
        (multifor([I,J],[1,1],[NbConf,NbEquipes]),
         param(T),
         fromto([], In, Out, L)
         do
            (V is T[J,I],
             Out = [V|In]
            )   
        ).
        /*
	(for(I,1,NbConf), param(T,L,NbEquipes)
	do
		(for(J,1,NbEquipes), param(T, I), fromto([],In,Out,L)
		do
			(Y is T[J,I],
			Out = [Y|In]
			)
		)
	).*/

% Question 4.4 %

solve(T) :-
	defineVars(T, _, _, _),
	getVarList(T,L),
	labeling(L).

% Question 4.5 %

pasMemeBateaux(T, NbEquipes, NbConf) :-
	dim(T,[NbEquipes,NbConf]),
	getVarList(T,L),
        (foreach(Elem,L)
         do(
            ic_symbolic:alldifferent(Elem))
        ).

solve2(T) :-
	defineVars(T, NbEquipes, NbConf, _),
	getVarList(T,L),
	pasMemeBateaux(T, NbEquipes, NbConf),
	labeling(L).
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

==> Question 4.4

?- solve(T).
T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 1))
Yes (0.00s cpu, solution 1, maybe more)
T = []([](2, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 1))
Yes (0.00s cpu, solution 2, maybe more)
T = []([](3, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 1))
Yes (0.00s cpu, solution 3, maybe more)
T = []([](1, 1, 1), [](2, 1, 1), [](1, 1, 1), [](1, 1, 1))
Yes (0.02s cpu, solution 4, maybe more)
*/

