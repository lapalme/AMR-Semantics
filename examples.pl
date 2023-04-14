:-encoding(utf8).

ex(N,S):-ex(N,S,_).  % ignore sentence

% examples from BOS
ex('0','(s / small :domain (m / marble) :polarity -)',
    "The marble is not small").
ex('1a','(e/moan-01 :ARG0 (x/child))',
   "a child moans").
ex('1c','(e/moan-01 :ARG0 (x/child) :polarity -)',
   "a child does not moan").
ex('1b','(e/give-01  ; a comment to ignore
             :ARG2 (y/child)
             :ARG0 (x/person :named "Ms Ribble")
             :ARG1 (z/envelope))# another comment at the end',
   "Ms Ribble gives an envelope to a child").
ex('1d','(e/give-01 
             :ARG0 (x/person :named "Ms Ribble")
             :ARG1 (z/envelope)
             :ARG2 (y/child)
             :polarity -)',
   "Ms Ribble does not give an envelope to the child").
ex('2',"(e/read-01 :ARG0 (x/girl) :ARG1 (y/book))",
   "a girl reads a book").
ex('2a',"(x/girl :ARG0-of (e/read-01 :ARG1 (y/book)))",
   "a girl reads a book").
ex('2aN',"(x/girl :ARG0-of (e/read-01 :ARG1 (y/book)) :polarity -)",
   "no girl reads a book").
ex('2b',"(y/book :ARG1-of (e/read-01 :ARG0 (x/girl)))",
   "a book that is read by a girl").
ex('2bN',"(y/book :ARG1-of (e/read-01 :ARG0 (x/girl) :polarity -))",
   "a book that is not read by a girl").
ex('3',"(e/shout-01 :ARG0 (x/teacher))",
   "a teacher shouts").
ex('4a',"(e/giggle-01 :polarity - :ARG0 (x/boy))",
    "a boy did not giggle").
ex('4b',"(x/language :domain-of (a / appropriate :polarity -))",
    "the language is not appropriate").
ex('4c',"(x/language :domain-of (a / appropriate))",
    "the language is appropriate").
ex('5a','(e/dry-02
             :ARG0 (x / person :named "Mr Krupp")
             :ARG1 x)',
    "Mr Krupp dries himself").
ex('5b','(w/want-01
             :ARG0 (g / person :named "George")
             :ARG1 (p/play-01 :ARG3 g))',
    "George wants to play").
ex('9a','(x / boy :polarity -
            :ARG0-of (e / whistle-01
                          :polarity -))',
   "every boy whistle").

% exemple de https://github.com/amrisi/amr-guidelines/blob/master/amr.md#abstract-meaning-representation-amr-10-specification
ex('AMR-1',
   '(w / want-01
         :ARG0 (b / boy)
         :ARG1 (b2 / believe-01
               :ARG0 (g / girl)
               :ARG1 b))',
  "The boy wants the girl to believe him.").
ex('AMR-1N',
   '(w / want-01
         :polarity -
         :ARG0 (b / boy)
         :ARG1 (b2 / believe-01
               :ARG0 (g / girl)
               :ARG1 b))',
  "The boy does not desire the girl to believe him.").
ex('AMR-1NN',
   '(w / want-01
         :ARG0 (b / boy)
         :ARG1 (b2 / believe-01
               :polarity -
               :ARG0 (g / girl)
               :ARG1 b))',
  "The boy desires the girl not to believe him.").

ex('Guy', % paper example
   '(d / desire-01
        :ARG0 (b/boy)
        :ARG1 (g/girl
                 :ARG0-of (l/like-01
                             :polarity - 
                             :ARG1 b)))',
   "The boy desires the girl who does not like him").

% exemple de https://amr.isi.edu/language.html
ex('AMR-2',
   '(w / want-01
          :ARG0 (b / boy)
          :ARG1 (g / go-01
                :ARG0 b))',
   "The boy wants to go").
ex('AMR-3',
   '(s / say-01
     :ARG0 (g / organization
          :name (n / name
                  :op1 "UN"))
     :ARG1 (f / flee-05
          :ARG0 (p / person
                  :quant (a / about
                           :op1 14000))
          :ARG1 (h / home
                  :poss p)
          :time (w / weekend)
          :time (a2 / after
                  :op1 (w2 / warn-01
                         :ARG1 (t / tsunami)
                         :location (l / local))))
      :medium (s2 / site
            :poss g
            :mod (w3 / web)))',
   "About 14,000 people fled their homes at the weekend after
    a local tsunami warning was issued, the UN said on its Web site").

