/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(cadastroEmpresa), []).

/*
   GET api/v1/cadastroEmpresa
   Retorna uma lista com todos os cadastroEmpresa.
*/
cadastroEmpresa(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/cadastroContaBancaria/Id
   Retorna o 'cadastroContaBancaria' com Id 1 ou erro 404 caso o 'cadastroContaBancaria' não
   seja encontrado.
*/
cadastroEmpresa(get, AtomId, _Pedido):-
    atom_number(AtomId, IdEmpresas),
    !,
    envia_tupla(IdEmpresas).

/*
   POST api/v1/cadastroContaBancaria
   Adiciona um novo cadastroContaBancaria. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
cadastroEmpresa(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/cadastroContaBancaria/Id
  Atualiza o cadastroContaBancaria com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
cadastroEmpresa(put, AtomId, Pedido):-
    atom_number(AtomId, IdEmpresas),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdEmpresas).

/*
   DELETE api/v1/cadastroContaBancaria/Id
   Apaga o cadastroContaBancaria com o Id informado
*/
cadastroEmpresa(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdEmpresas),
    !,
    cadastroEmpresa
:remove(IdEmpresas),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

cadastroEmpresa(Metodo, IdEmpresas, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdEmpresas))).


insere_tupla6( _{ id_Empresas:IdEmpresas, id_razaoSocial:RazaoSocial, 
                id_identificacao:Identificacao, id_tipoPessoa:TipoPessoa,
                id_cnpj:Cnpj, id_inscricaoEstadual:InscricaoEstadual, 
                id_inscricaoMunicipal:InscricaoMunicipal,
                id_endereco:Endereco, id_bairro:Bairro, 
                id_municipio:Municipio,id_cep:Cep, 
                id_uf:Uf, id_telefone:Telefone,
                id_email:Email, id_nomeTitular:NomeTitular, 
                id_cpf:Cpf, id_funcao:Funcao}, IdEmpresas}):-
    % Validar URL antes de inserir
    cadastroEmpresa
:insere( IdEmpresas, RazaoSocial, 
        Identificacao, TipoPessoa, 
        Cnpj, InscricaoEstadual,
        InscricaoMunicipal, Endereco, 
        Bairro, Municipio, 
        Cep, Uf, 
        Telefone, Email, 
        NomeTitular, Cpf,
        Funcao)
    -> envia_tupla(IdEmpresas)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla6( _{ id_Empresas:IdEmpresas, id_razaoSocial:RazaoSocial, 
                id_identificacao:Identificacao, id_tipoPessoa:TipoPessoa,
                id_cnpj:Cnpj, id_inscricaoEstadual:InscricaoEstadual, 
                id_inscricaoMunicipal:InscricaoMunicipal,
                id_endereco:Endereco, id_bairro:Bairro, 
                id_municipio:Municipio,id_cep:Cep, 
                id_uf:Uf, id_telefone:Telefone,
                id_email:Email, id_nomeTitular:NomeTitular, 
                id_cpf:Cpf, id_funcao:Funcao}, IdEmpresas)
    -> envia_tupla(IdEmpresas)
    ;  throw(http_reply(not_found(IdEmpresas))).


envia_tupla6(IdEmpresas):-
       cadastroEmpresa
    :cadastroEmpresa
    (IdEmpresas, RazaoSocial, 
        Identificacao, TipoPessoa, 
        Cnpj, InscricaoEstadual,
        InscricaoMunicipal, Endereco, 
        Bairro, Municipio, 
        Cep, Uf, 
        Telefone, Email, 
        NomeTitular, Cpf,
        Funcao)
    -> reply_json_dict( _{id_Empresas:IdEmpresas, id_razaoSocial:RazaoSocial, 
                id_identificacao:Identificacao, id_tipoPessoa:TipoPessoa,
                id_cnpj:Cnpj, id_inscricaoEstadual:InscricaoEstadual, 
                id_inscricaoMunicipal:InscricaoMunicipal,
                id_endereco:Endereco, id_bairro:Bairro, 
                id_municipio:Municipio,id_cep:Cep, 
                id_uf:Uf, id_telefone:Telefone,
                id_email:Email, id_nomeTitular:NomeTitular, 
                id_cpf:Cpf, id_funcao:Funcao} )
    ;  throw(http_reply(not_found(IdEmpresas))).


envia_tabela6 :-
    findall( _{id_Empresas:IdEmpresas, id_razaoSocial:RazaoSocial, 
                id_identificacao:Identificacao, id_tipoPessoa:TipoPessoa,
                id_cnpj:Cnpj, id_inscricaoEstadual:InscricaoEstadual, 
                id_inscricaoMunicipal:InscricaoMunicipal,
                id_endereco:Endereco, id_bairro:Bairro, 
                id_municipio:Municipio,id_cep:Cep, 
                id_uf:Uf, id_telefone:Telefone,
                id_email:Email, id_nomeTitular:NomeTitular, 
                id_cpf:Cpf, id_funcao:Funcao},
             cadastroEmpresa
            :cadastroEmpresa
            (IdEmpresas, RazaoSocial, 
            Identificacao, TipoPessoa, 
            Cnpj, InscricaoEstadual,
            InscricaoMunicipal, Endereco, 
            Bairro, Municipio, 
            Cep, Uf, 
            Telefone, Email, 
            NomeTitular, Cpf,
            Funcao),
            Tuplas ),
    reply_json_dict(Tuplas).