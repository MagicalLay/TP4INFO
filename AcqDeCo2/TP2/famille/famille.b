:- set(i,2).
:- set(verbose,1).

:- modeh(1,daughter(+person,+person)).

:- modeb(1,parent(+person,-person)).
:- modeb(1,parent(-person,+person)).
:- modeb(1,parent(+person,-person)).
:- modeb(1,parent(-person,+person)).
:- modeb(1,girl(+person)).
:- modeb(1,boy(+person)).


:- determination(daughter/2,girl/1).
:- determination(daughter/2,boy/1).
:- determination(daughter/2,parent/2).
:- determination(daughter/2,parent/2).
:- determination(daughter/2,son/2).


% type definitions
girl(ann).  
girl(mary).
girl(rosy).
girl(eve).
girl(lisa).

boy(tom).
boy(bob).

% family relations
parent(ann,mary).
parent(ann,tom).
parent(mary,rosy).
parent(tom,eve).
parent(tom,lisa).
parent(tom,bob).
