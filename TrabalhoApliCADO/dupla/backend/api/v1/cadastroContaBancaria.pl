/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(cadastroContaBancaria), []).

/*
   GET api/v1/cadastroContaBancaria/
   Retorna uma lista com todos os cadastroContaBancaria.
*/
cadastroContaBancaria(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/cadastroContaBancaria/Id
   Retorna o 'cadastroContaBancaria' com Id 1 ou erro 404 caso o 'cadastroContaBancaria' não
   seja encontrado.
*/
cadastroContaBancaria(get, AtomId, _Pedido):-
    atom_number(AtomId, IdContaBancarias),
    !,
    envia_tupla(IdContaBancarias).

/*
   POST api/v1/cadastroContaBancaria
   Adiciona um novo cadastroContaBancaria. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
cadastroContaBancaria(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/cadastroContaBancaria/Id
  Atualiza o cadastroContaBancaria com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
cadastroContaBancaria(put, AtomId, Pedido):-
    atom_number(AtomId, IdContaBancarias),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdContaBancarias).

/*
   DELETE api/v1/cadastroContaBancaria/Id
   Apaga o cadastroContaBancaria com o Id informado
*/
cadastroContaBancaria(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdContaBancarias),
    !,
    cadastroContaBancaria:remove(IdContaBancarias),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

cadastroContaBancaria(Metodo, IdContaBancarias, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdContaBancarias))).


insere_tupla5( _{ id_contabancaria:IdContaBancarias, id_classificacao:Classificacao,
                 id_numeroconta:NumeroConta, id_numeroagencia:NumeroAgencia,
                 id_datasaldoinicial:DataSaldoInicial}, IdContaBancarias}):-
    % Validar URL antes de inserir
    cadastroContaBancaria:insere( IdContaBancarias, Classificacao, 
                                  NumeroConta, NumeroAgencia, DataSaldoInicial)
    -> envia_tupla(IdContaBancarias)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla5( _{ id_contabancaria:IdContaBancarias, id_classificacao:Classificacao,
                   id_numeroconta:NumeroConta, id_numeroagencia:NumeroAgencia,
                   id_datasaldoinicial:DataSaldoInicial}, IdContaBancarias)
    -> envia_tupla(IdContaBancarias)
    ;  throw(http_reply(not_found(IdContaBancarias))).


envia_tupla5(IdContaBancarias):-
       cadastroContaBancaria:cadastroContaBancaria(IdContaBancarias, Classificacao, 
                                  NumeroConta, NumeroAgencia, DataSaldoInicial)
    -> reply_json_dict( _{id_contabancaria:IdContaBancarias, id_classificacao:Classificacao,
                          id_numeroconta:NumeroConta, id_numeroagencia:NumeroAgencia,
                          id_datasaldoinicial:DataSaldoInicial} )
    ;  throw(http_reply(not_found(IdContaBancarias))).


envia_tabela5 :-
    findall( _{id_contabancaria:IdContaBancarias, id_classificacao:Classificacao,
                id_numeroconta:NumeroConta, id_numeroagencia:NumeroAgencia,
                id_datasaldoinicial:DataSaldoInicial},
             cadastroContaBancaria:cadastroContaBancaria(IdContaBancarias, Classificacao, 
                                                         NumeroConta, NumeroAgencia, DataSaldoInicial),
             Tuplas ),
    reply_json_dict(Tuplas).