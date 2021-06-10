%Pagina ex 2

:- module(
        cadastroContaBancaria,
        [ cadastroContaBancaria/5, insere/5]
).

:- use_module(library(persistency)).
:- persistent
   cadastroContaBancaria( idContaBancarias:nonneg,
                          classificacao:atom,
                          numeroConta:nonneg,
                          numeroAgencia:nonneg,
                          dataSaldoinicial:atom).

:- initialization(db_attach('tbl_cadastroContaBancaria.pl', [])).

insere( IdContaBancarias, Classificacao,
        NumeroConta, NumeroAgencia,     
        DataSaldoInicial):-
    with_mutex(cadastroContaBancaria,
               assert_cadastroContaBancaria(IdContaBancarias, Classificacao,
                                  NumeroConta, NumeroAgencia,
                                  DataSaldoInicial)).

/*
remove(Usuario_id):-
    with_mutex(cadastroContaBancaria,
               retract_cadastroContaBancaria(IdContaBancarias, Classificacao,
                                  NumeroConta, NumeroAgencia,
                                  DataSaldoInicial)).

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