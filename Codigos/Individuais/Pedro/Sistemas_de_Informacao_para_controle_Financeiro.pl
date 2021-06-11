:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).

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

/* http_read_data está aqui */

:- use_module(library(http/http_client)).

/* Liga as rotas aos respectivos diretórios          */
:- http_handler(css(.),
    serve_files_in_directory(dir_css), [prefix]).

:- http_handler(js(.),
    serve_files_in_directory(dir_js), [prefix]).



% Liga a rota ao tratador

:- http_handler(root(.), home , []).

:- http_handler(root(usuarios), usuarios , []).

:- http_handler(root(clientes), clientes , []).

%CONECTANDO AS DUAS TABELAS AO MAIN

:- use_module(usuarios,[]). 
:- use_module(clientes,[]). 


%configurando bootstrap
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
                    [ \link_usuario(1),
                        \link_cliente(1), ])
                ])
        ]).


link_usuario(1) -->
    html(a([ class(['nav-link']),
            href('/usuarios')],
        'Cadastro Usuario')).

link_cliente(1) -->
    html(a([ class(['nav-link']),
            href('/clientes')],
        'Cadastro Cliente')).


retorna_home -->
    html(div(class(row),
            a([ class(['btn','btn-primary']), href('/')],
                'Voltar para o inicio'))).

campo(Nome,Rotulo,Tipo) -->
    html(div(class('mb-3'),
    [label([for=Nome, class('form-label')],Rotulo),
        input([name=Nome,type=Tipo,class('form-control'),id=Nome])])).





usuarios(_Pedido):-
    reply_html_page(
            bootstrap,
            [ title('Cadastro Usuario')],
              form([ class(container),action='/receptor1', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Insira os dados para cadastro'),
                    \campo(idusuarios,'Id de Usuario:',nonneg),
                    \campo(usuario,'Usuario:',textarea),
                    \campo(nome,'Nome:',textarea),
                    \campo(senha,'Senha:',textarea),
                    \campo(confirmaSenha,'Corfirmar Senha:',textarea),
          

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])).


:- http_handler('/receptor1', recebe_formulario_usuarios(Method),
            [ method(Method),
                methods([post]) ]).
                


recebe_formulario_usuarios(post,Pedido) :-
        catch(
            http_parameters(Pedido,[idusuarios(Iduser,[integer]),
                                    usuario(Usuario,[]), 
                                    nome(Nome,[]), 
                                    senha(Senha,[]), 
                                    confirmaSenha(Confirmasenha,[])]),
            _E,
            fail),
        !,
        usuarios:insere(Iduser,Usuario,Nome,Senha,Confirmasenha),
        reply_html_page(
            bootstrap,
            [ title('Cadastro Realizado')],
            [ div(class(container),
                [ h1('Pedido Recebido.'),
                    \retorna_home
                        ])
            ]).
/*        format('Content-type:text/html~n~n', []),
        format('<p>', []),
        portray_clause([Iduser,Usuario,Nome,Senha,Confirmasenha]), % escreve os dados do corpo
        format('</p><p>========~n', []),portray_clause(Pedido), % escreve o pedido todo
        format('</p>'). */

clientes(_Pedido) :-
    reply_html_page(
            bootstrap,
            [ title('Cadastro Cliente')],
              form([ class(container),action='/receptor2', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Insira os dados para cadastro'),
                    \campo(idClientes,'Id do Cliente:',number),
                    \campo(razaoSocial,'Razao Social:',text),
                    \campo(identificacao,'Identificacao:',text),
                    \campo(classificacao,'Classificacao:',text),
                    \campo(tipoPessoa,'Tipo Pessoa(Fisica/Juridica):',text),
                    \campo(cnpjCpf,'Cnpj/CPF:',text),
                    \campo(inscricaoEstadual,'Inscricao Estadual:',text),
                    \campo(inscricaoMunicipal,'Inscricao Municipal:',text),
                    \campo(endereco,'Endereco:',text),
                    \campo(bairro,'Bairro:',text),
                    \campo(municipio,'Municipio:',text),
                    \campo(cep,'CEP:',text),
                    \campo(uf,'Sigla Estado:',text),
                    \campo(telefone,'Telefone:',text),
                    \campo(email,'E-mail:',text),
                    \campo(nomeTitular,'Titular:',text),
                    \campo(cpf,'CPF do Titular:',text),
                    \campo(funcao,'Funcao:',text),
          

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])).

:- http_handler('/receptor2', recebe_formulario_clientes(Method),
            [ method(Method),
                methods([post]) ]).

recebe_formulario_clientes(post, Pedido) :-
        catch(
            http_parameters(Pedido,[idClientes(IdClientes,[integer]),
                                    razaoSocial(RazaoSocial,[]), 
                                    identificacao(Identificacao,[]), 
                                    classificacao(Classificacao,[]), 
                                    tipoPessoa(TipoPessoa,[]),
                                    cnpjCpf(CnpjCpf,[]),
                                    inscricaoEstadual(InscricaoEstadual,[]),
                                    inscricaoMunicipal(InscricaoMunicipal,[]),
                                    endereco(Endereco,[]),
                                    bairro(Bairro,[]),
                                    municipio(Municipio,[]),
                                    cep(Cep,[]),
                                    uf(Uf,[]),                                
                                    telefone(Telefone,[]),                                  
                                    email(Email,[]),                                  
                                    nomeTitular(NomeTitular,[]),                                  
                                    cpf(Cpf,[]),                                  
                                    funcao(Funcao,[])                                  
                                    
                                    ]),
            _E,
            fail),
        !,
        clientes:insere(IdClientes,RazaoSocial,Identificacao,Classificacao,
                        TipoPessoa,CnpjCpf,InscricaoEstadual,
                        InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,
                        Telefone,Email,NomeTitular,Cpf,Funcao),
        reply_html_page(
            bootstrap,
            [ title('Cadastro Realizado')],
            [ div(class(container),
                [ h1('Pedido Recebido.'),
                    \retorna_home
                        ])
            ]).



