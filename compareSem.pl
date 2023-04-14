:-[venant].
:-[bos].

%%  compare logical formulae from Bos and Venant
%% normalize semantics of Bos by 
%     - removing ^ true 
%     - removing "-of" at the end of the name of inverse role and inversing it args
normalizeBosSem(exists(X,Expr),exists(X,ExprNorm)):-
    normalizeBosSem(Expr,ExprNorm).
normalizeBosSem(X & true,XNorm):-
    normalizeBosSem(X,XNorm).
normalizeBosSem(X & Y,XNorm & YNorm):-
    normalizeBosSem(X,XNorm),normalizeBosSem(Y,YNorm).
normalizeBosSem([P,X],[P,XNorm]):-
    normalizeBosSem(X,XNorm).
normalizeBosSem([P,X,Y],Out):-
    normalizeBosSem(X,XNorm),normalizeBosSem(Y,YNorm),
    (isInvRole(P)->atom_concat(P0,'-of',P),Out=[P0,YNorm,XNorm];
                   Out=[P,XNorm,YNorm]).
normalizeBosSem(X,X).    

compareBosVenant(Ex):-compareBosVenant(Ex,false).
compareBosVenant(Ex,Trace):-
    ex(Ex,AMRstring),
    bosSem(AMRstring,Bos_Sem0,Trace),
    normalizeBosSem(Bos_Sem0,Bos_Sem),
    (Trace -> writeln("Bos semantics:"),pprintSem(Bos_Sem);true),
    venantSem(AMRstring,Venant_Sem,Trace),
    (Trace -> writeln("Venant semantics:"),pprintSem(Venant_Sem);true),
    (Bos_Sem=Venant_Sem -> writeln("OK")
       ; writeln("KO"),
       (\+Trace -> 
         writeln("Bos semantics:"),
         % writeln(Bos_Sem),
         % showSem(Bos_Sem),
         pprintSem(Bos_Sem),
         writeln("--"),
         writeln("Venant semantics"),
         % writeln(Venant_Sem),
         % showSem(Venant_Sem),
         pprintSem(Venant_Sem);true)
    ).

compareBosVenantAll:-compareBosVenantAll('',false).
compareBosVenantAll(Prefix):-compareBosVenantAll(Prefix,false).
compareBosVenantAll(Regex,Trace):-doAll(compareBosVenant,Regex,Trace).

:-[lai].

%%  compare logical formulae from Lai and Venant
compareLaiVenant(Ex):-compareLaiVenant(Ex,false).
compareLaiVenant(Ex,Trace):-
    ex(Ex,AMRstring),
    %% semantics of Lai
    laiSem(AMRstring,Lai_Sem,Trace),
    %% continuation semantics of Venant
    venantSem(AMRstring,Venant_Sem,Trace),
    (Lai_Sem=Venant_Sem -> writeln("OK")
       ; writeln("KO"),
       (\+Trace -> 
         writeln("Lai semantics:"),
         % writeln(Lai_Sem),
         % showSem(Lai_Sem),
         pprintSem(Lai_Sem),
         writeln("--"),
         writeln("Venant semantics"),
         % writeln(Venant_Sem),
         % showSem(Venant_Sem),
         pprintSem(Venant_Sem);true)
    ).

compareLaiVenantAll:-compareLaiVenantAll('',false).
compareLaiVenantAll(Regex):-compareLaiVenantAll(Regex,false).
compareLaiVenantAll(Regex,Trace):-doAll(compareLaiVenant,Regex,Trace).

