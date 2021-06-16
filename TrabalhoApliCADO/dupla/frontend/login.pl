/* :- module(
       login,
       [ login/1 ]).
 */
/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

/* :- use_module(bd(bookmark), []).
 */
:- use_module(bd(usuarios), []).



login(_Pedido) :-
    reply_html_page(
        boot5rest,
        [ title('Login')],
        [ div(class(container),
            [ h1('Login'),
                nav(class(['nav','flex-column']),
                    [   \form_login,
                        \link_usuario(1)

                    ])
                ])
        ]).

form_login -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/entrada') ],
              [     
                    \campo(usuario,'Usuario:',text),
                    \campo(senha,'Senha:',password),
                \enviar('/')
              ])).

/* 
campo(Nome,Rotulo,Tipo) -->
    html(div(class('mb-3'),
    [label([for=Nome, class('form-label')],Rotulo),
        input([name=Nome,type=Tipo,class('form-control'),id=Nome])])).
 */
link_usuario(1) -->
    html(a([ class(['nav-link']),
            href('/usuarios')],
        'Cadastro Usuario')).



enviar(_) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar')],
             button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar')
            )).


/* metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_metodo'), value(Metodo)])).
 */