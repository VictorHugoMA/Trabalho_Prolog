/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

contabancaria(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro Conta Bancaria')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para cadastro'),
                \form_contabancaria
              ]) ]).

form_contabancaria -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/contabancaria/') ],
              [ \metodo_de_envio('POST'),
                  \campo(classificacao,'Descricao',text),
                  \campo(numeroConta,'Numero da Conta',text),
                  \campo(numeroAgencia,'Numero da Agencia',text),
                  \campo(dataSaldoinicial,'Data Incial:',date),
                \enviar_ou_cancelar('/')
              ])).


