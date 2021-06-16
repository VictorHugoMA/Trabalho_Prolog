/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

clientes(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro Cliente')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para cadastro'),
                \form_clientes
              ]) ]).

form_clientes -->
    html(form([ id('bookmark-form'),
                onsubmit("redirecionaResposta( event, '/entrada' )"),
                action('/api/v1/clientes/') ],
              [ \metodo_de_envio('POST'),
                    \campo(razaoSocial,'Razao Social:',text),
                    \campo(identificacao,'Identificacao:',text),
                    \campo(classificacao,'Classificacao:',text),
                    \campo(tipoPessoa,'Tipo Pessoa(Fisica/Juridica):',text),
                    \campo(cnpjCpf,'Cnpj/CPF:',text),
                    \campo(inscricaoEstadual,'Inscricao Estadual:',text),
                    \campo(inscricaoMunicipal,'Inscricao Municipal:',text),
                    \campo(endereco,'Endereco:',text),
                    \campo(bairro,'Bairro:',text),
                    \campo(municipio,'Municipio:',text),
                    \campo(cep,'CEP:',text),
                    \campo(uf,'Sigla Estado:',text),
                    \campo(telefone,'Telefone:',text),
                    \campo(email,'E-mail:',text),
                    \campo(nomeTitular,'Titular:',text),
                    \campo(cpf,'CPF do Titular:',text),
                    \campo(funcao,'Funcao:',text),
                \enviar_ou_cancelar('/entrada')
              ])).

