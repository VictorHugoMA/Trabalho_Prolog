formapagamento(_Pedido):-
    reply_html_page( 
    bootstrap,
    [ title('Formas de Pagamentos')],
    [ div(class(container),
        [ \html_requires(css('estilo.css')),
            h2(class("my-5 text-center"),
                'Formas de Pagamento'),
            \campo(id_formapagamento, 'ID Forma de Pagamento', number),
            \campo(descr_formapagento, 'Descricao', text),
    
            p(button([ class('btn btn-primary'), type(submit)], 'Enviar')),
            \retorna_home ])]).