 %Pagina ex 1
usuarios(_Pedido) :-
    reply_html_page(
            bootstrap,
            [ title('Cadastro')],
            [ div(class(container),
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Insira os dados para cadastro'),
                    \campo(idusuarios,'Id de Usuario:',number),
                    \campo(usuario,'Usuario:',text),
                    \campo(nome,'Nome:',text),
                    \campo(senha,'Senha:',text),
                    \campo(confirmaSenha,'Corfirme a senha:',text),


                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])]).


