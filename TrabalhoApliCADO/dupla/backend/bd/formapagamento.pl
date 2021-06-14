/* :- module(
       formapagamento,
       [carrega_tab/1, formapagamento/2, insere/2, remove/1, atualiza/2]
   ).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   formapagamento(id_formapagamento:nonneg,
                descr_formapagento:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).


insere(Id_formapagamento, Descr_formapagento):-
    chave:pk(formapagamento, Id_formapagamento),
    with_mutex(formapagamento,
               assert_formapagamento(Id_formapagamento, Descr_formapagento)).

remove(Id_formapagamento):-
    with_mutex(formapagamento,
               retract_formapagamento(Id_formapagamento,_)).

atualiza(Id_formapagamento, Descr_formapagento):-
    with_mutex(formapagamento,
               (  retractall_formapagamento(Id_formapagamento,_),
                  assert_formapagamento(Id_formapagamento, Descr_formapagento))). */

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
   formapagamento( id_formapagamento:nonneg,
                    descr_formapagento:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(Id_formapagamento, Descr_formapagento):-
    chave:pk(formapagamento,Id_formapagamento),
    with_mutex(formapagamento,
               assert_formapagamento(Id_formapagamento,Descr_formapagento)).

 remove(Id_formapagamento):-
    with_mutex(formapagamento,
               retract_formapagamento(Id_formapagamento,_)).

atualiza(Id_formapagamento, Descr_formapagento):-
    with_mutex(formapagamento,
               ( retractall_formapagamento(Id_formapagamento,_),
                 assert_formapagamento(Id_formapagamento,Descr_formapagento)) ).