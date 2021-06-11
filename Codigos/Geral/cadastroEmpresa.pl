%Pagina ex 1

:- module(
        cadastroEmpresa,
        [ cadastroEmpresa/17, insere/17]
).

:- use_module(library(persistency)).
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

:- initialization( ( db_attach('C:/Users/User/OneDrive/Documentos/UFU/Prolog/Trabalho/tbl_cadastroEmpresa.pl', []),
                     at_halt(db_sync(gc(always))) )).

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

sincroniza :-
    db_sync(gc(always)).