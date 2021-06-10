:- module(
       chave,
       [ pk/2,
         cria_pk/2 ]
   ).

:- use_module(library(persistency)).

:- persistent
   chave( nome:atom,
          valor:positive_integer ).

:- initialization( ( db_attach('tbl_chave.pl', []),
                     at_halt(db_sync(gc(always))) ) ).


pk(Nome, Valor):-
    atom_concat(pk, Nome, Mutex),
    with_mutex(Mutex,
               (
                   ( chave(Nome, ValorAtual) ->
                     ValorAntigo = ValorAtual;
                     ValorAntigo = 0 ),
                   Valor is ValorAntigo + 1,
                   retractall_chave(Nome,_), % remove o valor antigo
                   assert_chave(Nome, Valor)) ). % atualiza com o novo


% valores iniciais diferente de 1

cria_pk(Nome, ValorInicial):-
    atom_concat(pk, Nome, Mutex),
    with_mutex(Mutex,
               ( chave(Nome, _) ->
                 true; % Não inicializa caso a chave já exista
                 assert_chave(Nome, ValorInicial) ) ).