%  http://nlp.arizona.edu/SemEval-2017/pdf/SemEval090.pdf
ex('SemEval-1',     % Figure 1
   '(f / fear-01
     :polarity -
     :ARG0 ( s / soldier )
     :ARG1 ( d / die-01
             :ARG1 s ))',
   "The soldier did not fear dying").

ex('SemEval-3',     % Figure 3
   '(c/claim-01
       :ARG0 (h/he)
       :ARG1 (e/expose-01
                :ARG0 (p/person
                         :ARG0-of (s/sing-01)
                         :age (t/ temporal-quantity :quant 28
                                    :unit (y/year)))
                :ARG1 p
                :ARG2 h
                :ARG1-of (r/repeat-01)))',
   "he claims the 28-year-old singer repeatedly exposed herself to him").

ex('SemEval-5',    % Table 5
   '(a / and
     :op1 (r / remain-01
           :ARG1 (c / country :wiki "Bosnia_and_Herzegovina"
                  :name (n / name :op1 "Bosnia"))
           :ARG3 (d / divide-02
                  :ARG1 c
                  :topic (e / ethnic)))
     :op2 (v / violence
           :time (m / match-03
                  :mod (f2 / football)
                  :ARG1-of (m2 / major-02))
           :location (h / here)
           :frequency (o / occasional))
     :time (f / follow-01
            :ARG2 (w / war-01
                   :time (d2 / date-interval
                          :op1 (d3 / date-entity :year 1992)
                          :op2 (d4 / date-entity :year 1995)))))',
   "following the 1992-1995 war, bosnia remains ethnically divided and
    violence during major football matches occasionally occurs here.").

%  AMR tutorial
ex('Tut-01',    % page 6
   '(e / eat-01
     :ARG0 (d / dog)
     :ARG1 (b / bone))',
   "The dog is eating a bone").
ex('Tut-02a',   % page 10 Tut-02a et Tut-02b donnent la meme s�mantique
   '(w / want-01
      :ARG0 (d / dog)
      :ARG1 (e / eat-01
             :ARG0 d
             :ARG1 (b / bone)))',
   "The dog wants to eat the bone").
ex('Tut-02b',
   '(w / want-01
      :ARG0 d
      :ARG1 (e / eat-01
             :ARG0 (d / dog)
             :ARG1 (b / bone)))',
   "The dog wants to eat the bone").
ex('Tut-03',   % page 22
   '(e / eat-01
      :ARG0 (d / dog)
      :ARG1 (b / bone
             :ARG1-of (f / find-01
                         :ARG0 d)))',
   "The dog ate the bone that he found").

% Konstas et al. Neural AMR: Sequence-to-Sequence Models for Parsing and Generation, p
% http://aclweb.org/anthology/P17-1014
% output from 
ex('Konstas-F1',
   '(a / and 
      :op1 (e / elect-01 
             :ARG0 (p / person 
                      :name "Obama"))
      :op2 (c / celebrate-01 
             :ARG0 (p1 / person
                     :poss p
                     :ARG0-of (v / vote-01))))',
   "Obama was elected and his voters celebrated").

ex('Konstas-F2',
   '(h / hold-04
       :ARG0 (p2 / person
                 :ARG0-of (h2 / have-org-role-91 
                       :ARG1 (c2 / country
                                :name (n3 / name
                                         :op1 "United" 
                                         :op2 "States"))
                       :ARG2 (o / official))) 
       :ARG1 (m / meet-03
               :ARG0 (p / person
                         :ARG1-of (e / expert-01)
                         :ARG2-of (g / group-01)))
       :time (d2 / date-entity :year 2002 :month 1)
       :location (c / city
                    :name (n / name 
                              :op1 "New" 
                              :op2 "York")))',
    "US officials held an expert group meeting in January 2002 in New York.").

%% output of Konstas:
%%  the arms control treaty limits the number of conventional weapons that can be deployed west of Ural Mountains .
%% we "delinearize" the examples of Figure 3 given in the paper... and add frame numbers
ex('Konstas-F3a',
   '(l/limit-01
       :ARG0 (t / treaty 
               :ARG0-of (c / control-01 :ARG1 (a/arms)))
       :ARG1 (n / number-01
                :ARG1 (w / weapon 
                         :mod conventional
                         :ARG1-of (d / deploy-01
                                    :ARG2 (r / relative-position 
                                              :op1 "Ural Mountains" 
                                              :direction "west" )
                                    :ARG1-of (p / possible-01)))))',
    "The arms control treaty limits the number of conventional weapons that can be deployed west of the Ural Mountains.").
    
