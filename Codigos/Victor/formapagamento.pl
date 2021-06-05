:- module(
       tabFormaPag,
       [tabFormaPag/2, insere/2, remove/1, atualiza/2]
   ).

:- use_module(library(persistency)).

:- persistent
   tabFormaPag(id_formapagamento:nonneg,
                descr_formapagento:atom).

:- initialization( ( db_attach('C:/UFU_repositorio/ProLog/Trabalho/tbl_formaPagamento.pl', []),
                     at_halt(db_sync(gc(always))) )).


insere(Id_formapagamento, Descr_formapagento):-
    chave:pk(formapagamento, Id_formapagamento),
    with_mutex(tabFormaPag,
               assert_tabFormaPag(Id_formapagamento, Descr_formapagento)).

remove(Id_formapagamento):-
    with_mutex(tabFormaPag,
               retract_tabFormaPag(Id_formapagamento,_)).

atualiza(Id_formapagamento, Descr_formapagento):-
    with_mutex(tabFormaPag,
               (  retractall_tabFormaPag(Id_formapagamento,_),
                  assert_tabFormaPag(Id_formapagamento, Descr_formapagento))).
