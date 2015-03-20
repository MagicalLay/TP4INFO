/*
Contraintes, 4INFO
TP 6 : Contraindre puis chercher

Leray Maud
Airiau Pierre-Marie
*/

:- lib(ic).
:- lib(branch_and_bound).

% Question 6.1 %

places(X) :-
	dim(X,[10]),
	X #:: [-8.. -1,1.. 8],
	ic:alldifferent(X).

poids([](24,39,85,60,165,6,32,123,7,14)).

produitVect(X,Y,R) :-
	dim(X,Dim),
	dim(Y,Dim),
	dim(R,Dim),
	(foreachelem(A, X), foreachelem(B, Y), foreachelem(C, R) 
	do
		C #= A * B
	).

sommeVect(X,R) :- 
	(foreachelem(N,X), fromto(0,In,Out,R)
	do(
		Out#=In+N
	)).

moment(Moment, PlacesTemp) :-
	dim(Moment,[10]),
	poids(Poids),
	places(PlacesTemp),
	labeling(PlacesTemp),
	dim(Places,[10]),
	(for(I, 1, 10), param(PlacesTemp, Places)
	do(
		Y is PlacesTemp[I],
		abs(Y, Abs),
		Places[I] #= Abs
	)),
	produitVect(Poids, Places, Moment).


momentSigne(Moment, Places) :-
	dim(Moment,[10]),
	poids(Poids),
	places(Places),
	produitVect(Poids, Places, Moment).

% Le prédicat equilibre réalise la contrainte numéro 1

equilibre(Places, Moment) :-
	momentSigne(Moment, Places),
	sommeVect(Moment, Res),
	Res #= 0.

% Le prédicat encadrement réalise à la fois les contraintes numéro 2 et 3

encadrement(Places) :-
	places(Places),
	Maman is Places[4],
	Papa is Places[8],
	ic:min(Places,Min),
	ic:max(Places,Maximum),
        (Papa #= Min) or (Papa #= Maximum),
        (Maman #= Min) or (Maman #= Maximum),
        Dan is Places[6],
	Max is Places[9],
        (Dan #= Min + 1) or (Dan #= Maximum - 1),
        (Max #= Min + 1) or (Max #= Maximum - 1).

% Le prédicat repartition réalise la contrainte numéro 4

repartition(Places) :-
	places(Places),
	(foreachelem(Elem, Places), fromto(0,In1,Out1,Res1), fromto(0,In2,Out2,Res2)
	do(
		Out1 #= In1 + 1*(Elem > 0),
		Out2 #= In2 + 1*(Elem < 0)
	)),
	Res1 #= Res2.

% Question 6.2 %

solve(Places,Moment) :-
	equilibre(Places,Moment),
	repartition(Places),
	encadrement(Places),
	labeling(Places).

% Question 6.3 %
	
antisymetrie(Places) :-
	Papa is Places[8],
	Papa #< 0.

% On remarque une symétrie entre le papa et la maman, il faut donc forcer la place de l'un des deux afin d'empêcher la symétrie dans les résultats.
% Cela a pour conséquence de diviser par deux le nombre de résultats au problème.

solve2(Places,Moment) :-
	equilibre(Places,Moment),
	repartition(Places),
	encadrement(Places),
	antisymetrie(Places),
	labeling(Places).

% Question 6.4 %

% Nous n'avons pas vu comment appliquer le prédicat minimize dans le cas présent. Nous n'avons donc pas pu terminer le TP.

/*************
Tests
**************

=> Question 6.1

[eclipse 80]: moment(X,Y).
X = [](192, 273, 510, 300, 660, 18, 64, 123, 7, 28)
Y = [](-8, -7, -6, -5, -4, -3, -2, -1, 1, 2)
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [](192, 273, 510, 300, 660, 18, 64, 123, 7, 42)
Y = [](-8, -7, -6, -5, -4, -3, -2, -1, 1, 3)
Yes (0.00s cpu, solution 2, maybe more) ? 

// les tests de equilibre, repartition et encadrement sont réalisés avec un labeling interne

[eclipse 75]: equilibre(X,Moment).
X = [](-8, -7, -6, -5, 1, -2, 3, 8, -4, 5)
Moment = [](-192, -273, -510, -300, 165, -12, 96, 984, -28, 70)
Yes (9.70s cpu, solution 1, maybe more) ? ;
X = [](-8, -7, -6, -5, 1, -2, 4, 7, 3, 8)
Moment = [](-192, -273, -510, -300, 165, -12, 128, 861, 21, 112)
Yes (9.73s cpu, solution 2, maybe more) ? 

[eclipse 78]: repartition(Places).
Places = [](-8, -7, -6, -5, -4, 1, 2, 3, 4, 5)
Yes (0.41s cpu, solution 1, maybe more) ? ;
Places = [](-8, -7, -6, -5, -4, 1, 2, 3, 4, 6)
Yes (0.41s cpu, solution 2, maybe more) ? ;
Places = [](-8, -7, -6, -5, -4, 1, 2, 3, 4, 7)
Yes (0.41s cpu, solution 3, maybe more) ? ;
Places = [](-8, -7, -6, -5, -4, 1, 2, 3, 4, 8)
Yes (0.41s cpu, solution 4, maybe more) ? ;

?- encadrement(Places).
Places = [](-6, -5, -4, -8, -3, -7, -2, 2, 1, -1)
Yes (0.05s cpu, solution 1, maybe more)
Places = [](-6, -5, -4, -8, -3, -7, -2, 3, 2, -1)
Yes (0.06s cpu, solution 2, maybe more)
Places = [](-6, -5, -4, -8, -3, -7, -2, 3, 2, 1)
Yes (0.06s cpu, solution 3, maybe more)
Places = [](-6, -5, -4, -8, -3, -7, -2, 4, 3, -1)
Yes (0.08s cpu, solution 4, maybe more)

=> Question 6.2

?- solve(Places).
Places = [](-6, -5, -4, -8, 2, 5, 3, 6, -7, 1)
Yes (0.16s cpu, solution 1, maybe more)
Places = [](-6, -5, -1, 8, 5, 7, 3, -8, -7, 1)
Yes (0.19s cpu, solution 2, maybe more)
Places = [](-6, -5, 1, -8, -2, 6, 5, 7, -7, 4)
Yes (0.19s cpu, solution 3, maybe more)
Places = [](-6, -5, 2, 8, 4, -7, -2, -8, 7, 5)
Yes (0.20s cpu, solution 4, maybe more)

=> Question 6.3

[eclipse 4]: solve2(Places, Moment).

Places = [](-6, -5, -1, 8, 5, 7, 3, -8, -7, 1)
Moment = [](-144, -195, -85, 480, 825, 42, 96, -984, -49, 14)
Yes (0.02s cpu, solution 1, maybe more) ? ;
Places = [](-6, -5, 2, 8, 4, -7, -2, -8, 7, 5)
Moment = [](-144, -195, 170, 480, 660, -42, -64, -984, 49, 70)
Yes (0.03s cpu, solution 2, maybe more) ? ;
Places = [](-6, -5, 2, 8, 4, 7, -2, -8, -7, 6)
Moment = [](-144, -195, 170, 480, 660, 42, -64, -984, -49, 84)
Yes (0.03s cpu, solution 3, maybe more) ? 

*/


