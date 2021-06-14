:- module(
       clientes,
       [  carrega_tab/1,
         clientes/18,
            insere/18,
            remove/1,
            atualiza/18 ]
   ).
   
:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   clientes( idClientes:nonneg,
                razaoSocial:string,
                identificacao:string,
                classificacao:string,
                tipoPessoa:string,
                cnpjCpf:string,
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
                funcao:string               
                ).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao):-
    chave:pk(idClientes,IdClientes),
    with_mutex(clientes,
               assert_clientes(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)).

remove(IdClientes):-
    with_mutex(clientes,
               retract_clientes(IdClientes,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)).

atualiza(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao):-
    with_mutex(clientes,
               ( retract_clientes(IdClientes,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_),
                 assert_clientes(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)) ).
