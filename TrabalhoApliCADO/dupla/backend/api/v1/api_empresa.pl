:-module(api_empresa,[empresa/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(empresa), []).

/*
   GET api/v1/usuarios/
   Retorna uma lista com todos os usuarios.
*/
empresa(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/usuarios/Iduser
   Retorna o `usuarios` com Iduser 1 ou erro 404 caso o `usuarios` não
   seja encontrado.
*/
empresa(get, AtomId, _Pedido):-
    atom_number(AtomId, IdEmpresa),
    !,
    envia_tupla(IdEmpresa).

/*
   POST api/v1/usuarios
   Adiciona um novo usuarios. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
empresa(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/usuarios/Iduser
  Atualiza o usuarios com o Iduser informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
empresa(put, AtomId, Pedido):-
    atom_number(AtomId, IdEmpresa),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdEmpresa).

/*
   DELETE api/v1/usuarios/Iduser
   Apaga o usuarios com o Iduser informado
*/
empresa(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdEmpresa),
    !,
    empresa:remove(IdEmpresa),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

empresa(Metodo, IdEmpresa, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdEmpresa))).


insere_tupla( _{ razaoSocial:RazaoSocial,identificacao:Identificacao,tipoPessoa:TipoPessoa,cnpj:Cnpj,inscricaoEstadual:InscricaoEstadual,inscricaoMunicipal:InscricaoMunicipal,endereco:Endereco,bairro:Bairro,municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,email:Email,nomeTitular:NomeTitular,cpf:Cpf,funcao:Funcao}):-
    % Validar URL antes de inserir
    empresa:insere(IdEmpresa,RazaoSocial,Identificacao,TipoPessoa,Cnpj,InscricaoEstadual,InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)
    -> envia_tupla(IdEmpresa)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ razaoSocial:RazaoSocial,identificacao:Identificacao,tipoPessoa:TipoPessoa,cnpj:Cnpj,inscricaoEstadual:InscricaoEstadual,inscricaoMunicipal:InscricaoMunicipal,endereco:Endereco,bairro:Bairro,municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,email:Email,nomeTitular:NomeTitular,cpf:Cpf,funcao:Funcao}, IdEmpresa):-
       empresa:atualiza(IdEmpresa,RazaoSocial,Identificacao,TipoPessoa,Cnpj,InscricaoEstadual,InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)
    -> envia_tupla(IdEmpresa)
    ;  throw(http_reply(not_found(IdEmpresa))).


envia_tupla(IdEmpresa):-
       empresa:empresa(IdEmpresa,RazaoSocial,Identificacao,TipoPessoa,Cnpj,InscricaoEstadual,InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao)
    -> reply_json_dict( _{idEmpresa:IdEmpresa,razaoSocial:RazaoSocial,identificacao:Identificacao,tipoPessoa:TipoPessoa,cnpj:Cnpj,inscricaoEstadual:InscricaoEstadual,inscricaoMunicipal:InscricaoMunicipal,endereco:Endereco,bairro:Bairro,municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,email:Email,nomeTitular:NomeTitular,cpf:Cpf,funcao:Funcao} )
    ;  throw(http_reply(not_found(IdEmpresa))).


envia_tabela :-
    findall( _{idEmpresa:IdEmpresa,razaoSocial:RazaoSocial,identificacao:Identificacao,tipoPessoa:TipoPessoa,cnpj:Cnpj,inscricaoEstadual:InscricaoEstadual,inscricaoMunicipal:InscricaoMunicipal,endereco:Endereco,bairro:Bairro,municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,email:Email,nomeTitular:NomeTitular,cpf:Cpf,funcao:Funcao},
             empresa:empresa(IdEmpresa,RazaoSocial,Identificacao,TipoPessoa,Cnpj,InscricaoEstadual,InscricaoMunicipal,Endereco,Bairro,Municipio,Cep,Uf,Telefone,Email,NomeTitular,Cpf,Funcao),
             Tuplas ),
    reply_json_dict(Tuplas).
