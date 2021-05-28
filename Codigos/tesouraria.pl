tesouraria(_Pedido):-
    reply_html_page( 
    bootstrap,
    [ title('Tesouraria')],
    [ div(class(container),
        [ \html_requires(css('estilo.css')),
            h2(class("my-5 text-center"),
                'Tesouraria'),
            \campo(id_tesouraria, 'ID Tesouraria', number),
            \campo(id_empresa, 'ID Empresa', number),
            \campo(id_cliente, 'ID Cliente', number),
            \campo(id_planoContas, 'ID Plano de Contas', number),
            \campo(id_fornecedores, 'ID Fornecedores', number),
            \campo(formapagamento_tes, 'Formas de Pagamento', text),
            \campo(valor_tes, 'Valor', text),
            \campo(numero_tes, 'Numero', text),
            \campo(data_emissao, 'Data de Emissao', date),
            \campo(data_venc, 'Data de Vencimento', date),
            \campo(data_disp, 'Data de Disponibilidade', date),
            
            p(button([ class('btn btn-primary'), type(submit)], 'Enviar')),
            \retorna_home ])]).