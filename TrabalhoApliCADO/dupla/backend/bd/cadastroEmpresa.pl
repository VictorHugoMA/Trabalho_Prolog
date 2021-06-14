%Pagina ex 1

:- module(
        cadastroEmpresa,
        [ carrega_tab/1, cadastroEmpresa/17, insere/17,remove/1,
            atualiza/17 ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   cadastroEmpresa( idEmpresas:nonneg,
                razaoSocial:atom,
                identificacao:atom,
                tipoPessoa:atom,
                cnpj:atom,
                inscricaoEstadual:atom,
                inscricaoMunicipal:atom,
                endereco:atom,
                bairro:atom,
                municipio:atom,
                cep:atom,
                uf:atom,
                telefone:atom,
                email:atom,
                nomeTitular:atom,
                cpf:atom,
                funcao:atom).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere( IdEmpresas, RazaoSocial, 
        Identificacao, TipoPessoa, 
        Cnpj, InscricaoEstadual,
        InscricaoMunicipal, Endereco, 
        Bairro, Municipio, 
        Cep, Uf, 
        Telefone, Email, 
        NomeTitular, Cpf,
        Funcao):-
    chave:pk(cadastroEmpresa , IdEmpresas),
    with_mutex(cadastroEmpresa,
                assert_cadastroEmpresa(IdEmpresas, RazaoSocial, 
                                        Identificacao, TipoPessoa, 
                                        Cnpj, InscricaoEstadual,
                                        InscricaoMunicipal, Endereco, 
                                        Bairro, Municipio, 
                                        Cep, Uf, 
                                        Telefone, Email, 
                                        NomeTitular, Cpf,
                                        Funcao)).

remove(IdEmpresas):-
    with_mutex(cadastroEmpresa,
               retract_cadastroEmpresa(IdEmpresas, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _)).

atualiza(IdEmpresas, RazaoSocial, 
        Identificacao, TipoPessoa, 
        Cnpj, InscricaoEstadual,
        InscricaoMunicipal, Endereco, 
        Bairro, Municipio, 
        Cep, Uf, 
        Telefone, Email, 
        NomeTitular, Cpf,
        Funcao):-
    with_mutex(cadastroEmpresa,
               ( retractall_cadastroEmpresa(IdEmpresas, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
               
                 assert_cadastroEmpresa(IdEmpresas, RazaoSocial, 
                                        Identificacao, TipoPessoa, 
                                        Cnpj, InscricaoEstadual,
                                        InscricaoMunicipal, Endereco, 
                                        Bairro, Municipio, 
                                        Cep, Uf, 
                                        Telefone, Email, 
                                        NomeTitular, Cpf,
                                        Funcao))).
