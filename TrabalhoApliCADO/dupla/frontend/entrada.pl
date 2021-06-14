/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap5)).

/* :- use_module(bd(bookmark), []).
 */
:- use_module(bd(usuarios), []).
:- use_module(bd(clientes), []).
:- use_module(bd(tesouraria), []).
:- use_module(bd(formapagamento), []).


entrada(_Pedido) :-
    reply_html_page(
        bootstrap5,
        [ title('CONTROLE FINANCEIRO DE UMA MICROEMPRESA')],
        [ div(class(container),
            [ h1('SISTEMAS DE INFORMACAO PARA CONTROLE FINANCEIRO DE UMA MICROEMPRESA VIA WEB'),
                nav(class(['nav','flex-column']),
                    [ \link_usuario(1) ,
                        \link_cliente(1),
                        \link_tesouraria(1),
                        \link_formapagamento(1)
                          ])
                ])
        ]).

retorna_home -->
    html(div(class(row),
            a([ class(['btn','btn-primary']), href('/')],
                'Voltar para o inicio'))).


campo(Nome,Rotulo,Tipo) -->
    html(div(class('mb-3'),
    [label([for=Nome, class('form-label')],Rotulo),
        input([name=Nome,type=Tipo,class('form-control'),id=Nome])])).

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
        'Cadastro Tesouraria')).
        
link_formapagamento(1) -->
    html(a([ class(['nav-link']),
        href('/formapagamento')],
        'Cadastro Forma de Pagamento')).


/* tesouraria(_Pedido):-
    reply_html_page(
            bootstrap5,
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
            bootstrap5,
            [ title('Formas de Pagamentos')],
              form([ class(container),action='/receptorFor', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Formas de Pagamentos'),
                    \campo(descr_formapagento, 'Descricao', text),
          

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])).

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
            ]). */