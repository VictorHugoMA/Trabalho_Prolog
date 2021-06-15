:-module(api_formapagamento,[formapagamento/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(formapagamento), []).

/*
   GET api/v1/formapagamento/
   Retorna uma lista com todos os formapagamento.
*/
formapagamento(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/formapagamento/Idformapagamento
   Retorna o `formapagamento` com Id 1 ou erro 404 caso o `formapagamento` não
   seja encontrado.
*/
formapagamento(get, AtomId, _Pedido):-
    atom_number(AtomId, Idformapagamento),
    !,
    envia_tupla(Idformapagamento).

/*
   POST api/v1/formapagamento
   Adiciona um novo formapagamento. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
formapagamento(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/formapagamento/Idformapagamento
  Atualiza o formapagamento com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
formapagamento(put, AtomId, Pedido):-
    atom_number(AtomId, Idformapagamento),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Idformapagamento).

/*
   DELETE api/v1/formapagamento/Idformapagamento
   Apaga o formapagamento com o Id informado
*/
formapagamento(delete, AtomId, _Pedido):-
    atom_number(AtomId, Idformapagamento),
    !,
    formapagamento:remove(Idformapagamento),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

formapagamento(Metodo, Idformapagamento, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Idformapagamento))).


insere_tupla( _{ descrformapagento:Descrformapagento}):-
    % Validar URL antes de inserir
    formapagamento:insere(Idformapagamento,Descrformapagento)
    -> envia_tupla(Idformapagamento)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ descrformapagento:Descrformapagento}, Idformapagamento):-
       formapagamento:atualiza(Idformapagamento, Descrformapagento)
    -> envia_tupla(Idformapagamento)
    ;  throw(http_reply(not_found(Idformapagamento))).


envia_tupla(Idformapagamento):-
       formapagamento:formapagamento(Idformapagamento, Descrformapagento)
    -> reply_json_dict( _{idformapagamento:Idformapagamento,descrformapagento:Descrformapagento} )
    ;  throw(http_reply(not_found(Idformapagamento))).


envia_tabela :-
    findall( _{idformapagamento:Idformapagamento,descrformapagento:Descrformapagento},
             formapagamento:formapagamento(Idformapagamento,Descrformapagento),
             Tuplas ),
    reply_json_dict(Tuplas).