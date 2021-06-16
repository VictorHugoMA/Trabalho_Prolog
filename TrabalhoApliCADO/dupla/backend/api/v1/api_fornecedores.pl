:-module(api_fornecedores,[fornecedores/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(fornecedores), []).

/*
   GET api/v1/fornecedores/
   Retorna uma lista com todos os fornecedores.
*/
fornecedores(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/fornecedores/IdFornec
   Retorna o `fornecedores` com IdFornec 1 ou erro 404 caso o `fornecedores` não
   seja encontrado.
*/
fornecedores(get, AtomId, _Pedido):-
    atom_number(AtomId, IdFornec),
    !,
    envia_tupla(IdFornec).

/*
   POST api/v1/fornecedores
   Adiciona um novo fornecedores. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
fornecedores(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/fornecedores/IdFornec
  Atualiza o fornecedores com o IdFornec informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
fornecedores(put, AtomId, Pedido):-
    atom_number(AtomId, IdFornec),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdFornec).

/*
   DELETE api/v1/fornecedores/IdFornec
   Apaga o fornecedores com o IdFornec informado
*/
fornecedores(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdFornec),
    !,
    fornecedores:remove(IdFornec),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.
 */

fornecedores(Metodo, IdFornec, _Pedido) :-
    throw(http_reply(method_not_allowed(Metodo, IdFornec))).


insere_tupla( _{ razaoSocial:RazaoSocial, identificacao:Indentificacao, 
                 classificacao:Classification, tipoPessoa:TipoPessoa, 
                 cnpjCpf:CPFCNPJ, inscricaoEstadual:InscricaoEstad, 
                 inscricaoMunicipal:InscricaoMunic, endereco:Endereco, 
                 bairro:Bairro, municipio:Municipio, 
                 uf:UF, telefone:Telefone, email:Email, 
                 nomeTitular:NmTitular, cpf:CPF, funcao:Func}):-
    % Validar URL antes de inserir
    fornecedores:insere(IdFornec, RazaoSocial, Indentificacao, 
                        Classification, TipoPessoa, 
                        CPFCNPJ, InscricaoEstad, 
                        InscricaoMunic, Endereco, 
                        Bairro, Municipio, 
                        UF, Telefone, Email, 
                        NmTitular, CPF, Func)
    -> envia_tupla(IdFornec)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ razaoSocial:RazaoSocial, identificacao:Indentificacao, 
                   classificacao:Classification, tipoPessoa:TipoPessoa, 
                   cnpjCpf:CPFCNPJ, inscricaoEstadual:InscricaoEstad, 
                   inscricaoMunicipal:InscricaoMunic, endereco:Endereco, 
                   bairro:Bairro, municipio:Municipio, 
                   uf:UF, telefone:Telefone, email:Email, 
                  nomeTitular:NmTitular, cpf:CPF, funcao:Func}, IdFornec):-
       fornecedores:atualiza(IdFornec, RazaoSocial, Indentificacao, 
                             Classification, TipoPessoa, 
                             CPFCNPJ, InscricaoEstad, 
                             InscricaoMunic, Endereco, 
                             Bairro, Municipio, 
                             UF, Telefone, Email, 
                             NmTitular, CPF, Func)
    -> envia_tupla(IdFornec)
    ;  throw(http_reply(not_found(IdFornec))).


envia_tupla(IdFornec):-
       fornecedores:fornecedores(IdFornec, RazaoSocial, Indentificacao, 
                                 Classification, TipoPessoa, 
                                 CPFCNPJ, InscricaoEstad, 
                                 InscricaoMunic, Endereco, 
                                 Bairro, Municipio, 
                                 UF, Telefone, Email, 
                                 NmTitular, CPF, Func)
    -> reply_json_dict( _{id_fornecedores:IdFornec, razaoSocial:RazaoSocial, identificacao:Indentificacao, 
                          classificacao:Classification, tipoPessoa:TipoPessoa, 
                          cnpjCpf:CPFCNPJ, inscricaoEstadual:InscricaoEstad, 
                          inscricaoMunicipal:InscricaoMunic, endereco:Endereco, 
                          bairro:Bairro, municipio:Municipio, 
                          uf:UF, telefone:Telefone, email:Email, 
                          nomeTitular:NmTitular, cpf:CPF, funcao:Func} )
    ;  throw(http_reply(not_found(IdFornec))).


envia_tabela :-
    findall( _{ id_fornecedores:IdFornec,razaoSocial:RazaoSocial, identificacao:Indentificacao, 
                classificacao:Classification, tipoPessoa:TipoPessoa, 
                cnpjCpf:CPFCNPJ, inscricaoEstadual:InscricaoEstad, 
                inscricaoMunicipal:InscricaoMunic, endereco:Endereco, 
                bairro:Bairro, municipio:Municipio, 
                uf:UF, telefone:Telefone, email:Email, 
                nomeTitular:NmTitular, cpf:CPF, funcao:Func},
             fornecedores:fornecedores(IdFornec,RazaoSocial, Indentificacao, 
                                        Classification, TipoPessoa, 
                                        CPFCNPJ, InscricaoEstad, 
                                        InscricaoMunic, Endereco, 
                                        Bairro, Municipio, 
                                        UF, Telefone, Email, 
                                        NmTitular, CPF, Func),
             Tuplas ),
    reply_json_dict(Tuplas).%envia JSON para o solicitante