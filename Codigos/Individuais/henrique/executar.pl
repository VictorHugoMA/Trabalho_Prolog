:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_client)).

% html_requires está aqui
:- use_module(library(http/html_head)).

% serve_files_in_directory está aqui
:- use_module(library(http/http_server_files)).

% Localização BDs
:- use_module(fornecedores,[]).
:- use_module(planodeContas,[]).

servidor(Porta) :-
    http_server(http_dispatch, [port(Porta)]).


% Localização dos diretórios no sistema de arquivos
:- multifile user:file_search_path/2.
user:file_search_path(dir_css, 'css').
user:file_search_path(dir_js,  'js').


% Liga as rotas aos respectivos diretórios
:- http_handler(css(.), serve_files_in_directory(dir_css), [prefix]).
:- http_handler(js(.), serve_files_in_directory(dir_js), [prefix]).

% Gabaritos
:- multifile
        user:body//2.

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

% Liga rotas aos tratadores respectivos
:- http_handler(root(.), home , []).

:- http_handler(root(fornecedores),fornecedores, []).
:- http_handler(root(planodeContas),planodeContas, []).
:- http_handler('/receptor', recebe_form_fornecedores(Method), 
                            [method(Method),methods([post]) ]).
:- http_handler('/receptor2', recebe_form_planodeContas(Method), 
                            [method(Method),methods([post]) ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tratadores

home(_Pedido) :-
    reply_html_page(
        bootstrap,
        [ title('Primeiro Trabalho')],
        [ div(class(container),
              [ h1('CONTROLE FINANCEIRO DE UMA MICROEMPRESA'),
                nav(class(['nav', 'flex-column']),
                    [ \link_fornecedor,
                      \link_planosConta])
              ]) ]).


fornecedores(_Pedido) :-
    reply_html_page(
            bootstrap,
            [ title('Cadastro Fornecedores')],
              form([class(container),action='/receptor', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Insira os dados para cadastro de fornecedor'),
                    \campo(id_fornecedores,'Id de Fornecedor',number),
                    \campo(razao_social,'Razao Social',text),
                    \campo(identificacao,'Identificacaoo',text),
                    \campo(classificacao,'Classificacaoo',text),
                    \campo(tipo_pessoa,'Tipo Pessoa',text),
                    \campo(cnpjcpf,'CNPJ OU CPF',text),
                    \campo(inscricao_estadual,'Inscricao Estadual',text),
                    \campo(inscricao_municipal,'Inscricao municipal',text),
                    \campo(endereco,'Endereco',text),
                    \campo(bairro,'Bairro',text),
                    \campo(municipio,'Municipio',text),
                    \campo(cep,'CEP',text),
                    \campo(uf,'UF',text),
                    \campo(telefone,'Telefone',text),
                    \campo(email,'E-mail',text),
                    \campo(nome_titular,'Nome titular',text),
                    \campo(cpf,'CPF',text),
                    \campo(funcao,'Funcao',text),

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar Fornecedor')),
                    \retorna_home  ])).

planodeContas(_Pedido) :-
    reply_html_page(
            bootstrap,
            [ title('Cadastro')],
            [ div(class(container),
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Insira os dados do plano de Conta'),
                    \campo(id_planodecontas,'Id do Plano',number),
                    \campo(id_contas_bancarias,'Id Contas Bancarias',number),
                    \campo(classificacao,'Classificacao',text),
                    \campo(tipo_conta,'Tipo da Conta',text),
                    \campo(descricao,'Descricao',text),

                    form([
                    \checkBox(caixa,'Caixa',checkbox),
                    \checkBox(banco,'Banco',checkbox),
                    \checkBox(cliente,'Cliente',checkbox),
                    \checkBox(fornecedor,'Fornecedor',checkbox),
                    \checkBox(entrada_recurso,'Entrada de Recurso',checkbox),
                    \checkBox(saida_recurso,'Saida de Recurso',checkbox)
                    ]),

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% htmls campos formulários

campo(Chave,Nome,Tipo) -->
    html(div(class('mb-3'),
    [label([for(Chave), class('form-label')],Nome),
        input([type(Tipo),class('form-control'),
            id(Chave), name(Nome)])])).


checkBox(Chave,Nome,Tipo) -->
    html(div(class('mb-3'),[
        input([type(Tipo),id(Chave),name(Chave), value(Nome)]),
        label(for=(Chave), Nome)])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recebimento dos Formulários

recebe_form_fornecedores(post, Pedido) :-
    catch(
        http_parameters(Pedido, [id_fornecedores(Id_fornec,   [nonneg]),
                                 razao_social(Razao,   [string]),
                                 identificacao(Ident,  [string]),
                                 classificacao(Class,  [string]),
                                 tipo_pessoa(Tipo,     [string]),
                                 cnpjcpf(CPFCNPJ,      [string]),
                                 inscricao_estadual(Insc_Estad, [string]),
                                 inscricao_municipal(Insc_Munic,[string]),
                                 endereco(Ende,        [string]),
                                 bairro(Bairro,        [string]),
                                 municipio(Munic,      [string]),
                                 cep(Cep,              [string]),
                                 uf(Uf,                [string]),
                                 telefone(Tel,         [string]),
                                 email(Email,          [string]),
                                 nome_titular(Titular, [string]),
                                 cpf(CPF,              [string]),
                                 funcao(Func,          [string])
                                ]),
            _E, 
            fail ),
        !,
        fornecedores:insere(Id_fornec, Razao, Ident, Class,
                            Tipo, CPFCNPJ, Insc_Estad, Insc_Munic,
                            Ende, Bairro, Munic, Cep, Uf, Tel,
                            Email, Titular, CPF, Func),
    reply_html_page(bootstrap, [title('Demonstração de POST')],
    [ p('Pedido Recebido.'), \retorna_home]).


recebe_form_planodeContas(post, Pedido) :-
    catch(
        http_parameters(Pedido, [id_planodecontas(Id_plano,       [nonneg]),
                                 id_contas_bancarias(Id_contas ,  [nonneg]),
                                 classificacao(Class ,            [string]),
                                 tipo_conta(Tip ,                 [string]),
                                 descricao(Descr ,                [string]),
                                 caixa(Caixa,                     [optional(true)]),
                                 banco(Banco ,                    [optional(true)]),
                                 cliente(Cliente ,                [optional(true)]),
                                 fornecedor(Fornec ,              [optional(true)]),
                                 entrada_recurso(En_Recurs ,      [optional(true)]),
                                 saida_recurso(Sa_Recurso ,       [optional(true)])
                                ]),
            _E, fail),
        !,
        (var(Caixa) -> Caixa = false; true),
        (var(Banco) -> Banco = false; true),
        (var(Cliente) -> Cliente = false; true),
        (var(Fornec) -> Fornec = false; true),
        (var(En_Recurs) -> En_Recurs = false; true),
        (var(Sa_Recurso) -> Sa_Recurso = false; true),
    
    planodeContas:insere(Id_plano, Id_contas, Class, Tip,
                         Descr, Caixa, Banco, Cliente, 
                         Fornec, En_Recurs, Sa_Recurso),
    reply_html_page(bootstrap, [title('Demonstração de POST')],
    [ p('Pedido Recebido.'),
      p('Caixa foi ~w'- Caixa),
      \retorna_home
    ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Links

link_fornecedor -->
    html(a([class(['nav-link']), href('/fornecedores')], 'Fornecedores')).

link_planosConta -->
    html(a([class(['nav-link']), href('/planodeContas')], 'Planos de Conta')).

retorna_home -->
    html(div(class(row),
            a([class(['btn','btn-primary']), href('/')],'Voltar para o inicio'))).