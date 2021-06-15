:- module(
        empresa,
        [ carrega_tab/1, empresa/17, insere/17,remove/1,
            atualiza/17 ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   empresa( idEmpresa:nonneg,
                razaoSocial:string,
                identificacao:string,
                tipoPessoa:string,
                cnpj:string,
                inscricaoEstadual:string,
                inscricaoMunicipal:string,
                endereco:string,
                bairro:string,
                municipio:string,
                cep:string,
                uf:string,
                telefone:string,
                email:string,
                nomeTitular:string,
                cpf:string,
                funcao:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(IdEmpresa,RazaoSocial,Identificacao,TipoPessoa,Cnpj,InscricaoEstadual,InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao):-
    chave:pk(empresa , IdEmpresa),
    with_mutex(empresa,
                assert_empresa(IdEmpresa,RazaoSocial,Identificacao,TipoPessoa,Cnpj,InscricaoEstadual,InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)).

remove(IdEmpresa):-
    with_mutex(empresa,
               retract_empresa(IdEmpresa,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)).

atualiza(IdEmpresa,RazaoSocial,Identificacao,TipoPessoa,Cnpj,InscricaoEstadual,InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao):-
    with_mutex(empresa,
               ( retractall_empresa(IdEmpresa,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
                 assert_empresa(IdEmpresa,RazaoSocial,Identificacao,TipoPessoa,Cnpj,InscricaoEstadual,InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao))).
