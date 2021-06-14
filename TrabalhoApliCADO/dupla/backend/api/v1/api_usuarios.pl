:-module(api_usuarios,[usuarios/3]).

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
   GET api/v1/usuarios/Iduser
   Retorna o `usuarios` com Iduser 1 ou erro 404 caso o `usuarios` não
   seja encontrado.
*/
usuarios(get, AtomId, _Pedido):-
    atom_number(AtomId, Iduser),
    !,
    envia_tupla(Iduser).

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
  PUT api/v1/usuarios/Iduser
  Atualiza o usuarios com o Iduser informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
usuarios(put, AtomId, Pedido):-
    atom_number(AtomId, Iduser),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Iduser).

/*
   DELETE api/v1/usuarios/Iduser
   Apaga o usuarios com o Iduser informado
*/
usuarios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Iduser),
    !,
    usuarios:remove(Iduser),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

usuarios(Metodo, Iduser, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Iduser))).


insere_tupla( _{ usuario:User,nome:Nome,senha:Senha,confirmaSenha:Confirmasenha}):-
    % Validar URL antes de inserir
    usuarios:insere(Iduser,User,Nome,Senha,Confirmasenha)
    -> envia_tupla(Iduser)
    ;  throw(http_reply(bad_request('URL ausente'))).

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