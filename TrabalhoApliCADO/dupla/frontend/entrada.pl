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
:- use_module(bd(cadastroContaBancaria), []).
:- use_module(bd(cadastroEmpresa), []).


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
                        \link_formapagamento(1),
                        \link_contabancaria(1),
                        \link_empresa(1)
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

link_contabancaria(1) -->
    html(a([ class(['nav-link']),
        href('/cadastroContaBancaria')],
        'Cadastro Conta Bancaria')).

link_empresa(1) -->
    html(a([ class(['nav-link']),
        href('/cadastroEmpresa')],
        'Cadastro Empresa')).


enviar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_metodo'), value(Metodo)])).
