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


:- use_module(bd(usuarios), []).



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
                            usuario(User,   [ string ]),
                            senha(Senha,   [ length >= 2 ])
                        ]),
        _E,
        fail ),
    !,
    (  credencial_valida(User, Senha, Iduser, _Nome)
    -> % Redireciona para a página de entrada do usuário
       http_redirect(see_other, root(Iduser), Pedido)
    ;  http_link_to_id(login, [ motivo('Falha no login') ], Link),
       http_redirect(see_other, Link, Pedido)
    ).


/* Essa página será exibida em caso de erro de validação
   de algum parâmetro */
valida(_, _Pedido):-
    reply_html_page(bootstrap5,
                    [ title('Erro no login') ],
                    [ h1('Erro'),
                      p('Algum parametro nao e valido')
                    ]).



/*******************************
 *       DADOS DO USUÁRIO      *
 *******************************/


%!  credencial_válida(+Email, +Senha, +Função, -UsuárioId, -Nome) é semidet.
%
%   Verdadeiro se Senha é a senha correta para usuário com o dado Email e
%   com a função Função.

credencial_valida(User, Senha,_,_,_):-
    usuarios:senha_valida(User, Senha, Iduser, Nome).

    
    
    
    
    
