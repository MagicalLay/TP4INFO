/*
Contraintes, 4INFO
TP 8 : Histoire de menteurs

Leray Maud
Airiau Pierre-Marie
*/

:-lib(ic).
:-lib(ic_symbolic).


:- local domain(sexe(homme, femme)).

% Question 8.1 %

affirme(S,A) :- 
	(S &= femme) => (A #= 1).

% Question 8.2 %

affirme(S, A1, A2) :- 
	(S &= homme) => ((A1 #= 1 and A2#= 0) or (A1 #= 0 and A2 #= 1)).


% Question 8.3 %

poserVar(Enfant, Parent1, Parent2) :-
	Enfant &:: sexe,
	Parent1 &:: sexe,
	Parent2 &:: sexe.

% Question 8.4 %

labeling_sexe([]).
labeling_sexe([A|Reste]) :-
	ic_symbolic:indomain(A),
	labeling_sexe(Reste).

affirmations(Enfant, Parent1, Parent2) :-
	poserVar(Enfant, Parent1, Parent2),
	AffEselonP1 #:: 0..1,
	AffE #:: 0..1,
	Aff1P2 #:: 0..1,
	Aff2P2 #:: 0..1,
	AffP1 #:: 0..1,
	AffEselonP1 #= (Enfant &= femme),
	AffP1 #= (AffEselonP1 #= AffE),
	Aff1P2 #= (Enfant &= homme),
	Aff2P2 #= (AffE #= 0),
	Parent1 &\= Parent2,
	affirme(Enfant, AffE),
	affirme(Parent1, AffP1),
	affirme(Parent2, Aff1P2, Aff2P2),
	affirme(Parent2, Aff1P2 and Aff2P2),
	labeling([AffEselonP1,AffP1,AffE,Aff1P2,Aff2P2]),
	labeling_sexe([Enfant, Parent1, Parent2]).

% Results %
%?- affirmations(X, P1, P2).
%X = homme
%P1 = homme
%P2 = femme
%Yes (0.00s cpu, solution 1, maybe more)
%No (0.00s cpu)

	