%% taken from AMR Normalisation for Fairer Evaluation
%%  other examples in reification.pl
ex('Goodman-F5','
(b/bite-01
  :ARG0 (d/dog
     :ARG0-of (c/chase-01
         :ARG1 (b1/boy)))
  :ARG1 b1)
',"The dog chasing the boy bit him.").

ex('Goodman-F6','
(b/bite-01
  :ARG0 d
  :ARG1 (b1/boy
     :ARG1-of (c/chase-01
          :ARG0 (d/dog))))
',"The boy chased by the dog was bit by it.").

ex('Goodman-F6b','
(b/bite-01
  :ARG0 (d/dog)
  :ARG1 (b1/boy
     :ARG1-of (c/chase-01
          :ARG0 d)))
',"The boy chased by the dog was bit by it.").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% examples from Lai et al. 2020
%% caution: in the following, we replaced the original \ by / because we identify projected vars...
ex('lai-1','(l/listen-01
    :ARG0 (p/person
        :mod (a/all)
        :location(r/room))
    :ARG1 (t/talk))',
   "All the persons in the room listen to the talk.").

ex('lai-2','(b/bark-01
    :ARG0 (d/dog))',
    "A dog barked").
ex('lai-4','(s / scratch-02 ;scratch-01 does not exists in PropBank !
    :ARG0 (d / dog)
    :ARG1 d)', 
    "A dog scratched itself").
ex('lai-7','(s / scratch-02 ;scratch-01 does not exists in PropBank !
    :ARG0 (d / dog
        :quant (e/every)
        :mod (b/brown))
    :ARG1 d)',
    "Every of the brown dog scratches itself.").
ex('lai-10','(m/meow-01
    :ARG0 (d/dog)
    :polarity -)',
    "The dog does not meow."). % No dog meowed
ex('lai-11','(m/meow-01
    :ARG0 (d/dog
        :polarity -))',
    "No dog meow"). % A non-dog meowed
ex('lai-12','(m/meow-01
    :ARG0 (d / dog
        :quant (e/every)
        :polarity -))', % strange polarity in original (n/1)
    "Every non dog meow.").
ex('lai-12b','(m/meow-01
    :ARG0 (d / dog
        :quant (e/every)
        :polarity  -))', % strange polarity in original (n\1)
    "Not every meow.").
ex('lai-14','(l/love-01
    :ARG0 (f / farmer
        :quant (e/every)
        :ARG0-of (o/own-01
            :ARG1 (d/donkey)))
    :ARG1 d)',
    "Every of the farmer who owns the donkey loves it.").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Examples from Venant & Lareau
ex('venant-1','(l/like-01
    :ARG0 (x/girl)
    :ARG1 x)',
    "A girl likes herself").

ex('venant-2','(x/girl 
    :ARG0-of (l/like-01 ; a/like-01 in the paper
        :ARG1 x))',
    "There is a girl who likes herself.").

ex('venant-AMR-1','(l/lawyer :domain (m/man))',
   "The lawyer is the man").  % (in the Paper...) The man is a lawyer 

ex('venant-AMR-2','(l/lawyer 
    :domain (m/man 
        :ARG0-of (s/sing-01)))',
    "The lawer is the man who sings"). % The man who sings is a lawyer

ex('venant-AMR-3','(s/sing-01
    :ARG0 (l/lawyer))',
    "A lawyer sings").
    
ex('venant-AMR-4','(w/work-01 
    :ARG0 (b/boy)
    :manner (h/hard-02))',
    "The boy works hard").  % The boy is a hard worked

% ::id PROXY_AFP_ENG_20020115_0320.13 ::date 2013-05-14T12:41:11 ::snt-type body ::annotator LDC-AMR-14 ::preferred
% ::snt Iftikhar Ahmed is a Pakistani interior ministry official.
% ::save-date Thu Jan 9, 2014 ::file PROXY_AFP_ENG_20020115_0320_13.txt
ex('venant-AMR-5',
   '(p2 / person
      :domain (p / person :wiki "Iftikhar_Ahmed"
            :name (n2 / name :op1 "Iftikhar" :op2 "Ahmed"))
      :ARG0-of (h / have-org-role-91
            :ARG1 (m / ministry
                  :topic (i / interior)
                  :poss (c / country :wiki "Pakistan"
                        :name (n / name :op1 "Pakistan")))
            :ARG2 (o / official)))',
    "the person is Iftikhar Ahmed who is the official in the ministry about the interior of Pakistan").

