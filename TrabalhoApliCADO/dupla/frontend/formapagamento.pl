/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(bootstrap5)).

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