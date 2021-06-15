:- module(
       tesouraria,
       [carrega_tab/1, tesouraria/11, insere/11, remove/1, atualiza/11]
   ).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   tesouraria(idtesouraria:nonneg,
                idempresa:string,
                idcliente:string,
                idplanoContas:string,
                idfornecedores:string,
                formapagamentotes:string,
                valortes:string,
                numerotes:string,
                dataemissaotes:string,
                datavenctes:string,
                datadisptes:string).
                
:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

/* :- initialization( ( db_attach('tbl_tesouraria.pl', []),
                     at_halt(db_sync(gc(always))) )). */

insere(Idtesouraria,Idempresa,Idcliente,IdplanoContas,Idfornecedores,Formapagamentotes,Valortes,Numerotes,Dataemissaotes,Datavenctes,Datadisptes):-
    chave:pk(tesouraria, Idtesouraria),
    with_mutex(tesouraria,
               assert_tesouraria(Idtesouraria,Idempresa,Idcliente,IdplanoContas,Idfornecedores,Formapagamentotes,Valortes,Numerotes,Dataemissaotes,Datavenctes,Datadisptes)).

remove(Idtesouraria):-
    with_mutex(tesouraria,
               retract_tesouraria(Idtesouraria,_,_,_,_,_,_,_,_,_,_)).

atualiza(Idtesouraria,Idempresa,Idcliente,IdplanoContas,Idfornecedores,Formapagamentotes,Valortes,Numerotes,Dataemissaotes,Datavenctes,Datadisptes):-
    with_mutex(tesouraria,
               (  retractall_tesouraria(Idtesouraria,_,_,_,_,_,_,_,_,_,_),               
                  assert_tesouraria(Idtesouraria,Idempresa,Idcliente,IdplanoContas,Idfornecedores,Formapagamentotes,Valortes,Numerotes,Dataemissaotes,Datavenctes,Datadisptes))).