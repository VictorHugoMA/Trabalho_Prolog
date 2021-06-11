%Pagina ex 2

:- module(
        cadastroContaBancaria,
        [ cadastroContaBancaria/5, insere/5]
).

:- use_module(library(persistency)).
:- persistent
   cadastroContaBancaria( idContaBancarias:nonneg,
                          classificacao:atom,
                          numeroConta:nonneg,
                          numeroAgencia:nonneg,
                          dataSaldoinicial:atom).

:- initialization( ( db_attach('C:/Users/User/OneDrive/Documentos/UFU/Prolog/Trabalho/tbl_cadastroContaBancaria.pl', []),
                     at_halt(db_sync(gc(always))) )).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).
                        
insere( IdContaBancarias, Classificacao,
        NumeroConta, NumeroAgencia,     
        DataSaldoInicial):-
    chave:pk(cadastroContaBancaria , IdContaBancarias),
    with_mutex(cadastroContaBancaria,
               assert_cadastroContaBancaria(IdContaBancarias, Classificacao,
                                  NumeroConta, NumeroAgencia,
                                  DataSaldoInicial)).


remove(IdContaBancarias):-
    with_mutex(cadastroContaBancaria,
               retract_cadastroContaBancaria(IdContaBancarias, _, _, _, _)).

atualiza(IdContaBancarias, Classificacao,
         NumeroConta, NumeroAgencia,     
         DataSaldoInicial):-
    with_mutex(cadastroContaBancaria,
               ( retractall_cadastroContaBancaria(IdContaBancarias,_,_,_,_),

                 assert_cadastroContaBancaria(IdContaBancarias, Classificacao,
                                              NumeroConta, NumeroAgencia,
                                              DataSaldoInicial))).

sincroniza :-
    db_sync(gc(always)).