ex('venant-AMR-6','(w/work-01
    :ARG0 (m/man 
        :ARG0-of (s/sing-01)))',
    "The man who sings works").
    
ex('venant-AMR-7','(w/sing-01
    :ARG0 (p/person
        :ARG0-of (s/work-01)))',
    "The woorker sings").



ex('venant-s4','(b/believe-01
    :ARG0 (i/I)
    :ARG1 (p / president
        :domain (p1 / person
            :wiki "Ron_Paul"
            :name (n / name
                :op1 "Ron"
                :op2 "Paul"))))',
    "I believe the president is Ron Paul."). % I believe that Ron Paul is president

ex('venant-s4-b','(b/believe-01
    :ARG0 (i/I)
    :ARG1 (p1/person
        :mod (p/president) 
        :domain (p2 / person
            :wiki "Ron_Paul"
            :name (n / name
                :op1 "Ron"
                :op2 "Paul"))))',
    "I believe the president person is Ron Paul."). % Ron Paul is president and...

ex('venant-AMR-8','(p/person
    :ARG0-of (h/have-rel-role-91
        :ARG1 (i/i)
        :ARG2 (b/brother)))',
    "my brother").

ex('venant-AMR-9','(c/client :poss (w/we))',
   "my client").

ex('venant-AMR-10',
   '(t/thank-01
       :ARG0 (t2/therapist
           :poss (c/client
               :poss t2))
       :ARG1 c)',
    "The therapist of his client thanks him.").
    % The therapist thanks his client

ex('venant-AMR-10-reified',
   '(t/thank-01
       :ARG0 (t2/therapist
           :ARG0-of (o1/own-01
               :ARG1 (c/client 
                   :ARG0-of (o2/own-01
                       :ARG1 t2))))
       :ARG1 c)',
     "The therapist who owns the client who owns him thanks him.").
     % The therapist thanks his client

% ::id DF-200-192451-579_6417.3 ::date 2014-03-19T16:40:12 ::annotator SDL-AMR-09 ::preferred
% ::snt Only if Ron Paul doesnt become president then there will be war.
% ::save-date Mon Jan 12, 2015 ::file DF-200-192451-579_6417_3.txt
ex('venant-AMR-annex-1','(w / war-01
      :condition (b / become-01 :polarity -
            :ARG1 (p / person :wiki "Ron_Paul" :name (n / name :op1 "Ron" :op2 "Paul"))
            :ARG2 (p2 / president)
            :mod (o / only))
      :time (t / then))',
      "the war if only Ron Paul does not become the president then").

% ::id bolt-eng-DF-170-181103-8886306_0011.6 ::date 2015-09-01T07:41:33 ::annotator SDL-AMR-09 ::preferred
% ::snt And, that is something needed to become President.
% ::save-date Fri Sep 11, 2015 ::file bolt-eng-DF-170-181103-8886306_0011_6.txt
ex('venant-AMR-annex-2',
   '(a / and
      :op2 (n / need-01
            :ARG0 (b / become-01
                  :ARG2 (p2 / person
                        :ARG1-of (h / have-org-role-91
                              :ARG2 (p3 / president))))
            :ARG1 (s / something)))',
   "to become the person who is the president needs something").


% ::id PROXY_APW_ENG_20080515_0931.17 ::date 2013-07-20T22:23:51 ::snt-type body ::annotator SDL-AMR-09 ::preferred
% ::snt Teikovo is a small town in the Ivanovo region about 250 kilometers or 155 miles northeast of Moscow.
% ::save-date Fri Jan 24, 2014 ::file PROXY_APW_ENG_20080515_0931_17.txt
ex('venant-AMR-annex-3',
   '(t / town
       :mod (s / small)
       :location (p / province 
           :wiki "Ivanovo"
           :name (n / name 
               :op1 "Ivanovo"))
       :location (r / relative-position
           :op1 (c / city 
               :wiki "Moscow"
               :name (n2 / name 
                   :op1 "Moscow"))
           :direction (n3 / northeast)
           :quant (a / about
               :op1 (d / distance-quantity 
                   :quant 250
                   :unit (k / kilometre))))
       :domain (c2 / city 
           :wiki "Teykovo"
           :name (n4 / name 
               :op1 "Teikovo")))',
    "the small town in Ivanovo in Moscow to the northeast about 250 kilometres is Teikovo").
% TODO: pourquoi gophi ajoute aussi: **unprocessed roles or parts of speech: D

