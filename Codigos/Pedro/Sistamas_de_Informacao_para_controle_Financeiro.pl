:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).

servidor(Porta) :-
http_server(http_dispatch, [port(Porta)]).

/* html_requires está aqui                           */
:- use_module(library(http/html_head)).

/* serve_files_in_directory está aqui                */
:- use_module(library(http/http_server_files)).

/* Localização dos diretórios no sistema de arquivos */
:- multifile user:file_search_path/2.
user:file_search_path(dir_css,'css').
user:file_search_path(dir_js,'js').

/* Liga as rotas aos respectivos diretórios          */
:- http_handler(css(.),
    serve_files_in_directory(dir_css), [prefix]).

:- http_handler(js(.),
    serve_files_in_directory(dir_js), [prefix]).



% Liga a rota ao tratador

:- http_handler(root(.), home , []).

:- http_handler(root(usuarios), usuarios , []).
:- http_handler(root(clientes), clientes , []).


:- multifile  user:body//2.
user:body(bootstrap, Corpo) -->
    html(body([ \html_post(head,
        [ meta([name(viewport),
            content('width=device-width, initial-scale=1')])]),
        \html_root_attribute(lang,'pt-br'),
        \html_requires(css('bootstrap.min.css')),
        
        Corpo,
        
        script([ src('js/bootstrap.bundle.min.js'),
            type('text/javascript')], [])
        ])).


% Pagina de entrada

home(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('CONTROLE FINANCEIRO DE UMA MICROEMPRESA')],
        [ div(class(container),
            [ h1('SISTEMAS DE INFORMACAO PARA CONTROLE FINANCEIRO DE UMA MICROEMPRESA VIA WEB'),
                nav(class(['nav','flex-column']),
                    [ \link_cadastro(1),
                        \link_cliente(1) ])
                ])
        ]).


link_cadastro(1) -->
    html(a([ class(['nav-link']),
            href('/usuarios')],
        'Cadastro Usuario')).

link_cliente(1) -->
    html(a([ class(['nav-link']),
            href('/clientes')],
        'Cadastro Cliente')).


:- ensure_loaded([usuarios,clientes]).
retorna_home -->
    html(div(class(row),
            a([ class(['btn','btn-primary']), href('/')],
                'Voltar para o inicio'))).

campo(Chave,Nome,Tipo) -->
    html(div(class('mb-3'),
    [label([for(Chave), class('form-label')],Nome),
        input([type(Tipo),class('form-control'),
            id(Chave), name(Nome)])])).
