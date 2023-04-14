# AMR : compute and display semantics in First Order Logic  

This project contains Prolog files, using with [SWI-Prolog](https://www.swi-prolog.org "SWI-Prolog"), for implementing three methods of computing a First Order Logic (FOL) formula corresponding to an [Abstract Meaning Representation](https://amr.isi.edu "Abstract Meaning Representation (AMR)") (AMR).  We developped these programs in order to compare to what extent the resulting logic formulae for each methods are equivalent.

These methods are based on the seminal idea of (Bos, CL 2016) of  « assigning correct scope by delaying the translation of scope by converting them into λ-expressions abstracting over role players ». This process is used to deal with polarity and recurrent variables.  

This implementation can display FOL formulae with the conventional logic symbols and indented to make their structure stand out. Intermediary forms can also be displayed.  The computed semantic formulae for a given AMR can also be compared.

We first describe the Prolog representation we have chosen for AMR and the logical formula. For each transformation method, we tried to follow as much as possible the notations used in the equations.

## Prolog representations
### Parsed AMR (file `parse.pl`)

An AMR of the form

    (instance/concept :role1 amr1 ... :roleN amrN)

is represented as a Prolog list of the form (N>=0)

    [concept, instance, [Role1, amr1], ..., [roleN, amrN]]

The AMR (example `AMR-1`) for sentence *The boy wants the girl to believe him.* 

```
(w / want-01
     :ARG0 (b / boy)
     :ARG1 (b2 / believe-01
           :ARG0 (g / girl)
           :ARG1 b))
```
This string is parsed with a DCG grammar and the corresponding *indented* parsed form is

```
['want-01',w,[':ARG0',[boy,\b]],
             [':ARG1',['believe-01',b2,[':ARG0',[girl,g]],
                                       [':ARG1',b]]]]
```

for which the following logic formula in Prolog notation is computed
```
exists(w,['want-01',w]
          & [':ARG0',w,b]
              & exists(b2,['believe-01',b2]
                            & exists(g,[girl,g]
                                         & [':ARG0',b2,g])
                                & [':ARG1',b2,b]
                            & [':ARG1',w,b2]))
```

It can be displayed using the usual logic symbols as follows:

```
∃w(want-01(w)
   ∧ :ARG0(w,b)
     ∧ ∃b2(believe-01(b2)
           ∧ ∃g(girl(g)
                ∧ :ARG0(b2,g))
             ∧ :ARG1(b2,b)
           ∧ :ARG1(w,b2)))
```

### Logic formula representation

| Operation                                          | Prolog           | Logic     |
| -------------------------------------------------- | ---------------- | :-------- |
| Existential quantifier                             | `exists(X,Expr)` | *∃x expr* |
| Lambda abstraction                                 | `X^Expr`         | *λx.expr* |
| Function application (*F* is constant or variable) | `$(F,X)`         | *F(x)*    |
| Function application (*F* is an expression)        | `$(F,X)`         | *(F · X)* |
| Function application                               | `$(F,X,Y)`       | *F(x,y)*  |
| Conjunction                                        | `X & Y`          | X ∧ Y     |
| Negation                                           | `~X`             | ¬X        |

In *λx.expr* , *x* can be a greek letter or *ν* (greek *nu*) followed by a number > 7

## Examples of AMR for testing

* `examples.pl` :  63 AMR examples taken from papers or variations on them. They are of the form where 

  * `Ex` is used as an identifier that can matched by a regular expression for selection in *test...All* expressions
  * `AMRstring` is the string representation of the AMR
  * `Sentence` is the English sentence corresponding to the AMR  
  
  ```
  ex(Ex,AMRstring,Sentence)
  ```

## Files for each approach

- `bos.pl` : [Expressive Power of Abstract Meaning Representations](https://aclanthology.org/J16-3006) (Bos, CL 2016)  
  Computes the FOL formula in two passes, assertive  and projective, which are then combined (assertive is applied to the projective) to ensure that the existential quantifiers are properly scoped.  Projected variables are identified by searching for repeated variables and marking the instance definition as projected.

- `lai.pl` : [A Continuation Semantics for Abstract Meaning Representation](https://aclanthology.org/2020.dmr-1.1) (Lai et al., DMR 2020)  
  Proposes a *continuation* approach for computing the semantics in a single pass. In their paper, the authors explicitly mark projected variables, but here they are identified as for the previous method, to ease comparisons. Their paper also links to an [Haskell implementation of their method](https://github.com/klai12/amr2fol).    

  **CAUTION**: because the way the projection is computed, our implementation is not fully compatible with their approach

- `venant.pl` : [Predicates and entities in Abstract Meaning Representation](https://aclanthology.org/2023.depling-1.4) (Venant & Lareau, DepLing-SyntaxFest 2023)  
  Describes a variation on the *continuation* approach of Lai without the need for identifying projective variables. It is based on a distinct processing of roles depending on whether they inverse or not.  

### Test of each approach

Each file and method are identified by their first author. We give examples of call using `Bos`, but the same calls can be done with `Lai` or `Venant`, capitalized when not at the start.

* `testBosSem(Ex,Trace)` : test a single example identified by `Ex` and print the resulting semantics. If `Trace` is specified and `true`, display intermediary logical forms.
* `testBosSemAll(Regex,Trace)` : test all examples with identifiers matching  `Regex` (matching is anchored at the start), with tracing or not.  If `Regex` is not given, match all examples, if `Trace` is not specified, no tracing occurs.

## Other files

- `compareSem.pl` : Compare the semantics produced by two methods, if they are identical display `OK` otherwise display the two semantics.

  Called as `compareBosVenantAll(Regex,Trace)` or `compareLaiVenantAll(Regex,Trace)`

- `display.pl` : prettyprint a term or a semantics with logical symbols

- `utils.pl` :  utility predicates used in more than one transformation method

## Contact

[Guy Lapalme](mailto:lapalme@iro.umontreal.ca) 



