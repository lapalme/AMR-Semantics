:-encoding(utf8).
%%% utility predicates 

reduce(Arg^Expr,Arg,Expr). % one-level beta-reduction

%%  Variable projection

%% keep only an occurrence of a var that is repeated
keepRepeatedVars([],[]).
keepRepeatedVars([X|Xs],[X|Xs2]):-member(X,Xs),!,delete(Xs,X,Xs1),keepRepeatedVars(Xs1,Xs2).
keepRepeatedVars([_|Xs],Xs1):-keepRepeatedVars(Xs,Xs1).

% project variables and adding \ in front of the definition of the instance
projectVars(Px,_,Px):-
    atomic(Px),!.
projectVars([C,X|Roles],Vars,[C,\X|Projs]):- % projeter
    member(X,Vars),!,
    maplist(projectVarsRole(Vars),Roles,Projs).
projectVars([C,X|Roles],Vars,[C,X|Projs]):-
    maplist(projectVarsRole(Vars),Roles,Projs).

projectVarsRole(Vars,[Ri,Ai],[Ri,ProjAi]):-
    projectVars(Ai,Vars,ProjAi).


%% check if a role name is inverse
isInvRole(Role):-
    atom_concat(_,'-of',Role),
    % check for "ordinary" roles terminating by "-of"
    \+memberchk(Role,[':consist-of',':domain-of',':part-of',':polarity-of',':subevent-of',
                         ':prep-on-behalf-of',':prep-out-of']).

%% tools for Continuation semantics
applyContSem($(P,X),[P,X]):- \+compound(P),!.
applyContSem($(~P,X),~[P,X]):- \+compound(P),!.
applyContSem($(R,X,Y),[R,X,Y]):-atomic(R),!.
applyContSem($(X^Expr,Arg),Sem):-
    reduce(X^Expr,Arg,Sem0),applyContSem(Sem0,Sem).
applyContSem($(~(X^Expr),Arg),Sem):-
    reduce(X^Expr,Arg,Sem0),applyContSem(~Sem0,Sem).
applyContSem(X & Y,SemX & SemY):-
    applyContSem(X,SemX),applyContSem(Y,SemY).
applyContSem(exists(X,Expr),exists(X,SemExpr)):-
    applyContSem(Expr,SemExpr).
applyContSem(X^Y,X^SemY):-
    applyContSem(Y,SemY).
applyContSem(~X,~SemX):-
    applyContSem(X,SemX).

% useful for comparing with Bos semantics
removeTop(exists(X,Expr),exists(X,Expr_noTop)):-!,
    removeTop(Expr,Expr_noTop).
removeTop(X & [top,_],X) :- !.
removeTop(X & Y,X_noTop & Y_noTop):-!,
    removeTop(X,X_noTop),
    removeTop(Y,Y_noTop).
removeTop(X,X).

doAll(Operation,Regex,Trace):-
    findall(Ex,(ex(Ex,_AMRs),re_match(Regex,Ex,[anchored(true)])),Exs),
    forall((member(Ex,Exs),ex(Ex,AMRstring,Sent)),
        (format('~s~s~s~s~n~s~n',['--- ',Ex,':',Sent,AMRstring]),
         call(Operation,Ex,Trace))
    ),
    length(Exs,L),
    format("*** ~d AMRs processed ***~n",[L]).

