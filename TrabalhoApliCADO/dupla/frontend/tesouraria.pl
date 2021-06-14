/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).



tesouraria(_Pedido):-
    reply_html_page(
            boot5rest,
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