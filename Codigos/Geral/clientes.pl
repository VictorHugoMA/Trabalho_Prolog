:- module(
       clientes,
       [ clientes/18,
            insere/18 ]
   ).
   
:- use_module(library(persistency)).
:- persistent
   clientes( idClientes:nonneg,
                razaoSocial:atom,
                identificacao:atom,
                classificacao:atom,
                tipoPessoa:atom,
                cnpjCpf:atom,
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

:- initialization(db_attach('tbl_cliente.pl', [])).


insere(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao):-
    with_mutex(clientes,
               assert_clientes(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)).

/* remove(Iduser):-
    with_mutex(chaveUsuario,
               retract_chaveUsuario(Iduser,User,Nome,Senha,Confirmasenha)).

atualiza((Iduser,User,Nome,Senha,Confirmasenha)):-
    with_mutex(chaveUsuario,
               ( retractall_chaveUsuario(Iduser,User,Nome,Senha,Confirmasenha),
                 assert_chaveUsuario(Iduser,User,Nome,Senha,Confirmasenha)) ).
 */
sincroniza :-
    db_sync(gc(always)).