:-module(api_empresa,[empresa/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).

:- use_module(bd(empresa), []).

/*
   GET api/v1/empresa
   Retorna uma lista com todos os empresa.
*/
empresa(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/empresa/Id
   Retorna o 'empresa' com Id 1 ou erro 404 caso o 'empresa' não
   seja encontrado.
*/
empresa(get, AtomId, _Pedido):-
    atom_number(AtomId, Idempresas),
    !,
    envia_tupla(Idempresas).

/*
   POST api/v1/empresa
   Adiciona um novo empresa. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
empresa(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/empresa/Idempresas
  Atualiza o empresa com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
empresa(put, AtomId, Pedido):-
    atom_number(AtomId, Idempresas),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Idempresas).

/*
   DELETE api/v1/empresa/Id
   Apaga o empresa com o Id informado
*/
empresa(delete, AtomId, _Pedido):-
    atom_number(AtomId, Idempresas),
    !,
    empresa:remove(Idempresas),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de metodo não
   permitido será retornada.
 */

empresa(Metodo, Idempresas, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, Idempresas))).

insere_tupla( _{ razaosocial:Razaosocial,identificacao:Identificacao,
                    tipopessoa:Tipopessoa,cnpj:Cnpj,inscricaoestadual:Inscricaoestadual,
                    inscricaomunicipal:Inscricaomunicipal,endereco:Endereco,bairro:Bairro,
                    municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,
                    email:Email,nometitular:Nometitular,cpf:Cpf, funcao:Funcao}):-
    % Validar URL antes de inserir
    empresa:insere(Idempresas,Razaosocial, 
                    Identificacao,Tipopessoa, 
                    Cnpj,Inscricaoestadual,
                    Inscricaomunicipal,Endereco, 
                    Bairro,Municipio, 
                    Cep,Uf, 
                    Telefone,Email, 
                    Nometitular,Cpf,
                    Funcao)
    -> envia_tupla(Idempresas)
    ;  throw(http_reply(bad_request('URL ausente'))).


atualiza_tupla( _{ razaosocial:Razaosocial,identificacao:Identificacao,
                    tipopessoa:Tipopessoa,cnpj:Cnpj,inscricaoestadual:Inscricaoestadual,
                    inscricaomunicipal:Inscricaomunicipal,endereco:Endereco,bairro:Bairro,
                    municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,
                    email:Email,nometitular:Nometitular,cpf:Cpf, funcao:Funcao}, Idempresas):-
            empresa:atualiza(Idempresas,Razaosocial, 
                    Identificacao,Tipopessoa, 
                    Cnpj,Inscricaoestadual,
                    Inscricaomunicipal,Endereco, 
                    Bairro,Municipio, 
                    Cep,Uf, 
                    Telefone,Email, 
                    Nometitular,Cpf,
                    Funcao)
    -> envia_tupla(Idempresas)
    ;  throw(http_reply(not_found(Idempresas))).


envia_tupla(Idempresas):-
       empresa:empresa(Idempresas,Razaosocial, 
                        Identificacao,Tipopessoa, 
                        Cnpj,Inscricaoestadual,
                        Inscricaomunicipal,Endereco, 
                        Bairro,Municipio, 
                        Cep,Uf, 
                        Telefone,Email, 
                        Nometitular,Cpf,
                        Funcao)
    -> reply_json_dict( _{idempresas:Idempresas,razaosocial:Razaosocial,identificacao:Identificacao,
                    tipopessoa:Tipopessoa,cnpj:Cnpj,inscricaoestadual:Inscricaoestadual,
                    inscricaomunicipal:Inscricaomunicipal,endereco:Endereco,bairro:Bairro,
                    municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,
                    email:Email,nometitular:Nometitular,cpf:Cpf, funcao:Funcao} )
    ;  throw(http_reply(not_found(Idempresas))).


envia_tabela :-
    findall( _{idempresas:Idempresas,razaosocial:Razaosocial,identificacao:Identificacao,
                    tipopessoa:Tipopessoa,cnpj:Cnpj,inscricaoestadual:Inscricaoestadual,
                    inscricaomunicipal:Inscricaomunicipal,endereco:Endereco,bairro:Bairro,
                    municipio:Municipio,cep:Cep,uf:Uf,telefone:Telefone,
                    email:Email,nometitular:Nometitular,cpf:Cpf,funcao:Funcao},
             empresa:empresa(Idempresas,Razaosocial, 
                        Identificacao,Tipopessoa, 
                        Cnpj,Inscricaoestadual,
                        Inscricaomunicipal,Endereco, 
                        Bairro,Municipio, 
                        Cep,Uf, 
                        Telefone,Email, 
                        Nometitular,Cpf,
                        Funcao),
            Tuplas ),
    reply_json_dict(Tuplas).