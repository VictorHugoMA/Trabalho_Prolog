/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

usuarios(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro Usuario')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para cadastro'),
                \form_usuarios
              ]) ]).

form_usuarios -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/usuarios/') ],
              [ \metodo_de_envio('POST'),
                    \campo(usuario,'Usuario:',text),
                    \campo(nome,'Nome:',text),
                    \campo(senha,'Senha:',text),
                    \campo(confirmaSenha,'Corfirmar Senha:',text),
                \enviar_ou_cancelar('/')
              ])).


