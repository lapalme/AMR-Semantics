%%% Print and pretty-print term and semantics 
%%%  in user/logician friendly way

% output semantics using the notation of Bos

:- op(900,yfx,>).         % implication
:- op(800,yfx,&).         % conjunction
:- op(750, fy,~).         % negation


pprint(T):-pprint(T,0).
pprint(T,N):-phrase(pp(T,N),PP),atomic_list_concat(PP,S),write(S),nl.

% create an atom of N spaces which is returned after a newline
% must force evaluation of N which format does not do...
indent(N) --> {N1 is N,format(atom(S),'~*+~w',[N1,''])},['\n',S].
% output a quoted term
quote(T) --> {with_output_to(atom(QT),writeq(T))},[QT].

%% DCG for pretty-printing a term
pp(T) --> pp(T,0),['\n'].

pp(T,_)      --> {atomic(T)},!,quote(T).
pp(T,_)      --> {var(T)},!,[T].
pp(\X,N)     --> !,['\\'],pp(X,N).
pp(X:Y,N)    --> !,pp(X,N),[':'],quote(Y).
pp(X*Y,N)    --> !,pp(X,N),['*'],quote(Y).
pp(X+Y,N)    --> !,pp(X,N),['+'],pp(Y,N).
pp(X&Y,N)    --> !,pp(X,N),indent(N),[' & '],pp(Y,N+4).
pp($(null)/Y,N)--> !,['$(null)/'],pp(Y,N+8).
pp($(_X)/Y,N)--> !,['$(non-null)/'],pp(Y,N+12).
pp(null/Y,N) --> !,['null/'],pp(Y,N+5).
pp(_X/Y,N) --> !,['non-null/'],pp(Y,N+9).
pp({X},N)    --> !,['{'],pp(X,N+1),['}'].
pp(X^Y,N)    --> !,['λ'],
    pp(X,N+1),['.'],{N1 is N+2},indent(N1),pp(Y,N1).
pp([P,Arg1|Args],N) -->!,
    ['['],pp(P,N+1),[','],
    {write_length(P,L,[quoted(true)]),N1 is N+L+2},
    pp(Arg1,N1),!,
    (ppAux(Arg1,Args,N1); ppRest(Args,N1)),
    [']'].
pp(X,N)      --> !,
    {X=..[P,Arg1|Args]},
    pp(P,N),['('],
    {write_length(P,L,[quoted(true)]),N1 is N+L+1},
    pp(Arg1,N1),!,
    (ppAux(Arg1,Args,N1); ppRest(Args,N1)),
    [')'].

ppAux(Arg1,[Arg2|ArgN],N) --> 
    {atomic(Arg1),atom_length(Arg1,L1)},
    [','],pp(Arg2,N+L1+1),ppRest(ArgN,N+L1+1).
    
ppRest([],_)-->[]. 
ppRest([Arg|Args],N)-->[','],indent(N),pp(Arg,N),ppRest(Args,N).
writeWords(Ws):-atomic_list_concat(Ws,' ',Out),write(Out),write('.').


%% show a term using a FOL notation
% a copy of the term is created so that the original lambda can still be applied 
showSem(E):-copy_term(E,E1),numbervars(E1),phrase(shSem(E1),Xs),atomic_list_concat(Xs,X),writeln(X).
%% DCG for outputing an expression
shSem(exists(X,Exp))-->!,['∃'],shSem(X),['('],shSem(Exp),[')'].
shSem($(P,Y))   -->!, shSem(P),['('],shSem(Y),[')'].
shSem($(P,Y,Z)) -->!, shSem(P),['('],shSem(Y),[','],shSem(Z),[')'].
shSem(X^Y)        -->!,['λ'],shSem(X),['.'],shSem(Y).
shSem(X & top(_)) -->!,shSem(X).
shSem(X & Y)      -->!,shSem(X),['∧'],shSem(Y).
shSem(~X)         -->!,['¬'],shSem(X).
shSem([P,X|Xs])   -->!,shSem(P),['('],shSem(X),shSemRest(Xs),[')'].
shSem(X)          -->{string(X)},!,['"',X,'"'].
shSem(X)          -->shVar(X,_).


shVar('$VAR'(N),1)  --> {nth0(N,['φ','ψ','γ','η','θ','ξ','σ','ω'],X)},!,[X].
shVar('$VAR'(N),L+1)--> !,{atom_length(N,L)},['ν',N].
shVar(\X,L+1)       --> !,shVar(X,L).
shVar(X,L)          --> {atom_length(X,L)},[X].

isVar('$VAR'(_)).
isVar(\_).
isVar(X):-atomic(X).

shSemRest([])     -->[].
shSemRest([X|Xs]) -->[,],shSem(X),shSemRest(Xs).

% prettyprint using an indented FOL notation
pprintSem(E):-
    % a copy of the term is created so that the original lambda can still be applied
    copy_term(E,E1),numbervars(E1),
    phrase(ppSem(E1),Xs),atomic_list_concat(Xs,X),writeln(X).
%% DCG for outputing an indented expression
ppSem(E) --> ppSem(E,0).
ppSem(exists(X,Exp),N)--> !,['∃'],shVar(X,L),['('],ppSem(Exp,N+L+2),[')'].
ppSem(X^Y,N)         -->!,['λ'],shVar(X,L),['.'],ppSem(Y,N+L+2).
ppSem(X & [top,_],N) --> !,ppSem(X,N).  % HACK: remove top continuation
ppSem(X & Y,N)       --> !,ppSem(X,N),indent(N),['∧ '],ppSem(Y,N+2).
ppSem(~X,N)          --> !,['¬'],ppSem(X,N+1).
ppSem($(P,Y),N)      --> {isVar(P)},!, shVar(P,L),['('],ppSem(Y,N+L+1),[')'].
ppSem($(P,Y),N)      --> !,['('],ppSem(P,N+1),indent(N+1),['·'],ppSem(Y,N+2),[')'].
ppSem($(P,Y,Z),N)    --> !,ppSem(P,N),['('],ppSem(Y,N),[','],ppSem(Z,N),[')'].
ppSem([P,X,Y],_N)    --> !,ppSem(P,_),['('],ppSem(X,_),[','],ppSem(Y,_),[')']. % special case (probably the only one!)
ppSem([P,X|Xs],N)    --> !,shVar(P,L),['('],ppSem(X,N+L+1),ppRestSem(Xs,N+L+1),[')'].
ppSem(X,_)           --> {string(X)},!,['"',X,'"'].
ppSem(X,_)           --> shVar(X,_).

ppRestSem([],_N)     --> [].
ppRestSem([X|Xs],N)  --> [','],indent(N),ppSem(X,N),ppRestSem(Xs,N).


