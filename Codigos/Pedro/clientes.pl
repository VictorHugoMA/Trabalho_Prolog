 %Pagina ex 1
clientes(_Pedido) :-
    reply_html_page(
            bootstrap,
            [ title('Cadastro Cliente')],
            [ div(class(container),
                [ \html_requires(css('estilo.css')),
                    h2(class("my-5 text-center"),
                        'Insira os dados para cadastro'),
                    \campo(idClientes,'Id do Cliente:',number),
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
                    \retorna_home  ])]).


