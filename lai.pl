% Parse and compute semantics according to the methodology of
%    Kenneth Lai, Lucia Donatelli, and James Pustejovsky. 2020. 
%    A Continuation Semantics for Abstract Meaning Representation. 
%    In Proceedings of the Second International Workshop on Designing Meaning Representations, pages 1–12,
%    https://aclanthology.org/2020.dmr-1.1/

:-['display'].
:-['utils'].

%% Definition 4
lai(C,Phi^($(Phi,C))):-atomic(C),!.                             % 4.1, 4.2
lai([P,X|Roles],Phi^ ~($(SemRiAi,Phi))):-                       % 4.3
    select([':polarity',-],Roles,RiAi),
    lai([P,X|RiAi],SemRiAi).
% lai([P,X|Roles],Phi^ ($(SemRiAi,Phi))):-                       % 4.4 TODO: check this
%     select([':polarity',-],Roles,RiAi),
%     lai([~P,X|RiAi],SemRiAi).
lai([P,X|Roles],Phi^ ($(~SemRiAi,_m^ ~($(Phi,_m))))):-          % 4.5
    select([':quant',[every,_]],Roles,RiAi),
    lai([P,X|RiAi],SemRiAi).
lai([P,X,[R1,[Y,\Q]]|RiAi],                                       % 4.6
         Phi^ $(SemY_Q,
                _n^ $(SemRiAi,
                     _m^ ($(R1,_m,_n) & $(Phi,_m)))
                )
        ):-
    lai([Y,\Q],SemY_Q),
    lai([P,X|RiAi],SemRiAi).
lai([P,X,[R1,A1]|RiAi],                                         % 4.7
        Phi^ $(SemRiAi,
               _m^ ($(SemA1,
                      _n^ $(R1,_m,_n)) & $(Phi,_m)))):-
    lai([P,X|RiAi],SemRiAi),
    lai(A1,SemA1).
lai([P,X],Phi^exists(X,$(P,X) & $(Phi,X))).                     % 4.8

laiSem(AMRstring,SemLai,Trace):-
    amrParse(AMRstring,AMR0,Vars0),    
    keepRepeatedVars(Vars0,Vars),   % identify repeated vars
    projectVars(AMR0,Vars,AMR),     % mark projected vars
    (Trace -> writeln("* Parsed AMR"),pprint(AMR);true),
    % trace,
    lai(AMR,Sem),
    (Trace -> writeln('* Lai Semantics:'),pprintSem(Sem);true),
    applyContSem(Sem,SemApp),
    (Trace -> writeln("* After applications");true),
    reduce(SemApp,top,SemApp1), % remove top continuation
    removeTop(SemApp1,SemLai).
    

%% Test 
:-['parse'].
:-['examples'].

testLaiSem(Ex):-testLaiSem(Ex,false).
testLaiSem(Ex,Trace) :-
    ex(Ex,AMRstring),
    writeln("* AMR"),writeln(AMRstring),
    laiSem(AMRstring,SemLai,Trace),
    (Trace -> writeln('* Lai Semantics:  ');true),
    pprintSem(SemLai).

testLaiSemAll:-testLaiSemAll('',false).
testLaiSemAll(Regex):-testLaiSemAll(Regex,false).
testLaiSemAll(Regex,Trace):- doAll(testLaiSem,Regex,Trace).
