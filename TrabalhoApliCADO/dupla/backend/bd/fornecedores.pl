 /*Tabela responsável pelo armazenamento de dados dos fornecedores*/
:- module(
       fornecedores,
       [ fornecedores/17, insere/17, remove/1, atualiza/17]).

:- use_module(library(persistency)).
:- use_module(chave, []).

:- persistent
   fornecedores(id_fornecedores:integer,
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
                uf:string,
                telefone:string,
                email:string,
                nomeTitular:string,
                cpf:string,
                funcao:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere( Id_fornecedores, RazaoSocial,
        Identificacao, Classificacao,
        TipoPessoa, CnpjCpf, InscricaoEstadual,
        InscricaoMunicipal, Endereco,
        Bairro, Municipio, Uf, Telefone,
        Email, NomeTitular, Cpf, Funcao):-
    
    chave:pk(fornecedores, Id_fornecedores),
    with_mutex(fornecedores,
               assert_fornecedores( Id_fornecedores, RazaoSocial,
                                    Identificacao, Classificacao,
                                    TipoPessoa, CnpjCpf, InscricaoEstadual,
                                    InscricaoMunicipal, Endereco,
                                    Bairro, Municipio, Uf, Telefone,
                                    Email, NomeTitular, Cpf, Funcao)).

remove(Id_fornecedores):-
    with_mutex(fornecedores,
               retract_fornecedores(Id_fornecedores, _RazaoSocial,
                                    _Identificacao, _Classificacao,
                                    _TipoPessoa, _CnpjCpf, _InscricaoEstadual,
                                    _InscricaoMunicipal, _Endereco,
                                    _Bairro, _Municipio, _Uf, _Telefone,
                                    _Email, _NomeTitular, _Cpf, _Funcao)).

atualiza(Id_fornecedores, RazaoSocial,
         Identificacao, Classificacao,
         TipoPessoa, CnpjCpf, InscricaoEstadual,
         InscricaoMunicipal, Endereco,
         Bairro, Municipio, Uf, Telefone,
         Email, NomeTitular, Cpf, Funcao):-
    with_mutex(fornecedores,
               ( retractall_fornecedores(Id_fornecedores, _RazaoSocial,
                                         _Identificacao, _Classificacao,
                                         _TipoPessoa, _CnpjCpf, _InscricaoEstadual,
                                         _InscricaoMunicipal, _Endereco,
                                         _Bairro, _Municipio, _Uf, _Telefone,
                                         _Email, _NomeTitular, _Cpf, _Funcao),
                 assert_fornecedores(Id_fornecedores, RazaoSocial,
                                     Identificacao, Classificacao,
                                     TipoPessoa, CnpjCpf, InscricaoEstadual,
                                     InscricaoMunicipal, Endereco,
                                     Bairro, Municipio, Uf, Telefone,
                                     Email, NomeTitular, Cpf, Funcao)) ).