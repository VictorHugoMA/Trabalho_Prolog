:- module(
        empresa,
        [ carrega_tab/1, empresa/17, insere/17,remove/1,
            atualiza/17 ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   empresa( idempresas:nonneg,
                razaosocial:string,
                identificacao:string,
                tipopessoa:string,
                cnpj:string,
                inscricaoestadual:string,
                inscricaomunicipal:string,
                endereco:string,
                bairro:string,
                municipio:string,
                cep:string,
                uf:string,
                telefone:string,
                email:string,
                nometitular:string,
                cpf:string,
                funcao:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(Idempresas,Razaosocial, 
                    Identificacao,Tipopessoa, 
                    Cnpj,Inscricaoestadual,
                    Inscricaomunicipal,Endereco, 
                    Bairro,Municipio, 
                    Cep,Uf, 
                    Telefone,Email, 
                    Nometitular,Cpf,
                    Funcao):-
    chave:pk(empresa , Idempresas),
    with_mutex(empresa,
                assert_empresa(Idempresas,Razaosocial, 
                    Identificacao,Tipopessoa, 
                    Cnpj,Inscricaoestadual,
                    Inscricaomunicipal,Endereco, 
                    Bairro,Municipio, 
                    Cep,Uf, 
                    Telefone,Email, 
                    Nometitular,Cpf,
                    Funcao)).

remove(Idempresas):-
    with_mutex(empresa,
               retract_empresa(Idempresas,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)).

atualiza(Idempresas,Razaosocial, 
                    Identificacao,Tipopessoa, 
                    Cnpj,Inscricaoestadual,
                    Inscricaomunicipal,Endereco, 
                    Bairro,Municipio, 
                    Cep,Uf, 
                    Telefone,Email, 
                    Nometitular,Cpf,
                    Funcao):-
    with_mutex(empresa,
               ( retractall_empresa(Idempresas,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
                 assert_empresa(Idempresas,Razaosocial, 
                    Identificacao,Tipopessoa, 
                    Cnpj,Inscricaoestadual,
                    Inscricaomunicipal,Endereco, 
                    Bairro,Municipio, 
                    Cep,Uf, 
                    Telefone,Email, 
                    Nometitular,Cpf,
                    Funcao))).
