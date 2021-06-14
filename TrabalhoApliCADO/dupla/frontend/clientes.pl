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
                onsubmit("redirecionaResposta( event, '/' )"),
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
                \enviar_ou_cancelar('/')
              ])).

/* -------------------------------
clientes(_Pedido) :-
    reply_html_page(
            boot5rest,
            [ \html_requires(js('bookmark.js')),
                title('Cadastro Cliente')],
              form([ class(container),action='/receptor2', method='POST'],
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Insira os dados para cadastro'),
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
          

                    p(button([class('btn btn-primary'), type(submit)],'Cadastrar')),
                    \retorna_home  ])).

:- http_handler('/receptor2', recebe_formulario_clientes(Method),
            [ method(Method),
                methods([post]) ]).

recebe_formulario_clientes(post, Pedido) :-
        catch(
            http_parameters(Pedido,[
                                    razaoSocial(RazaoSocial,[]), 
                                    identificacao(Identificacao,[]), 
                                    classificacao(Classificacao,[]), 
                                    tipoPessoa(TipoPessoa,[]),
                                    cnpjCpf(CnpjCpf,[]),
                                    inscricaoEstadual(InscricaoEstadual,[]),
                                    inscricaoMunicipal(InscricaoMunicipal,[]),
                                    endereco(Endereco,[]),
                                    bairro(Bairro,[]),
                                    municipio(Municipio,[]),
                                    cep(Cep,[]),
                                    uf(Uf,[]),                                
                                    telefone(Telefone,[]),                                  
                                    email(Email,[]),                                  
                                    nomeTitular(NomeTitular,[]),                                  
                                    cpf(Cpf,[]),                                  
                                    funcao(Funcao,[])                                  
                                    
                                    ]),
            _E,
            fail),
        !,
        clientes:insere(_,RazaoSocial,Identificacao,Classificacao,
                        TipoPessoa,CnpjCpf,InscricaoEstadual,
                        InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,
                        Telefone,Email,NomeTitular,Cpf,Funcao),
        reply_html_page(
            bootstrap,
            [ title('Cadastro Realizado')],
            [ div(class(container),
                [ h1('Pedido Recebido.'),
                    \retorna_home
                        ])
            ]). */
