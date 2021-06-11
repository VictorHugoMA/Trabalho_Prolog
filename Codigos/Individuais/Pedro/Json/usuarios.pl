/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(usuarios), []).

/*
   GET api/v1/usuarios/
   Retorna uma lista com todos os usuarios.
*/
usuarios(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/usuarios/Id
   Retorna o `usuarios` com Id 1 ou erro 404 caso o `usuarios` não
   seja encontrado.
*/
usuarios(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

/*
   POST api/v1/usuarios
   Adiciona um novo usuarios. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
usuarios(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/usuarios/Id
  Atualiza o usuarios com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
usuarios(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).

/*
   DELETE api/v1/usuarios/Id
   Apaga o usuarios com o Id informado
*/
usuarios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    usuarios:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

usuarios(Metodo, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id))).


insere_tupla( _{ user:User,nome:Nome,senha:Senha,confirmasenha:Confirmasenha}):-
    % Validar URL antes de inserir
    usuarios:insere(Iduser,User,Nome,Senha,Confirmasenha)
    -> envia_tupla(Iduser)
    ).

atualiza_tupla( _{ user:User,nome:Nome,senha:Senha,confirmasenha:Confirmasenha}, Iduser):-
       usuarios:atualiza(Iduser,User,Nome,Senha,Confirmasenha)
    -> envia_tupla(Iduser)
    ;  throw(http_reply(not_found(Iduser))).


envia_tupla(Iduser):-
       usuarios:usuarios(Iduser,User,Nome,Senha,Confirmasenha)
    -> reply_json_dict( _{iduser:Iduser,user:User,nome:Nome,senha:Senha,confirmasenha:Confirmasenha} )
    ;  throw(http_reply(not_found(Iduser))).


envia_tabela :-
    findall( _{iduser:Iduser,user:User,nome:Nome,senha:Senha,confirmasenha:Confirmasenha},
             usuarios:usuarios(Iduser,User,Nome,Senha,Confirmasenha),
             Tuplas ),
    reply_json_dict(Tuplas).