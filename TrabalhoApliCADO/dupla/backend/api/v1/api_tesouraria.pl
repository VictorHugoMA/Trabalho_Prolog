:-module(api_tesouraria,[tesouraria/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(tesouraria), []).

/*
   GET api/v1/tesouraria/
   Retorna uma lista com todos os tesouraria.
*/
tesouraria(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/tesouraria/Id
   Retorna o `tesouraria` com Id 1 ou erro 404 caso o `tesouraria` não
   seja encontrado.
*/
tesouraria(get, AtomId, _Pedido):-
    atom_number(AtomId, Idtesouraria),
    !,
    envia_tupla(Idtesouraria).

/*
   POST api/v1/tesouraria
   Adiciona um novo tesouraria. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
tesouraria(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/tesouraria/Id
  Atualiza o tesouraria com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
tesouraria(put, AtomId, Pedido):-
    atom_number(AtomId, Idtesouraria),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Idtesouraria).

/*
   DELETE api/v1/tesouraria/Id
   Apaga o tesouraria com o Id informado
*/
tesouraria(delete, AtomId, _Pedido):-
    atom_number(AtomId, Idtesouraria),
    !,
    tesouraria:remove(Idtesouraria),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

tesouraria(Metodo, Idtesouraria, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Idtesouraria))).


insere_tupla( _{idtesouraria:Idtesouraria, idempresa:Idempresa, idcliente:Idcliente, idplanoContas:IdplanoContas, idfornecedores:Idfornecedores,
         formapagamentotes:Formapagamentotes, valortes:Valortes, numerotes:Numerotes, dataemissaotes:Dataemissaotes,
         datavenctes:Datavenctes, datadisptes:Datadisptes}):-
    % Validar URL antes de inserir
    tesouraria:insere(Idtesouraria, Idempresa, Idcliente, IdplanoContas, Idfornecedores,
         Formapagamentotes, Valortes, Numerotes, Dataemissaotes,
         Datavenctes, Datadisptes)
    -> envia_tupla(Idtesouraria)
    ;  throw(http_reply(bad_request('URL ausente'))).



atualiza_tupla( _{  idtesouraria:Idtesouraria, idempresa:Idempresa, idcliente:Idcliente, idplanoContas:IdplanoContas, idfornecedores:Idfornecedores,
         formapagamentotes:Formapagamentotes, valortes:Valortes, numerotes:Numerotes, dataemissaotes:Dataemissaotes,
         datavenctes:Datavenctes, datadisptes:Datadisptes}, Idtesouraria):-
       tesouraria:atualiza(  Idtesouraria, Idempresa, Idcliente, IdplanoContas, Idfornecedores,
         Formapagamentotes, Valortes, Numerotes, Dataemissaotes,
         Datavenctes, Datadisptes)
    -> envia_tupla(Idtesouraria)
    ;  throw(http_reply(not_found(Idtesouraria))).




envia_tupla(Idtesouraria):-
       tesouraria:tesouraria( Idtesouraria, Idempresa, Idcliente, IdplanoContas, Idfornecedores,
         Formapagamentotes, Valortes, Numerotes, Dataemissaotes,
         Datavenctes, Datadisptes)
    -> reply_json_dict( _{  idtesouraria:Idtesouraria, idempresa:Idempresa, idcliente:Idcliente, idplanoContas:IdplanoContas, idfornecedores:Idfornecedores,
         formapagamentotes:Formapagamentotes, valortes:Valortes, numerotes:Numerotes, dataemissaotes:Dataemissaotes,
         datavenctes:Datavenctes, datadisptes:Datadisptes} )
    ;  throw(http_reply(not_found(Idtesouraria))).


envia_tabela :-
    findall( _{ idtesouraria:Idtesouraria, idempresa:Idempresa, idcliente:Idcliente, idplanoContas:IdplanoContas, idfornecedores:Idfornecedores,
         formapagamentotes:Formapagamentotes, valortes:Valortes, numerotes:Numerotes, dataemissaotes:Dataemissaotes,
         datavenctes:Datavenctes, datadisptes:Datadisptes},
             tesouraria:tesouraria(   Idtesouraria, Idempresa, Idcliente, IdplanoContas, Idfornecedores,
         Formapagamentotes, Valortes, Numerotes, Dataemissaotes,
         Datavenctes, Datadisptes),
             Tuplas ),
    reply_json_dict(Tuplas).