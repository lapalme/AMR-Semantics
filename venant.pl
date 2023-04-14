% Parse and compute semantics according to the methodology of
%   Antoine Venant and François Lareau. 2023. 
%   Predicates and entities in Abstract Meaning Representation. 
%   In Proceedings of the Seventh International Conference on Dependency Linguistics 
%     (Depling, GURT/SyntaxFest 2023), pages 32–41, Washington, D.C.. 
%   Association for Computational Linguistics.
%      https://aclanthology.org/2023.depling-1.4/

:-[display].
:-[utils].

%% Equations of section 2
venant(C,F^ $(F,C)):- atomic(C),!.                               % 1,2
venant([P,X],F^exists(X,$(P,X) & $(F,X))).                       % 4
venant([P,X|Roles],Sem):- 
    foldl(venantRole,Roles,F^exists(X,$(P,X) & $(F,X)),Sem).

venantRole([_r,A],N,_f^ $(SemA,                                  % 5  ordinary Role
                           _m^ $(N,
                                _n^ ($(_r,_n,_m) & $(_f,_n))))):-
    \+isInvRole(_r),!,
    venant(A,SemA).
venantRole([_r_1,A],N,_f^ $(N,                                   % 6  inverse Role
                             _n^ $(SemA,
                                   _m^ ($(_r,_m,_n) & $(_f,_n))))):-
    atom_concat(_r,'-of',_r_1),
    venant(A,SemA).

venantSem(AMRstring,Venant_Sem,Trace):-
    amrParse(AMRstring,AMR,_Vars),
    (Trace -> writeln("* Parsed AMR"),pprint(AMR);true),
    venant(AMR,Sem),
    (Trace -> writeln("* Venant semantics"),pprintSem(Sem);true),
    applyContSem(Sem,SemApp),
    (Trace -> writeln("* After applications");true),
    % pprintSem(SemApp),
    reduce(SemApp,top,SemApp1), % remove top continuation
    removeTop(SemApp1,Venant_Sem).

%%%%%%%%%%%%%%%%%%% Tests
:-['parse'].
:-['examples'].

testVenantSem(Ex):-testVenantSem(Ex,false).
testVenantSem(Ex,Trace) :-
    ex(Ex,AMRstring),
    writeln("* AMR"),writeln(AMRstring),
    venantSem(AMRstring,Venant_Sem,Trace),
    (Trace -> writeln('* Venant Semantics:  ');true),
    pprintSem(Venant_Sem).

testVenantSemAll:-testVenantSemAll('',false).
testVenantSemAll(Prefix):-testVenantSemAll(Prefix,false).
testVenantSemAll(Regex,Trace):- doAll(testVenantSem,Regex,Trace).
