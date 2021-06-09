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
:- use_module(usuarios,[]).
:- use_module(clientes,[]).
:- use_module(chave, []).

servidor(Porta) :-
http_server(http_dispatch, [port(Porta)]).

/* Liga a rota ao tratador */
:- http_handler(root(.), home , []).
:- http_handler(root(tesouraria), tesouraria , []).
:- http_handler(root(formapagamento), formapagamento , []).
:- http_handler(root(usuarios), usuarios , []).
:- http_handler(root(clientes), clientes , []).

/* Localização dos diretórios no sistema de arquivos */
:- multifile user:file_search_path/2.

/*
Alterar diretorio para cada um 


user:file_search_path(dir_css, 'C:/Trabalho_Prolog/Trabalho_Prolog/Codigos/Geral/css').
user:file_search_path(dir_js, 'C:/Trabalho_Prolog/Trabalho_Prolog/Codigos/Geral/js').
*/
user:file_search_path(dir_css,'C:/Users/User/OneDrive/Documentos/UFU/Prolog/Repositorio github/Trabalho_Prolog/Codigos/Geral/css').
user:file_search_path(dir_js,'C:/Users/User/OneDrive/Documentos/UFU/Prolog/Repositorio github/Trabalho_Prolog/Codigos/Geral/js').


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
                [   \link_usuario(1),
                    \link_cliente(1),
                    \link_tesouraria(1),
                    \link_formapagamento(1)])
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

link_tesouraria(1) -->
    html(a([ class(['nav-link']),
        href('/tesouraria')],
        'Tesouraria')).
link_formapagamento(1) -->
    html(a([ class(['nav-link']),
        href('/formapagamento')],
        'Forma de Pagamento')).

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