:- module(
       logins,
       [
           valida/2
       ]
   ).
/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


<<<<<<< HEAD
:- use_module(bd(usuarios), []).

=======
:- use_module(bd(usuário), []).
:- use_module(bd(função), []).
:- use_module(bd(usuário_função), []).
>>>>>>> 3cf56d031301a3824fdd2f070a00dde03c29fb02


% http_read_data está aqui
%% :- use_module(library(http/http_client)).

%% valida(post, Pedido):-
%%     http_read_data(Pedido, Dados, []), !,
%%     format('Content-type: text/html~n~n', []),
%% 	format('<p>', []),
%%     portray_clause(Dados), % escreve os dados do corpo
%% 	format('</p><p>========~n', []),
%% 	portray_clause(Pedido), % escreve o pedido todo
%% 	format('</p>').


valida(post, Pedido):-
    catch(
        http_parameters(Pedido,
                        [ 
<<<<<<< HEAD
                            usuario(User,   [ string ]),
                            senha(Senha,   [ length >= 2 ])
=======
                            email(Email,   [ string ]),
                            senha(Senha,   [ length >= 2 ]),
                            função(Função, [ oneof([ admin, prof, estudante]) ])
>>>>>>> 3cf56d031301a3824fdd2f070a00dde03c29fb02
                        ]),
        _E,
        fail ),
    !,
<<<<<<< HEAD
    (  credencial_valida(User, Senha, Iduser, _Nome)
    -> % Redireciona para a página de entrada do usuário
       http_redirect(see_other, root(Iduser), Pedido)
=======
    (  credencial_válida(Email, Senha, Função, Usuário_ID, _Nome)
    -> % Redireciona para a página de entrada do usuário
       http_redirect(see_other, root(Função/Usuário_ID), Pedido)
>>>>>>> 3cf56d031301a3824fdd2f070a00dde03c29fb02
    ;  http_link_to_id(login, [ motivo('Falha no login') ], Link),
       http_redirect(see_other, Link, Pedido)
    ).


/* Essa página será exibida em caso de erro de validação
   de algum parâmetro */
valida(_, _Pedido):-
    reply_html_page(bootstrap5,
                    [ title('Erro no login') ],
                    [ h1('Erro'),
<<<<<<< HEAD
                      p('Algum parametro nao e valido')
=======
                      p('Algum parâmetro não é válido')
>>>>>>> 3cf56d031301a3824fdd2f070a00dde03c29fb02
                    ]).



/*******************************
 *       DADOS DO USUÁRIO      *
 *******************************/


%!  credencial_válida(+Email, +Senha, +Função, -UsuárioId, -Nome) é semidet.
%
%   Verdadeiro se Senha é a senha correta para usuário com o dado Email e
%   com a função Função.

<<<<<<< HEAD
credencial_valida(User, Senha,_,_,_):-
    usuarios:senha_valida(User, Senha, Iduser, Nome).

    
    
    
    
    
=======
credencial_válida(Email, Senha, Função, Usuário_ID, Nome):-
    usuário:senha_válida( Email, Senha, Usuário_ID, Nome ),
    possui_função( Usuário_ID, Função ).

possui_função(Usuário_ID, Função):-
    usuário_função:usuário_função(_, Usuário_ID, Função_ID, _, _),
    função:função(Função_ID, Função, _, _).
>>>>>>> 3cf56d031301a3824fdd2f070a00dde03c29fb02
