% Parse an AMR into a Semantic Representation
%
%% creates a Semantic Representation of the form
%%        [concept, instance variable, [RoleName0, amr0], [RoleName1, amr1] ...]
%%     or var
%% for example:
%       (e/give-01  # a comment to ignore
%                    :ARG2 (y/child)
%                    :ARG0 (x/person :named "Ms Ribble")
%                    :ARG1 (z/envelope))
%% is parsed as
%%       [give-01,e,[:ARG2,[child,y]],[:ARG0,[person,x,[:named,Ms Ribble]]],[:ARG1,[envelope,z]]]
%% and shown in indented form as
%       ['give-01',e,[':ARG2',[child,y]],
%                    [':ARG0',[person,x,[':named',"Ms Ribble"]]],
%                    [':ARG1',[envelope,z]]]

char_word(C):-char_type(C,alnum).% alphanumeric
char_word('-').
char_word('+').
char_word(':').
char_word('.').

separator('/').
separator('\\').
separator('(').
separator(')').

%%%   Tokenizer
%%% Simple Tokenization (does not keep track of line or column number)

% tokenize a string representing an AMR into a list of tokens ignoring comments
toks(S,Ws):-atom_chars(S,Cs),phrase(toks(Ws),Cs),!.
toks([W|Ws]) -->
    [C],{char_word(C)},!,word(Cs),{atom_chars(W,[C|Cs])},
    toks(Ws).
toks([W|Ws]) -->
    [C],{separator(C)},!,{atom_chars(W,[C])},
    toks(Ws).
toks([W|Ws]) -->
    ['"'],!,inString(Cs),{string_chars(W,Cs)},
    toks(Ws).
toks(Ws) --> ([';'];['#']),!,comment,toks(Ws). % ignore what follows ; or # on the current line
toks(Ws) --> [_],toks(Ws). % ignore other characters
toks([]) --> [].

word([C|Cs])-->[C],{char_word(C)},word(Cs).
word([]) -->  [].

% create a string upto the next '"' (caution: does not deal with embedded " or \")
inString([]) --> ['"'],!.
inString([C|Cs]) --> [C],inString(Cs).
% ignore a comment until the of line
comment -->['\n'],!.
comment --> [_],!,comment.
comment -->[].

% DCG for parsing a list of tokens
% according to Definition 1
% 2nd and 3rd parameters gather variable names
amrParse([Concept,V|Rs],Vin,Vout) -->
    ['(',V,'/',Concept],!,roles(Rs,[V|Vin],Vout).
amrParse(V,Vars,VarsOut)    --> [V],
    {string(V) -> VarsOut=Vars      % do not consider "strings" as variable
                ; VarsOut=[V|Vars]},!. 

roles([],Vin,Vin) --> [')'],!.
roles([R|Rs],Vin,Vout) --> role(R,Vin,Vin1),roles(Rs,Vin1,Vout).

role([R,AMR],Vin,Vout)--> [R], amrParse(AMR,Vin,Vout).

%%%% simple parsing without any error recovery nor error message
amrParse(AMRstring,AMR,Vars):-
    toks(AMRstring,Toks),!,
    phrase(amrParse(AMR,[],Vars),Toks),!.

%%% by default, ignore vars
amrParse(AMRString,AMR):-amrParse(AMRString,AMR,_).

%%% tests
:-[display].
:-[examples].

testAmrParse(Ex,DoProject):-
    ex(Ex,S,Sent),format('~s~s~s~s~n~s~n',['--- ',Ex,':',Sent,S]),
    amrParse(S,AMR,DoProject),
    pprint(AMR),nl.

testAllAmrParse(Prefix):-
    forall((ex(Ex,_),atom_concat(Prefix,_,Ex)),
            % do not project examples from Lai (starting with "l")
           ((atom_concat('l',_,Ex)->DoProject=false;DoProject=true),    
           testAmrParse(Ex,DoProject))).

%  test of variable projection
testProj5a(Struct):-
    projectVars(
        ['dry-01',e,[':ARG0',[person,x,[':named',"Mr Krupp"]]],[':ARG1',x]],
        [x],Struct).
