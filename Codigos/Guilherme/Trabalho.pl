/* Todos os Módulos */
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_head)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_client)).
:- use_module(cadastroEmpresa,[]).
:- use_module(cadastroContaBancaria,[]).

servidor(Porta) :-
http_server(http_dispatch, [port(Porta)]).

/* html_requires esta aqui                           */
:- use_module(library(http/html_head)).

/* serve_files_in_directory esta aqui                */
:- use_module(library(http/http_server_files)).

/* Localizacao dos diretorios no sistema de arquivos */
:- multifile user:file_search_path/2.
user:file_search_path(dir_css,'C:/Users/User/OneDrive/Documentos/UFU/Prolog/Trabalho/css').
user:file_search_path(dir_js,'C:/Users/User/OneDrive/Documentos/UFU/Prolog/Trabalho/js').

/* Liga as rotas aos respectivos diretorios          */
:- http_handler(css(.), serve_files_in_directory(dir_css), [prefix]).
:- http_handler(js(.), serve_files_in_directory(dir_js), [prefix]).


/* Liga a rota ao tratador                           */
:- http_handler(root(.), home , []).
:- http_handler(root(cadastroEmpresa), cadastroEmpresa, []).
:- http_handler(root(cadastroContaBancaria), cadastroContaBancaria, []).


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


% Pagina home

home(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('CONTROLE FINANCEIRO DE UMA MICROEMPRESA')],
        [ div(class(container),
            [ h1('SISTEMAS DE INFORMACAO PARA CONTROLE FINANCEIRO DE UMA MICROEMPRESA VIA WEB'),
                nav(class(['nav','flex-column']),
                    [ \link_empresas(1),
                        \link_cadastrocontas(1) ])
                ])
        ]).

link_empresas(1) -->
    html(a([class(['nav-link']),
            href('/cadastroEmpresa')],
        'Cadastro de Empresas')).

link_cadastrocontas(1) -->
    html(a([class(['nav-link']),
            href('/cadastroContaBancaria')],
        'Cadastro de Contas Bancarias')).



retorna_home -->
    html(div(class(row),
            a([ class(['btn','btn-primary']), href('/')],
                'Voltar para o inicio'))).

campo(Nome,Rotulo,Tipo) -->
    html(div(class('mb-3'),
    [label([for=Nome, class('form-label')],Rotulo),
        input([name=Nome,type=Tipo,class('form-control'),id=Nome])])).



cadastroEmpresa(_Pedido):-
    reply_html_page(
            bootstrap,
            [ title('Cadastro Empresa')],
              form([ class(container),action='/concluidoEmpresa', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Principal - Empresa'),
                    \campo(idEmpresas,'Identificacao Empresa:',number),
                    \campo(razaoSocial,'Razao Social:',text),
                    \campo(identificacao,'Identificacao:',text),
                    \campo(tipoPessoa,'Tipo pessoa:',text),
                    \campo(cnpj,'CNPJ',atom),
                    \campo(inscricaoEstadual,'Inscricao Estadual:',text),
                    \campo(incricaoMunicipal,'inscricao Municipal:',text),
                    \campo(endereco,'Endereco:',text),
                    \campo(bairro,'Bairro:',text),
                    \campo(municipio,'Municipio:',text),
                    \campo(cep,'CEP:',atom),
                    \campo(uf,'Uf',text),
                    \campo(telefone,'telefone:',atom),
                    \campo(email,'E-mail:',text),
                    \campo(nomeTitular,'Nome',text),
                    \campo(cpf,'CPF',atom),
                    \campo(funcao,'Funcao',text),
          

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])).


:- http_handler('/concluidoEmpresa', recebe_formulario_empresa(Method),
            [ method(Method),
                methods([post]) ]).


recebe_formulario_empresa(post,Pedido) :-
        catch(
            http_parameters(Pedido,[idEmpresas(IdEmpresas, [integer]), razaoSocial(RazaoSocial, []), identificacao(Identificacao, []), 
                                    tipoPessoa(TipoPessoa, []), cnpj(Cnpj, []),
                                    inscricaoEstadual(InscricaoEstadual, []), inscricaoMunicipal(InscricaoMunicipal, []), endereco(Endereco, []), 
                                    bairro(Bairro, []), municipio(Municipio, []), cep(Cep, []),
                                    uf(Uf, []), telefone(Telefone, []), email(Email, []),
                                    nomeTitular(NomeTitular, []), cpf(Cpf, []), funcao(Funcao, [])]),
            _E,
            fail),
        !,
        cadastroEmpresa:insere( IdEmpresas, RazaoSocial, 
                            Identificacao, TipoPessoa, 
                            Cnpj, InscricaoEstadual,
                            InscricaoMunicipal, Endereco, 
                            Bairro, Municipio, 
                            Cep, Uf, 
                            Telefone, Email, 
                            NomeTitular, Cpf,
                            Funcao),
        reply_html_page(
            bootstrap,
            [ title('Pedido')],
            [ div(class(container),
                [ h1('Pedido Recebido'),
                    \retorna_home
                ])
            ]).


cadastroContaBancaria(_Pedido):-
    reply_html_page(
            bootstrap,
            [ title('Cadastro de Contas Bancarias')],
              form([ class(container),action='/concluidoContasBancaria', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Conta Bancaria'),
                    \campo(idContaBancarias,'Classificacao',number),
                    \campo(classificacao,'Descricao',text),
                    \campo(numeroConta,'Numero da Conta',number),
                    \campo(numeroAgencia,'Numero da Agencia',number),
                    \campo(dataSaldoinicial,'Data Incial:',date),
          

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])).

:- http_handler('/concluidoContasBancaria', recebe_formulario_conta_bancaria(Method),
            [ method(Method),
                methods([post]) ]).

recebe_formulario_conta_bancaria(post,Pedido) :-
        catch(
            http_parameters(Pedido,[idContaBancarias(IdContaBancarias,[integer]),
                                    classificacao(Classificacao,[]), 
                                    numeroConta(NumeroConta,[integer]), 
                                    numeroAgencia(NumeroAgencia,[integer]),
                                    dataSaldoinicial(DataSaldoInicial,[])]),

            _E,
            fail),
        !,
        cadastroContaBancaria:insere(IdContaBancarias, Classificacao,
                                     NumeroConta, NumeroAgencia,
                                     DataSaldoInicial),
        reply_html_page( bootstrap,[title('Demonstracao de POST')],
        [ p('Pedido recebido.'),
            \retorna_home
        ]).