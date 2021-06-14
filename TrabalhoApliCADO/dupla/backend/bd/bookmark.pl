:- module(
       bookmark,
       [ carrega_tab/1,
         bookmark/3,
         insere/3,
         remove/1,
         atualiza/3 ]).

:- use_module(library(persistency)).

:- use_module(chave, []).

:- persistent
   bookmark( id:positive_integer, % chave primaria
             titulo:string,
             url:string ).


:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).


insere(Id, Titulo, URL):-
    chave:pk(bookmark, Id),
    with_mutex(bookmark,
               assert_bookmark(Id, Titulo, URL)).

remove(Id):-
    with_mutex(bookmark,
               retractall_bookmark(Id, _Titulo, _URL)).


atualiza(Id, Titulo, URL):-
    with_mutex(bookmark,
               ( retract_bookmark(Id, _TitAntigo, _URLAntiga),
                 assert_bookmark(Id, Titulo, URL)) ).
