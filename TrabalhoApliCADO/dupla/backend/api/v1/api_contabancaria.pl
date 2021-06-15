:-module(api_contabancaria,[contabancaria/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(contabancaria), []).

/*
   GET api/v1/contabancaria/
   Retorna uma lista com todos os contabancaria.
*/
contabancaria(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/contabancaria/Id
   Retorna o 'contabancaria' com Id 1 ou erro 404 caso o 'contabancaria' não
   seja encontrado.
*/
contabancaria(get, AtomId, _Pedido):-
    atom_number(AtomId, IdContaBancarias),
    !,
    envia_tupla(IdContaBancarias).

/*
   POST api/v1/contabancaria
   Adiciona um novo contabancaria. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
contabancaria(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/contabancaria/Id
  Atualiza o contabancaria com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
contabancaria(put, AtomId, Pedido):-
    atom_number(AtomId, IdContaBancarias),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdContaBancarias).

/*
   DELETE api/v1/contabancaria/Id
   Apaga o contabancaria com o Id informado
*/
contabancaria(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdContaBancarias),
    !,
    contabancaria:remove(IdContaBancarias),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

contabancaria(Metodo, IdContaBancarias, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdContaBancarias))).

insere_tupla( _{ classificacao:Classificacao,
                 numeroConta:NumeroConta, numeroAgencia:NumeroAgencia,
                 dataSaldoinicial:DataSaldoInicial}):-
    % Validar URL antes de inserir
    contabancaria:insere(IdContaBancarias,Classificacao,NumeroConta,NumeroAgencia,DataSaldoInicial)
    -> envia_tupla(IdContaBancarias)
    ;  throw(http_reply(bad_request('URL ausente'))).


atualiza_tupla( _{ classificacao:Classificacao,
                 numeroConta:NumeroConta, numeroAgencia:NumeroAgencia,
                 dataSaldoinicial:DataSaldoInicial}, IdContaBancarias):-
       contabancaria:atualiza(IdContaBancarias,Classificacao,NumeroConta,NumeroAgencia,DataSaldoInicial)
    -> envia_tupla(IdContaBancarias)
    ;  throw(http_reply(not_found(IdContaBancarias))).



envia_tupla(IdContaBancarias):-
       contabancaria:contabancaria(IdContaBancarias,Classificacao,NumeroConta,NumeroAgencia,DataSaldoInicial)
    -> reply_json_dict( _{idContaBancarias:IdContaBancarias, classificacao:Classificacao,
                 numeroConta:NumeroConta, numeroAgencia:NumeroAgencia,
                 dataSaldoinicial:DataSaldoInicial} )
    ;  throw(http_reply(not_found(IdContaBancarias))).


envia_tabela :-
    findall( _{idContaBancarias:IdContaBancarias, classificacao:Classificacao,
                 numeroConta:NumeroConta, numeroAgencia:NumeroAgencia,
                 dataSaldoinicial:DataSaldoInicial},
             contabancaria:contabancaria(IdContaBancarias,Classificacao,NumeroConta,NumeroAgencia,DataSaldoInicial),
             Tuplas ),
    reply_json_dict(Tuplas).