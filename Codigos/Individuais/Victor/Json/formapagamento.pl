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
   GET api/v1/formapagamento/Id
   Retorna o `formapagamento` com Id 1 ou erro 404 caso o `formapagamento` não
   seja encontrado.
*/
formapagamento(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

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
  PUT api/v1/formapagamento/Id
  Atualiza o formapagamento com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
formapagamento(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).

/*
   DELETE api/v1/formapagamento/Id
   Apaga o formapagamento com o Id informado
*/
formapagamento(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    tabFormaPag:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

formapagamento(Metodo, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id))).


insere_tupla( _{ descr_formapagento: Descr_formapagento}):-
    % Validar URL antes de inserir
    tabFormaPag:insere(Id, Descr_formapagento)
    -> envia_tupla(Id).

atualiza_tupla( _{ descr_formapagento: Descr_formapagento}, Id):-
       tabFormaPag:atualiza(Id, Descr_formapagento)
    -> envia_tupla(Id)
    ;  throw(http_reply(not_found(Id))).


envia_tupla(Id):-
       tabFormaPag:tabFormaPag(Id, Descr_formapagento)
    -> reply_json_dict( _{id:Id, descr_formapagento: Descr_formapagento} )
    ;  throw(http_reply(not_found(Id))).


envia_tabela :-
    findall( _{id:Id, descr_formapagento: Descr_formapagento},
             tabFormaPag:tabFormaPag(Id,Descr_formapagento),
             Tuplas ),
    reply_json_dict(Tuplas).