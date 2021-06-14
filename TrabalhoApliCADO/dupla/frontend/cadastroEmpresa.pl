/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

empresa(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro Empresa')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para cadastro'),
                \form_empresa
              ]) ]).

form_empresa -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/cadastroEmpresa/') ],
              [ \metodo_de_envio('POST'),
                    \campo(razaoSocial,'Razao Social:',text),
                    \campo(identificacao,'Identificacao:',text),
                    \campo(tipoPessoa,'Tipo pessoa:',text),
                    \campo(cnpj,'CNPJ',atom),
                    \campo(inscricaoEstadual,'Inscricao Estadual:',text),
                    \campo(incricaoMunicipal,'inscricao Municipal:',text),
                    \campo(endereco,'Endereco:',text),
                    \campo(bairro,'Bairro:',text),
                    \campo(municipio,'Municipio:',text),
                    \campo(cep,'CEP:',atom),
                    \campo(uf,'Uf',text),
                    \campo(telefone,'telefone:',atom),
                    \campo(email,'E-mail:',text),
                    \campo(nomeTitular,'Nome',text),
                    \campo(cpf,'CPF',atom),
                    \campo(funcao,'Funcao',text),
                \enviar_ou_cancelar('/')
              ])).


