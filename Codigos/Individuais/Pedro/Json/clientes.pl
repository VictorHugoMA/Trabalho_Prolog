/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(clientes), []).

/*
   GET api/v1/clientes/
   Retorna uma lista com todos os clientes.
*/
clientes(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/clientes/Id
   Retorna o `clientes` com Id 1 ou erro 404 caso o `clientes` não
   seja encontrado.
*/
clientes(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

/*
   POST api/v1/clientes
   Adiciona um novo clientes. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
clientes(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/clientes/Id
  Atualiza o clientes com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
clientes(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).

/*
   DELETE api/v1/clientes/Id
   Apaga o clientes com o Id informado
*/
clientes(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    tabFormaPag:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

clientes(Metodo, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id))).

insere_tupla( _{ razaoSocial:RazaoSocial,identificacao:Identificacao,classificacao:Classificacao,tipoPessoa:TipoPessoa,cnpjCpf:CnpjCpf,inscricaoEstadual:InscricaoEstadual,
         inscricaoMunicipal:InscricaoMunicipal,endereco:Endereco,bairro:Bairro,municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,email:Email,nomeTitular:NomeTitular,cpf:Cpf,funcao:Funcao}):-
    % Validar URL antes de inserir
    clientes:insere(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)
    -> envia_tupla(IdClientes)
    ).

atualiza_tupla( _{ razaoSocial:RazaoSocial,identificacao:Identificacao,classificacao:Classificacao,tipoPessoa:TipoPessoa,cnpjCpf:CnpjCpf,inscricaoEstadual:InscricaoEstadual,
         inscricaoMunicipal:InscricaoMunicipal,endereco:Endereco,bairro:Bairro,municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,email:Email,nomeTitular:NomeTitular,cpf:Cpf,funcao:Funcao}, Id):-
       clientes:atualiza(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)
    -> envia_tupla(IdClientes)
    ;  throw(http_reply(not_found(IdClientes))).


envia_tupla(IdClientes):-
       clientes:clientes(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)
    -> reply_json_dict( _{idClientes:IdClientes,razaoSocial:RazaoSocial,identificacao:Identificacao,classificacao:Classificacao,tipoPessoa:TipoPessoa,cnpjCpf:CnpjCpf,inscricaoEstadual:InscricaoEstadual,
         inscricaoMunicipal:InscricaoMunicipal,endereco:Endereco,bairro:Bairro,municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,email:Email,nomeTitular:NomeTitular,cpf:Cpf,funcao:Funcao} )
    ;  throw(http_reply(not_found(IdClientes))).


envia_tabela :-
    findall( _{idClientes:IdClientes,razaoSocial:RazaoSocial,identificacao:Identificacao,classificacao:Classificacao,tipoPessoa:TipoPessoa,cnpjCpf:CnpjCpf,inscricaoEstadual:InscricaoEstadual,
         inscricaoMunicipal:InscricaoMunicipal,endereco:Endereco,bairro:Bairro,municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,email:Email,nomeTitular:NomeTitular,cpf:Cpf,funcao:Funcao},
             clientes:clientes(IdClientes,RazaoSocial,Identificacao,Classificacao,TipoPessoa,CnpjCpf,InscricaoEstadual,
         InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao),
             Tuplas ),
    reply_json_dict(Tuplas).