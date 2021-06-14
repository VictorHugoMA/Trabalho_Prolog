/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(cadastroEmpresa), []).

/*
   GET api/v1/cadastroEmpresa/
   Retorna uma lista com todos os cadastroEmpresa.
*/
cadastroEmpresa(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/cadastroEmpresa/Id
   Retorna o 'cadastroEmpresa' com Id 1 ou erro 404 caso o 'cadastroEmpresa' não
   seja encontrado.
*/
cadastroEmpresa(get, Id, _Pedido):-
    _number(Id, Id),
    !,
    envia_tupla(Id).

/*
   POST api/v1/cadastroEmpresa
   Adiciona um novo cadastroEmpresa. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
cadastroEmpresa(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/cadastroEmpresa/Id
  Atualiza o cadastroEmpresa com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
cadastroEmpresa(put, Id, Pedido):-
    _number(Id, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).

/*
   DELETE api/v1/cadastroEmpresa/Id
   Apaga o cadastroEmpresa com o Id informado
*/
cadastroEmpresa(delete, Id, _Pedido):-
    _number(Id, Id),
    !,
    cadastroEmpresa:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de Metodo não
   permitido será retornada.
 */

cadastroEmpresa(Metodo, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Id))).


insere_tupla( _{ id_Empresas:IdEmpresas, id_razaoSocial:RazaoSocial, 
                id_identificacao:Identificacao, id_tipoPessoa:TipoPessoa,
                id_cnpj:Cnpj, id_inscricaoEstadual:InscricaoEstadual, 
                id_inscricaoMunicipal:InscricaoMunicipal,
                id_endereco:Endereco, id_bairro:Bairro, 
                id_municipio:Municipio,id_cep:Cep, 
                id_uf:Uf, id_telefone:Telefone,
                id_email:Email, id_nomeTitular:NomeTitular, 
                id_cpf:Cpf, id_funcao:Funcao}, Id):-
    % Validar URL antes de inserir
    cadastroEmpresa:insere( Id, IdEmpresas, RazaoSocial, 
                            Identificacao, TipoPessoa, 
                            Cnpj, InscricaoEstadual,
                            InscricaoMunicipal, Endereco, 
                            Bairro, Municipio, 
                            Cep, Uf, 
                            Telefone, Email, 
                            NomeTitular, Cpf,
                            Funcao)
    -> envia_tupla(Id).
    

atualiza_tupla( _{ id_Empresas:IdEmpresas, id_razaoSocial:RazaoSocial, 
                    id_identificacao:Identificacao, id_tipoPessoa:TipoPessoa,
                    id_cnpj:Cnpj, id_inscricaoEstadual:InscricaoEstadual, 
                    id_inscricaoMunicipal:InscricaoMunicipal,
                    id_endereco:Endereco, id_bairro:Bairro, 
                    id_municipio:Municipio,id_cep:Cep, 
                    id_uf:Uf, id_telefone:Telefone,
                    id_email:Email, id_nomeTitular:NomeTitular, 
                    id_cpf:Cpf, id_funcao:Funcao}, Id):-
       cadastroEmpresa:atualiza(Id, IdEmpresas, RazaoSocial, 
                                    Identificacao, TipoPessoa, 
                                    Cnpj, InscricaoEstadual,
                                    InscricaoMunicipal, Endereco, 
                                    Bairro, Municipio, 
                                    Cep, Uf, 
                                    Telefone, Email, 
                                    NomeTitular, Cpf,
                                    Funcao)
    -> envia_tupla(Id)
    ;  throw(http_reply(not_found(Id))).


envia_tupla(Id):-
       cadastroEmpresa:cadastroEmpresa(Id, IdEmpresas, RazaoSocial, 
                                        Identificacao, TipoPessoa, 
                                        Cnpj, InscricaoEstadual,
                                        InscricaoMunicipal, Endereco, 
                                        Bairro, Municipio, 
                                        Cep, Uf, 
                                        Telefone, Email, 
                                        NomeTitular, Cpf,
                                        Funcao)
    -> reply_json_dict( _{id:Id, id_Empresas:IdEmpresas, id_razaoSocial:RazaoSocial, 
                                id_identificacao:Identificacao, id_tipoPessoa:TipoPessoa,
                                id_cnpj:Cnpj, id_inscricaoEstadual:InscricaoEstadual, 
                                id_inscricaoMunicipal:InscricaoMunicipal,
                                id_endereco:Endereco, id_bairro:Bairro, 
                                id_municipio:Municipio,id_cep:Cep, 
                                id_uf:Uf, id_telefone:Telefone,
                                id_email:Email, id_nomeTitular:NomeTitular, 
                                id_cpf:Cpf, id_funcao:Funcao} )
    ;  throw(http_reply(not_found(Id))).


envia_tabela :-
    findall( _{id:Id, id_Empresas:IdEmpresas, id_razaoSocial:RazaoSocial, 
                                id_identificacao:Identificacao, id_tipoPessoa:TipoPessoa,
                                id_cnpj:Cnpj, id_inscricaoEstadual:InscricaoEstadual, 
                                id_inscricaoMunicipal:InscricaoMunicipal,
                                id_endereco:Endereco, id_bairro:Bairro, 
                                id_municipio:Municipio,id_cep:Cep, 
                                id_uf:Uf, id_telefone:Telefone,
                                id_email:Email, id_nomeTitular:NomeTitular, 
                                id_cpf:Cpf, id_funcao:Funcao},
             cadastroEmpresa:cadastroEmpresa(Id,IdEmpresas, RazaoSocial, 
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
