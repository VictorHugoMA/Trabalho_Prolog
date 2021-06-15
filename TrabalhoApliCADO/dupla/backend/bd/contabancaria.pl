:- module(
        contabancaria,
        [ carrega_tab/1,contabancaria/5, insere/5, remove/1, atualiza/5]
).

   
:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   contabancaria( idContaBancarias:nonneg,
                          classificacao:string,
                          numeroConta:string,
                          numeroAgencia:string,
                          dataSaldoinicial:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).
                        
insere( IdContaBancarias,Classificacao,NumeroConta,NumeroAgencia,DataSaldoInicial):-
    chave:pk(contabancaria , IdContaBancarias),
    with_mutex(contabancaria,
               assert_contabancaria(IdContaBancarias,Classificacao,NumeroConta,NumeroAgencia,DataSaldoInicial)).


remove(IdContaBancarias):-
    with_mutex(contabancaria,
               retract_contabancaria(IdContaBancarias,_,_,_,_)).

atualiza(IdContaBancarias,Classificacao,NumeroConta,NumeroAgencia,DataSaldoInicial):-
    with_mutex(contabancaria,
               ( retractall_contabancaria(IdContaBancarias,_,_,_,_),
                 assert_contabancaria(IdContaBancarias,Classificacao,NumeroConta,NumeroAgencia,DataSaldoInicial))).
