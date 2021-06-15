/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap5)).

formapagamento(_Pedido):-
    reply_html_page(
            boot5rest,
            [ title('Cadastro Forma de Pagamento')],
            [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para cadastro'),
                \form_formapagamento
              ]) ]).

form_formapagamento -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/formapagamento/') ],
              [ \metodo_de_envio('POST'),
                \campo(descrformapagento, 'Descricao', text),
                \enviar_ou_cancelar('/')
              ])).