% http_handler, http_reply_file
:- use_module(library(http/http_dispatch)).

% http:location
:- use_module(library(http/http_path)).

%:- ensure_loaded(caminhos).

/***********************************
 *                                 *
 *      Rotas do Servidor Web      *
 *                                 *
 ***********************************/

:- multifile http:location/3.
:- dynamic   http:location/3.

%% http:location(Apelido, Rota, Opções)
%      Apelido é como será chamada uma Rota do servidor.
%      Os apelidos css, icons e js já estão definidos na
%      biblioteca http/http_server_files, os demais precisam
%      ser definidos.

http:location(img, root(img), []).
http:location(api, root(api), []).
http:location(api1, api(v1), []).
http:location(webfonts, root(webfonts), []).

/**************************
 *                        *
 *      Tratadores        *
 *                        *
 **************************/

% Recursos estáticos
:- http_handler( css(.),
                 serve_files_in_directory(dir_css), [prefix]).
:- http_handler( img(.),
                 serve_files_in_directory(dir_img), [prefix]).
:- http_handler( js(.),
                 serve_files_in_directory(dir_js),  [prefix]).
:- http_handler( webfonts(.),
                 serve_files_in_directory(dir_webfonts), [prefix]).
:- http_handler( '/favicon.ico',
                 http_reply_file(dir_img('favicon.ico', [])),
                 []).

% Rotas do Frontend

%% A página inicial
:- http_handler( root(.), entrada,   []).

%% A página de cadastro de novos bookmarks
/* :- http_handler( root(bookmark), cadastro, []).
 */
%%pagina de cadastro
:- http_handler(root(usuarios), usuarios , []).
:- http_handler(root(clientes), clientes , []).
:- http_handler(root(tesouraria), tesouraria , []).
:- http_handler(root(formapagamento), formapagamento , []).
:- http_handler(root(contabancaria), contabancaria , []).
:- http_handler(root(empresa), empresa , []).
:- http_handler(root(planodeContas), planodeContas , []).
:- http_handler(root(fornecedores), fornecedores , []).


%% A página para edição de um bookmark existente
/* :- http_handler( root(bookmark/editar/Id), editar(Id), []).
 */

% Rotas da API
:- http_handler( api1(bookmarks/Id), bookmarks(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
%Pedro
:- http_handler( api1(usuarios/Iduser), api_usuarios:usuarios(Metodo, Iduser),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
:- http_handler( api1(clientes/IdClientes), api_clientes:clientes(Metodo, IdClientes),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
%Victor
:- http_handler( api1(tesouraria/Idtesouraria), api_tesouraria:tesouraria(Metodo, Idtesouraria),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
:- http_handler( api1(formapagamento/Idformapagamento), api_formapagamento:formapagamento(Metodo, Idformapagamento),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
%Guilherme
:- http_handler( api1(contabancaria/IdContaBancarias), api_contabancaria:contabancaria(Metodo, IdContaBancarias),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(empresa/IdEmpresa), api_empresa:empresa(Metodo, IdEmpresa),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
%Henrique
:- http_handler( api1(fornecedores/IdFornec), api_fornecedores:fornecedores(Metodo, IdFornec),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(planodeContas/IdPlano), api_planodeContas:planodeContas(Metodo, IdPlano),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).
/* 
:- http_handler( api1(empresa/IdEmpresa), api_empresa:empresa(Metodo, IdEmpresa),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]). */