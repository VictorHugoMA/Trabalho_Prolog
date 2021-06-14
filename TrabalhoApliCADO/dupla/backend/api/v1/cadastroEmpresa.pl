/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(cadastroEmpresa), []).

/*
   GET api/v1/cadastroEmpresa
/
   Retorna uma lista com todos os cadastroEmpresa
.
*/
cadastroEmpresa(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/cadastroEmpresa
/Id
   Retorna o 'cadastroEmpresa
' com Id 1 ou erro 404 caso o 'cadastroEmpresa
' não
   seja encontrado.
*/
cadastroEmpresa(get, AtomId, _Pedido):-
    atom_number(AtomId, IdContaBancarias),
    !,
    envia_tupla(IdContaBancarias).

/*
   POST api/v1/cadastroEmpresa

   Adiciona um novo cadastroEmpresa
. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
cadastroEmpresa(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/cadastroEmpresa
/Id
  Atualiza o cadastroEmpresa
 com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
cadastroEmpresa(put, AtomId, Pedido):-
    atom_number(AtomId, IdContaBancarias),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdContaBancarias).

/*
   DELETE api/v1/cadastroEmpresa
/Id
   Apaga o cadastroEmpresa
 com o Id informado
*/
cadastroEmpresa(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdContaBancarias),
    !,
    cadastroEmpresa
:remove(IdContaBancarias),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

cadastroEmpresa(Metodo, IdContaBancarias, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdContaBancarias))).


insere_tupla5( _{ id_contabancaria:IdContaBancarias, id_classificacao:Classificacao,
                 id_numeroconta:NumeroConta, id_numeroagencia:NumeroAgencia,
                 id_datasaldoinicial:DataSaldoInicial}, IdContaBancarias}):-
    % Validar URL antes de inserir
    cadastroEmpresa
:insere( IdContaBancarias, Classificacao, 
                                  NumeroConta, NumeroAgencia, DataSaldoInicial)
    -> envia_tupla(IdContaBancarias)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla5( _{ id_contabancaria:IdContaBancarias, id_classificacao:Classificacao,
                   id_numeroconta:NumeroConta, id_numeroagencia:NumeroAgencia,
                   id_datasaldoinicial:DataSaldoInicial}, IdContaBancarias)
    -> envia_tupla(IdContaBancarias)
    ;  throw(http_reply(not_found(IdContaBancarias))).


envia_tupla5(IdContaBancarias):-
       cadastroEmpresa
    :cadastroEmpresa
    (IdContaBancarias, Classificacao, 
                                  NumeroConta, NumeroAgencia, DataSaldoInicial)
    -> reply_json_dict( _{id_contabancaria:IdContaBancarias, id_classificacao:Classificacao,
                          id_numeroconta:NumeroConta, id_numeroagencia:NumeroAgencia,
                          id_datasaldoinicial:DataSaldoInicial} )
    ;  throw(http_reply(not_found(IdContaBancarias))).


envia_tabela5 :-
    findall( _{id_contabancaria:IdContaBancarias, id_classificacao:Classificacao,
                id_numeroconta:NumeroConta, id_numeroagencia:NumeroAgencia,
                id_datasaldoinicial:DataSaldoInicial},
             cadastroEmpresa
            :cadastroEmpresa
            (IdContaBancarias, Classificacao, 
                                                         NumeroConta, NumeroAgencia, DataSaldoInicial),
             Tuplas ),
    reply_json_dict(Tuplas).