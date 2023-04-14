% Parse and compute semantics according to the methodology of
%    Johan Bos. 2016. 
%    Squib: Expressive Power of Abstract Meaning Representations. 
%    Computational Linguistics, 42(3):527–535.
%    https://aclanthology.org/J16-3006/
%
%     Deal with recurrent variables (section 4)
%
:-['display'].
:-['utils'].

% assertive semantics (def 7)
assertSem([_,\X|_],Phi,PhiX):-!,reduce(Phi,X,PhiX).                % 7.6, 7.7 et 7.8
assertSem(C,Phi,PhiC) :- atomic(C),!, reduce(Phi,C,PhiC).          % 7.1 et 7.2
% assertSem(C:_,Phi,PhiC) :- atomic(C),!, reduce(Phi,C,PhiC).      % 7.2 for variable references
assertSem([P,X],Phi,exists(X, [P,X] &  PhiX)):-                    % 7.3
    !, reduce(Phi,X,PhiX).
assertSem([C,X|Roles],Phi,~Sem) :- % negative polarity             % 7.5
    select([':polarity',"-"],Roles,Roles1),!,
    assertSem([C,X|Roles1],Phi,Sem).
assertSem([C,X|Roles],Phi,exists(X, [C,X] & SemRoles & PhiX)) :-   % 7.4
    assertSemRoles(X,Roles,SemRoles),
    reduce(Phi,X,PhiX).

assertSemRole(X,[Rn,An],Sem):-
    assertSem(An,Y^[Rn,X,Y],Sem0),
    elimTrue(Sem0,Sem).

assertSemRoles(X,[RnAn],Sem) :-!,assertSemRole(X,RnAn,Sem).
assertSemRoles(X,[RiAi|Rs],Sem & Sems):-
    assertSemRole(X,RiAi,Sem),
    assertSemRoles(X,Rs,Sems).

elimTrue(true & Y,Y1):-!,elimTrue(Y,Y1).
elimTrue(X & true,X1):-!,elimTrue(X,X1).
elimTrue(X & Y, X1 & Y1) :-!,elimTrue(X,X1),elimTrue(Y,Y1).
elimTrue(~X,~Y)     :-!,elimTrue(X,Y).
elimTrue([R,V|Roles],[R,V|Roles1]):-!,maplist(elimTrue,Roles,Roles1).
elimTrue(exists(X,Expr),exists(X,Expr1)):-elimTrue(Expr,Expr1).
elimTrue(X,X).

% projective semantics (def 8)
projSem(C,P^P):- atomic(C),!.            % 8.1
projSem(C:_,P^P):- atomic(C),!.          % 8.2 variable references
projSem([R,\X|Roles],P^P1):-             % 8.6, 8.7 et 8.8
    assertSem([R,X|Roles],X^P,P1).
projSem([_,_],P^P):-!.                   % 8.3
projSem([_,_|Roles],P^P1):-              % 8.4 et 8.5
    projSemRoles(P,Roles,P1).

projSemRole(P,[_,Ai],P1):-!,
    projSem(Ai,P0),
    reduce(P0,P,P1).
projSemRoles(P,[RnAn],P1):-!,projSemRole(P,RnAn,P1).
projSemRoles(P,[RiAi|Rs],P1):-
    projSemRoles(P,Rs,P0),
    projSemRole(P0,RiAi,P1).

bosSem(AMRstring,Sem):-bosSem(AMRstring,Sem,false).
bosSem(AMRstring,Sem,Trace):-
    amrParse(AMRstring,AMR0,Vars0),    
    keepRepeatedVars(Vars0,Vars),   % identify repeated vars
    projectVars(AMR0,Vars,AMR),     % mark projected vars
    (Trace -> writeln("* Parsed AMR"),pprint(AMR);true),
    assertSem(AMR,_^true,AssertSem0),
    elimTrue(AssertSem0,AssertSem),
    (Trace -> (write('* AssertSem:'),nl,pprintSem(AssertSem),nl);true),
    projSem(AMR,ProjSem),
    (Trace -> (write('* ProjSem:  '),nl,pprintSem(ProjSem),nl);true),
    reduce(ProjSem,AssertSem,CombinedSem),
    elimTrue(CombinedSem,Sem).


%%%%%%%%%%%%%%%%%%% Tests
:-['parse'].
:-['examples'].

testAssertSem(Ex):-ex(Ex,S),amrParse(S,AMR),pprint(AMR),nl,
    assertSem(AMR,_^true,Sem0),
    elimTrue(Sem0,Sem),
    showSem(Sem),!.

testProjSem(Ex):-ex(Ex,S),amrParse(S,AMR),pprint(AMR),nl,
    projSem(AMR,Sem),
    showSem(Sem),!.

testBosSem(Ex):-testBosSem(Ex,false).
testBosSem(Ex,Trace):-
    ex(Ex,AMRstring),
    writeln("* AMR"),writeln(AMRstring),
    bosSem(AMRstring,Sem,Trace),
    (Trace -> writeln('* Bos Semantics:  ');true),
    % pprint(Sem),
    pprintSem(Sem).

testBosSemAll:-testBosSemAll('',false).
testBosSemAll(Regex):-testBosSemAll(Regex,false).
testBosSemAll(Regex,Trace):-doAll(testBosSem,Regex,Trace).
