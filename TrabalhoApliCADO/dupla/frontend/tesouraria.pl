/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


tesouraria(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Tesouraria')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Tesouraria'),
                \form_tesouraria
              ]) ]).

form_tesouraria -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/entrada' )"),
                action('/api/v1/tesouraria/') ],
              [ \metodo_de_envio('POST'),
                    \campo(idempresa, 'ID Empresa', text),
                    \campo(idcliente, 'ID Cliente', text),
                    \campo(idplanoContas, 'ID Plano de Contas', text),
                    \campo(idfornecedores, 'ID Fornecedores', text),
                    \campo(formapagamentotes, 'Formas de Pagamento', text),
                    \campo(valortes, 'Valor', text),
                    \campo(numerotes, 'Numero', text),
                    \campo(dataemissaotes, 'Data de Emissao', date),
                    \campo(datavenctes, 'Data de Vencimento', date),
                    \campo(datadisptes, 'Data de Disponibilidade', date),
                \enviar_ou_cancelar('/entrada')
              ])).


