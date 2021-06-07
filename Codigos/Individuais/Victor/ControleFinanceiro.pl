/* Modulos */
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_head)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_client)).
:- use_module(tesouraria,[]). 
:- use_module(formapagamento,[]).
:-use_module(chave, []).

servidor(Porta) :-
http_server(http_dispatch, [port(Porta)]).

/* Liga a rota ao tratador */
:- http_handler(root(.), home , []).
:- http_handler(root(tesouraria), tesouraria , []).
:- http_handler(root(formapagamento), formapagamento , []).

/* Localização dos diretórios no sistema de arquivos */
:- multifile user:file_search_path/2.

user:file_search_path(dir_css, 'C:/UFU_repositorio/ProLog/Trabalho/css').
user:file_search_path(dir_js, 'C:/UFU_repositorio/ProLog/Trabalho/js').

/* Liga as rotas aos respectivos diretórios */
:-http_handler(css(.), serve_files_in_directory(dir_css), [prefix]).
:-http_handler(js(.), serve_files_in_directory(dir_js), [prefix]).


:- multifile user:body//2.

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



home(_Pedido) :-
    reply_html_page(
    bootstrap,
    [ title('Controle Financeiro')],
    [ div(class(container),
        [ h1('Sistema de Informacao para Controle Financeiro de uma Microempresa'),
            nav(class(['nav', 'flex-column']),
                [ \link_tesouraria(1),
                  \link_formapagamento(1)])
                ])
    ]).

link_tesouraria(1) -->
    html(a([ class(['nav-link']),
        href('/tesouraria')],
        'Tesouraria')).
link_formapagamento(1) -->
    html(a([ class(['nav-link']),
        href('/formapagamento')],
        'Forma de Pagamento')).

tesouraria(_Pedido):-
    reply_html_page(
            bootstrap,
            [ title('Tesouraria')],
              form([ class(container),action='/receptorTes', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Tesouraria'),
                    \campo(id_empresa, 'ID Empresa', number),
                    \campo(id_cliente, 'ID Cliente', number),
                    \campo(id_planoContas, 'ID Plano de Contas', number),
                    \campo(id_fornecedores, 'ID Fornecedores', number),
                    \campo(formapagamento_tes, 'Formas de Pagamento', text),
                    \campo(valor_tes, 'Valor', text),
                    \campo(numero_tes, 'Numero', text),
                    \campo(data_emissao_tes, 'Data de Emissao', date),
                    \campo(data_venc_tes, 'Data de Vencimento', date),
                    \campo(data_disp_tes, 'Data de Disponibilidade', date),
          

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])).
 

formapagamento(_Pedido):-
    reply_html_page(
            bootstrap,
            [ title('Formas de Pagamentos')],
              form([ class(container),action='/receptorFor', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Formas de Pagamentos'),
                    \campo(descr_formapagento, 'Descricao', text),
          

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])).

retorna_home -->
    html(div(class(row),
        a([ class(['btn', 'btn-primary']), href('/')],
            'Voltar para o inicio'))).

campo(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
        [   label([for(Nome), class('form-label')], Rotulo),
            input([type(Tipo), class('form-control'),
                id(Nome), name(Nome)])
        ]
        )).


:- http_handler('/receptorTes', recebe_Tes(Method),
            [ method(Method),
                methods([post]) ]).

recebe_Tes(post,Pedido) :-
        catch(
            http_parameters(Pedido,[id_empresa(Id_empresa, [integer]), id_cliente(Id_cliente, [integer]), 
                                    id_planoContas(Id_planoContas, [integer]), id_fornecedores(Id_fornecedores, [integer]),
                                    formapagamento_tes(Formapagamento_tes, []), valor_tes(Valor_tes, []), numero_tes(Numero_tes, []), 
                                    data_emissao_tes(Data_emissao_tes, []), data_venc_tes(Data_venc_tes, []), data_disp_tes(Data_disp_tes, [])]),
            _E,
            fail),
        !,
        tabTesouraria:insere(_Id_tesouraria, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
                             Formapagamento_tes, Valor_tes, Numero_tes,
                             Data_emissao_tes, Data_venc_tes, Data_disp_tes),
        reply_html_page(
            bootstrap,
            [ title('Pedido')],
            [ div(class(container),
                [ h1('Pedido Recebido'),
                    \retorna_home
                ])
            ]).



:- http_handler('/receptorFor', recebe_FormaPag(Method),
            [ method(Method),
                methods([post]) ]).

recebe_FormaPag(post,Pedido) :-
        catch(
            http_parameters(Pedido,[descr_formapagento(Descr_formapagento,[])]),
            _E,
            fail),
        !,
        tabFormaPag:insere(_Id_formapagamento, Descr_formapagento),
        reply_html_page(
            bootstrap,
            [ title('Pedido')],
            [ div(class(container),
                [ h1('Pedido Recebido'),
                    \retorna_home
                ])
            ]).


/*
recebe_formulario2(post, Pedido) :-
    http_read_data(Pedido, Dados, []),
    format('Content-type: text/html~n~n', []),
    format('<p>', []),
    portray_clause(Dados), % escreve os dados do corpo
    format('</p><p>========~n', []),portray_clause(Pedido), % escreve o pedido todo
    format('</p>').
*/