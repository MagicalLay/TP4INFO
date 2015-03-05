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
	defineVars(T, NbEquipes, NbConf, _),
	dim(T,[NbEquipes,NbConf]),
	getVarList(T,L),
	labeling(L).

% Question 4.5 %

pasMemeBateaux(T, NbEquipes, NbConf) :-
	getData(_, NbEquipes, _, _, NbConf),
	dim(T,[NbEquipes,NbConf]),
        (for(N,1,NbEquipes),param(T)
         do(
         	A is T[N,1],
         	B is T[N,2],
         	C is T[N,3],
     		ic:alldifferent([A, B, C])
            )
        ).
        

solve2(T) :-
	defineVars(T, NbEquipes, NbConf, _),
	pasMemeBateaux(T, NbEquipes, NbConf),
	getVarList(T,L),
	labeling(L).

% Question 4.6 %

pasMemePartenaires(T, NbEquipes, NbConf):-
        (for(E1,1,NbEquipes), param(T,NbConf, NbEquipes)
        do
            (for(E2,E1+1, NbEquipes), param(T, NbConf, E1)
                                      do
                (for(C1,1,NbConf), param(T, E1, E2, NbConf)
                                   do
                    (for(C2, C1+1, NbConf), param(T, E1, E2, C1)
                                            do
                        (T[E1,C1] #= T[E2,C1]) => (T[E1,C2] #\= T[E2,C2])
                    )
                )
            )
        ).

/*
pasMemePartenaires(T, NbEquipes, NbConf) :-
	getData(_, NbEquipes, _, _, NbConf),
	dim(T,[NbEquipes,NbConf]),
	defineVars(T, NbEquipes, NbConf, _),
	(multifor([N,M],[1,1],[NbEquipes,NbEquipes]),param(T,NbConf)
	do(
		==(N,M);
		X is 0,
		(for(J,1,NbConf),param(T,N,M,X)
		do(
			Y is T[N,J],
			Z is T[M,J],
			\==(Y,Z);
			Y is T[N,J],
			Z is T[M,J],
			==(Y,Z),
			X is X+1
		)),
		=<(X,1)
	)).

pasMemePartenaires(T, NbEquipes, NbConf) :-
	getData(_, NbEquipes, _, _, NbConf),
	dim(T,[NbEquipes,NbConf]),
	A is T[N,J],
	B is T[M,J],
	\==(N,M),
	==(A,B),
	E is T[N,C],
	F is T[M,C],
	\==(C,J),
	\==(E,F).*/

solve3(T) :-
	defineVars(T, NbEquipes, NbConf, _),
	pasMemeBateaux(T, NbEquipes, NbConf),
	getVarList(T,L),
	pasMemePartenaires(T, NbEquipes, NbConf),
	labeling(L).		

% Question 4.7 %

nbBatConf(T, Conf, Bateau, NbPers, TailleEquipes, NbEquipes) :-
	NbPers is 0,
	(for(Y,1, NbEquipes),param(T,Conf,Bateau,TailleEquipes, NbPers)
	do(
		X is T[Y,Conf],
		==(X,Bateau),
		A is TailleEquipes[Y],
		NbPers is NbPers + A;
		X is T[Y,Conf],
		\==(X,Bateau)
		)
	).
/*
capaBateaux(T, TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf) :-
	(for(I,1,NbConf),param()
	do(
		
		)
	)
*/
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

==> Question 4.5

?- solve2(T).
T = []([](3, 2, 1), [](3, 2, 1), [](3, 2, 1), [](3, 2, 1))
Yes (0.00s cpu, solution 1, maybe more)
T = []([](2, 3, 1), [](3, 2, 1), [](3, 2, 1), [](3, 2, 1))
Yes (0.00s cpu, solution 2, maybe more)
T = []([](3, 2, 1), [](2, 3, 1), [](3, 2, 1), [](3, 2, 1))
Yes (0.00s cpu, solution 3, maybe more)

==> Question 4.6

?- solve3(T).
T = []([](1, 3, 2), [](3, 1, 2), [](2, 3, 1), [](3, 2, 1))
Yes (0.00s cpu, solution 1, maybe more)
T = []([](3, 1, 2), [](1, 3, 2), [](2, 3, 1), [](3, 2, 1))
Yes (0.05s cpu, solution 2, maybe more)
T = []([](1, 3, 2), [](3, 1, 2), [](3, 2, 1), [](2, 3, 1))
Yes (0.05s cpu, solution 3, maybe more)

*/

