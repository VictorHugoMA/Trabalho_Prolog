:- module(
       formapagamento,
       [ carrega_tab/1,
          formapagamento/2,
            insere/2,
            remove/1,
            atualiza/2]
   ).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   formapagamento( idformapagamento:nonneg,
                    descrformapagento:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

/* :- initialization( ( db_attach('tbl_formapagamento.pl', []),
                     at_halt(db_sync(gc(always))) )). */

insere(Idformapagamento, Descrformapagento):-
    chave:pk(formapagamento,Idformapagamento),
    with_mutex(formapagamento,
               assert_formapagamento(Idformapagamento,Descrformapagento)).

 remove(Idformapagamento):-
    with_mutex(formapagamento,
               retract_formapagamento(Idformapagamento,_)).

atualiza(Idformapagamento, Descrformapagento):-
    with_mutex(formapagamento,
               ( retractall_formapagamento(Idformapagamento,_),
                 assert_formapagamento(Idformapagamento,Descrformapagento)) ).