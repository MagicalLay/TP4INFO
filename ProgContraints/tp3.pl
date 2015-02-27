%
% TP3 Contraintes 
% Ordonnancement de tâches sur deux machines
%
% AIRIAU Pierre-Marie, LERAY Maud
%

:- lib(ic).
:- lib(ic_symbolic).

:- local domain(machines(m1,m2)).

% Question 3.1 %

taches([](tache(3,[], m1, _),
	tache(8,[],m1, _),
	tache(8,[4,5],m1, _),
	tache(6,[],m2, _),
	tache(3,[1],m2, _),
	tache(4,[1,7],m1, _),
	tache(8,[3,5],m1, _),
	tache(6,[4],m2, _),
	tache(6,[6,7],m2, _),
	tache(6,[9,12],m2, _),
	tache(3,[1],m2, _),
	tache(6,[7,8],m2, _))).

% Question 3.2 %

ecrit_taches(Taches) :-
	taches(Taches),
	dim(Taches,[Dim]),
	(for(Indice, 1, Dim),
	param(Taches)
	do
		Var is Taches[Indice],
		writeln(Var)
	).

% Question 3.3 %

domaines(Taches,Fin) :-
	taches(Taches),
	dim(Taches,[Dim]),
	(for(Indice, 1, Dim),
	param(Fin, Taches)
	do
		tache(Duree,_,_,Debut) is Taches[Indice],
		Debut #> 0,		
		Fin #> Duree + Debut
	).

% Question 3.4 %

getVarList(Taches,Fin,List) :-
	taches(Taches),
	domaines(Taches,Fin),
	(foreachelem(tache(_,_,_,Debut),Taches),
	fromto([],In,Out,List)
	do
		append(In,[Debut],Out)
	).

% Question 3.5 %
/*
solve(Taches,Fin) :-
	taches(Taches),
	domaines(Taches,Fin),
	getVarList(Taches,Fin,List),
	labeling(List).*/

% Question 3.6 %
	
precedences(Taches) :-
	taches(Taches),
	(foreachelem(tache(_,Noms,_,Debut),Taches), param(Taches)
	do
		(foreach(X,Noms), param(Taches,Debut)
		do
			(tache(Duree2, _, _, Debut2) is Taches[X],
			Debut #>= Duree2 + Debut2
			)
		)
	).

% Question 3.7 %

