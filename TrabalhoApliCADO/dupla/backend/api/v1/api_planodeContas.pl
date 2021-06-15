:-module(api_planodeContas,[planodeContas/3]).

/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(planodeContas), []).

/*
   GET api/v1/planodeContas/
   Retorna uma lista com todos os planodeContas.
*/
planodeContas(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/planodeContas/IdPlano
   Retorna o `planodeContas` com IdPlano 1 ou erro 404 caso o `planodeContas` não
   seja encontrado.
*/
planodeContas(get, AtomId, _Pedido):-
    atom_number(AtomId, IdPlano),
    !,
    envia_tupla(IdPlano).

/*
   POST api/v1/planodeContas
   Adiciona um novo planodeContas. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
planodeContas(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/planodeContas/IdPlano
  Atualiza o planodeContas com o IdPlano informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
planodeContas(put, AtomId, Pedido):-
    atom_number(AtomId, IdPlano),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, IdPlano).

/*
   DELETE api/v1/planodeContas/IdPlano
   Apaga o planodeContas com o IdPlano informado
*/
planodeContas(delete, AtomId, _Pedido):-
    atom_number(AtomId, IdPlano),
    !,
    planodeContas:remove(IdPlano),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.
 */

planodeContas(Metodo, IdPlano, _Pedido) :-
    throw(http_reply(method_not_allowed(Método, IdPlano))).


insere_tupla( _{id_ContasBancarias: Id_ContasBancarias,
                classificacao: Classificacao, tipoConta: TipoConta, 
                descricao: Descricao, caixa: Caixa, banco: Banco, 
                cliente: Cliente, fornecedor: Fornecedor, 
                entradaRecurso: EntradaRecurso, saidaRecurso: SaidaRecurso}):-
    % Validar URL antes de inserir
    planodeContas:insere(IdPlano, Id_ContasBancarias, Classificacao,
                         TipoConta, Descricao, Caixa,
                         Banco, Cliente, Fornecedor,
                         EntradaRecurso, SaidaRecurso)
    -> envia_tupla(IdPlano)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla( _{ id_ContasBancarias: Id_ContasBancarias,
                classificacao: Classificacao, tipoConta: TipoConta, 
                descricao: Descricao, caixa: Caixa, banco: Banco, 
                cliente: Cliente, fornecedor: Fornecedor, 
                entradaRecurso: EntradaRecurso, saidaRecurso: SaidaRecurso}, IdPlano):-
       planodeContas:atualiza(IdPlano, Id_ContasBancarias, Classificacao,
                                TipoConta, Descricao, Caixa,
                                Banco, Cliente, Fornecedor,
                                EntradaRecurso, SaidaRecurso)
    -> envia_tupla(IdPlano)
    ;  throw(http_reply(not_found(IdPlano))).


envia_tupla(IdPlano):-
       planodeContas:planodeContas(IdPlano, Id_ContasBancarias, Classificacao,
                                    TipoConta, Descricao, Caixa,
                                    Banco, Cliente, Fornecedor,
                                    EntradaRecurso, SaidaRecurso)
    -> reply_json_dict( _{id_planodeContas: IdPlano, id_ContasBancarias: Id_ContasBancarias,
                          classificacao: Classificacao, tipoConta: TipoConta, 
                          descricao: Descricao, caixa: Caixa, banco: Banco, 
                          cliente: Cliente, fornecedor: Fornecedor, 
                          entradaRecurso: EntradaRecurso, saidaRecurso: SaidaRecurso} )
    ;  throw(http_reply(not_found(IdPlano))).


envia_tabela :-
    findall( _{ id_planodeContas: IdPlano, id_ContasBancarias: Id_ContasBancarias,
                classificacao: Classificacao, tipoConta: TipoConta, 
                descricao: Descricao, caixa: Caixa, banco: Banco, 
                cliente: Cliente, fornecedor: Fornecedor, 
                entradaRecurso: EntradaRecurso, saidaRecurso: SaidaRecurso},
             planodeContas:planodeContas(IdPlano, Id_ContasBancarias, Classificacao,
                                         TipoConta, Descricao, Caixa,
                                         Banco, Cliente, Fornecedor,
                                         EntradaRecurso, SaidaRecurso),
             Tuplas ),
    reply_json_dict(Tuplas).%envia JSON para o solicitante