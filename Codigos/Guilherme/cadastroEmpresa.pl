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
                funcao:atom               
                ).

:- initialization(db_attach('tbl_cadastroEmpresa.pl', [])).

insere( IdEmpresas, RazaoSocial, 
        Identificacao, TipoPessoa, 
        Cnpj, InscricaoEstadual,
        InscricaoMunicipal, Endereco, 
        Bairro, Municipio, 
        Cep, Uf, 
        Telefone, Email, 
        NomeTitular, Cpf,
        Funcao):-
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
/*S
remove(Usuario_id):-
    with_mutex(dependentes,
               retract_dependentes(Usuario_id, _Id_dependente, 
                                    _Dep_nome, _Dep_email, 
                                    _Dep_data_nascimento, _Dep_sexo,
                                    _Dep_cpf, _Dep_endereco, 
                                    _Usu_cep, _Dep_bairro, 
                                    _Dep_cidade, _Id_estado, 
                                    _Dep_telefone, _Dep_login, 
                                    _Dep_senha, _Dep_primeiro_acesso)).

atualiza(Usuario_id, Id_dependente, 
        Dep_nome, _Dep_email, 
        Dep_data_nascimento, Dep_sexo,
        Dep_cpf, Dep_endereco, 
        Usu_cep, Dep_bairro, 
        Dep_cidade, Id_estado, 
        Dep_telefone, Dep_login, 
        Dep_senha, Dep_primeiro_acesso):-
    with_mutex(dependentes,
               ( retractall_dependentes(Usuario_id, _Id_dependente, 
                                        _Dep_nome, _Dep_email, 
                                        _Dep_data_nascimento, _Dep_sexo,
                                        _Dep_cpf, _Dep_endereco, 
                                        _Usu_cep, _Dep_bairro, 
                                        _Dep_cidade, _Id_estado, 
                                        _Dep_telefone, _Dep_login, 
                                        _Dep_senha, _Dep_primeiro_acesso),
                 assert_dependentes(Usuario_id, Id_dependente, 
                                    Dep_nome, Dep_email, 
                                    Dep_data_nascimento, Dep_sexo,
                                    Dep_cpf, Dep_endereco, 
                                    Usu_cep, Dep_bairro, 
                                    Dep_cidade, Id_estado, 
                                    Dep_telefone, Dep_login, 
                                    Dep_senha, Dep_primeiro_acesso)) ).
*/
sincroniza :-
    db_sync(gc(always)).