conflits(Taches) :-
	dim(Taches,[IndiceMax]),
	(for(Indice,1,IndiceMax),
	param(Taches,IndiceMax)
	do
		(
		tache(Duree,_Noms,Machine,Debut) is Taches[Indice],
		IndiceSuiv is Indice+1,
		(for(Indice2,IndiceSuiv,IndiceMax),
		param(Taches,Duree,Machine,Debut)
		do
			(
			tache(Duree2, _Noms2, Machine2,Debut2) is Taches[Indice2],
			((Debut2 #>= Debut) and (Debut2 #< (Debut + Duree))) => (Machine &\= Machine2),
			((Debut #>= Debut2) and (Debut #< (Debut2 + Duree2))) => (Machine &\= Machine2)
			)
		)
	)
	).


% Question 3.8 (et solve des questions précédentes)%

solve(Taches,Fin) :-
	taches(Taches),
	domaines(Taches,Fin),
	precedences(Taches),
	conflits(Taches),
	Fin#<46,
	getVarList(Taches,Fin,List),
	labeling(List).

/* on a rajouté une contrainte, testée de manière empirique, pour obtenir la plus petite durée possible. Elle est de 45.
Sans, les premiers résultats retournés étaient de 51. */


/* TESTS

=> Question 3.1

[eclipse 14]: taches(X), Var is X[2].

X = [](tache(3, [], m1, _347), tache(8, [], m1, _352), tache(8, [4, 5], m1, _357), tache(6, [], m2, _366), tache(3, [1], m2, _371), tache(4, [1, 7], m1, _378), tache(8, [3, 5], m1, _387), tache(6, [4], m2, _396), tache(6, [6, 7], m2, _403), tache(6, [9, 12], m2, _412), tache(3, [1], m2, _421), tache(6, [7, 8], m2, _428))
Var = tache(8, [], m1, _352)
Yes (0.00s cpu)

=> Question 3.2

[eclipse 52]: ecrit_taches(X).
tache(3, [], m1, _181)
tache(8, [], m1, _186)
tache(8, [4, 5], m1, _191)
tache(6, [], m2, _200)
tache(3, [1], m2, _205)
tache(4, [1, 7], m1, _212)
tache(8, [3, 5], m1, _221)
tache(6, [4], m2, _230)
tache(6, [6, 7], m2, _237)
tache(6, [9, 12], m2, _246)
tache(3, [1], m2, _255)
tache(6, [7, 8], m2, _262)

X = [](tache(3, [], m1, _181), tache(8, [], m1, _186), tache(8, [4, 5], m1, _191), tache(6, [], m2, _200), tache(3, [1], m2, _205), tache(4, [1, 7], m1, _212), tache(8, [3, 5], m1, _221), tache(6, [4], m2, _230), tache(6, [6, 7], m2, _237), tache(6, [9, 12], m2, _246), tache(3, [1], m2, _255), tache(6, [7, 8], m2, _262))
Yes (0.00s cpu)

=> Question 3.4

[eclipse 82]: getVarList(Tab,10,List).

Tab = [](tache(3, [], m1, _315{1 .. 6}), tache(8, [], m1, 1), tache(8, [4, 5], m1, 1), tache(6, [], m2, _599{1 .. 3}), tache(3, [1], m2, _691{1 .. 6}), tache(4, [1, 7], m1, _783{1 .. 5}), tache(8, [3, 5], m1, 1), tache(6, [4], m2, _971{1 .. 3}), tache(6, [6, 7], m2, _1063{1 .. 3}), tache(6, [9, 12], m2, _1155{1 .. 3}), tache(3, [1], m2, _1247{1 .. 6}), tache(6, [7, 8], m2, _1339{1 .. 3}))
List = [_315{1 .. 6}, 1, 1, _599{1 .. 3}, _691{1 .. 6}, _783{1 .. 5}, 1, _971{1 .. 3}, _1063{1 .. 3}, _1155{1 .. 3}, _1247{1 .. 6}, _1339{1 .. 3}]
Yes (0.00s cpu)

=> Question 3.5

[eclipse 83]: solve(Taches,Fin).
lists.eco  loaded in 0.00 seconds

Taches = [](tache(3, [], m1, 1), tache(8, [], m1, 1), tache(8, [4, 5], m1, 1), tache(6, [], m2, 1), tache(3, [1], m2, 1), tache(4, [1, 7], m1, 1), tache(8, [3, 5], m1, 1), tache(6, [4], m2, 1), tache(6, [6, 7], m2, 1), tache(6, [9, 12], m2, 1), tache(3, [1], m2, 1), tache(6, [7, 8], m2, 1))
Fin = Fin{10 .. 1.0Inf}
Yes (0.00s cpu, solution 1, maybe more) ? ;

Taches = [](tache(3, [], m1, 1), tache(8, [], m1, 1), tache(8, [4, 5], m1, 1), tache(6, [], m2, 1), tache(3, [1], m2, 1), tache(4, [1, 7], m1, 1), tache(8, [3, 5], m1, 1), tache(6, [4], m2, 1), tache(6, [6, 7], m2, 1), tache(6, [9, 12], m2, 1), tache(3, [1], m2, 1), tache(6, [7, 8], m2, 2))
Fin = Fin{10 .. 1.0Inf}
Yes (0.00s cpu, solution 2, maybe more) ? ;

=> Question 3.6

[eclipse 3]: solve(X,Fin).
lists.eco  loaded in 0.00 seconds

X = [](tache(3, [], m1, 1), tache(8, [], m1, 1), tache(8, [4, 5], m1, 7), tache(6, [], m2, 1), tache(3, [1], m2, 4), tache(4, [1, 7], m1, 23), tache(8, [3, 5], m1, 15), tache(6, [4], m2, 7), tache(6, [6, 7], m2, 27), tache(6, [9, 12], m2, 33), tache(3, [1], m2, 4), tache(6, [7, 8], m2, 23))
Fin = Fin{40 .. 1.0Inf}
Yes (0.01s cpu, solution 1, maybe more) ? ;

X = [](tache(3, [], m1, 1), tache(8, [], m1, 1), tache(8, [4, 5], m1, 7), tache(6, [], m2, 1), tache(3, [1], m2, 4), tache(4, [1, 7], m1, 23), tache(8, [3, 5], m1, 15), tache(6, [4], m2, 7), tache(6, [6, 7], m2, 27), tache(6, [9, 12], m2, 33), tache(3, [1], m2, 4), tache(6, [7, 8], m2, 24))
Fin = Fin{40 .. 1.0Inf}
Yes (0.01s cpu, solution 2, maybe more) ? ;

==> Question 3.7

[eclipse 5]: solve(X,Fin).

X = [](tache(3, [], m1, 1), tache(8, [], m1, 4), tache(8, [4, 5], m1, 12), tache(6, [], m2, 1), tache(3, [1], m2, 7), tache(4, [1, 7], m1, 28), tache(8, [3, 5], m1, 20), tache(6, [4], m2, 10), tache(6, [6, 7], m2, 32), tache(6, [9, 12], m2, 44), tache(3, [1], m2, 16), tache(6, [7, 8], m2, 38))
Fin = Fin{51 .. 1.0Inf}
Yes (0.01s cpu, solution 1, maybe more) ? ;

X = [](tache(3, [], m1, 1), tache(8, [], m1, 4), tache(8, [4, 5], m1, 12), tache(6, [], m2, 1), tache(3, [1], m2, 7), tache(4, [1, 7], m1, 28), tache(8, [3, 5], m1, 20), tache(6, [4], m2, 10), tache(6, [6, 7], m2, 32), tache(6, [9, 12], m2, 44), tache(3, [1], m2, 17), tache(6, [7, 8], m2, 38))
Fin = Fin{51 .. 1.0Inf}
Yes (0.01s cpu, solution 2, maybe more) ? ;

==> Question 3.8

[eclipse 9]: solve(X,Fin).

X = [](tache(3, [], m1, 1), tache(8, [], m1, 30), tache(8, [4, 5], m1, 10), tache(6, [], m2, 1), tache(3, [1], m2, 7), tache(4, [1, 7], m1, 26), tache(8, [3, 5], m1, 18), tache(6, [4], m2, 10), tache(6, [6, 7], m2, 32), tache(6, [9, 12], m2, 38), tache(3, [1], m2, 16), tache(6, [7, 8], m2, 26))
Fin = 45
Yes (0.00s cpu, solution 1, maybe more) ? ;


*/
