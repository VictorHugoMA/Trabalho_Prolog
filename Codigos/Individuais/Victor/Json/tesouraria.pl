/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(tesouraria), []).

/*
   GET api/v1/tesouraria/
   Retorna uma lista com todos os tesouraria.
*/
tesouraria(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/tesouraria/Id
   Retorna o `tesouraria` com Id 1 ou erro 404 caso o `tesouraria` não
   seja encontrado.
*/
tesouraria(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

/*
   POST api/v1/tesouraria
   Adiciona um novo tesouraria. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
tesouraria(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/tesouraria/Id
  Atualiza o tesouraria com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
tesouraria(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).

/*
   DELETE api/v1/tesouraria/Id
   Apaga o tesouraria com o Id informado
*/
tesouraria(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    tabTesouraria:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.
 */

tesouraria(Método, Id, _Pedido) :-
    throw(http_reply(method_not_allowed(Método, Id))).


insere_tupla( _{    id_empresa: Id_empresa, id_cliente: Id_cliente,
                    id_planoContas :Id_planoContas, id_fornecedores:Id_fornecedores,
                    formapagamento_tes:Formapagamento_tes, valor_tes:Valor_tes, numero_tes:Numero_tes, data_emissao_tes:Data_emissao_tes,
                    data_venc_tes:Data_venc_tes, data_disp_tes:Data_disp_tes}):-
    % Validar URL antes de inserir
    tabTesouraria:insere(   Id, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
                            Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
                            Data_venc_tes, Data_disp_tes)
    -> envia_tupla(Id).



atualiza_tupla( _{  id_empresa: Id_empresa, id_cliente: Id_cliente,
                    id_planoContas :Id_planoContas, id_fornecedores:Id_fornecedores,
                    formapagamento_tes:Formapagamento_tes, valor_tes:Valor_tes, numero_tes:Numero_tes, data_emissao_tes:Data_emissao_tes,
                    data_venc_tes:Data_venc_tes, data_disp_tes:Data_disp_tes}, Id):-
       tabTesouraria:atualiza(  Id, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
                                Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
                                Data_venc_tes, Data_disp_tes)
    -> envia_tupla(Id)
    ;  throw(http_reply(not_found(Id))).




envia_tupla(Id):-
       tabTesouraria:tabTesouraria( Id, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
                                    Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
                                    Data_venc_tes, Data_disp_tes)
    -> reply_json_dict( _{  id:Id, id_empresa: Id_empresa, id_cliente: Id_cliente,
                            id_planoContas :Id_planoContas, id_fornecedores:Id_fornecedores,
                            formapagamento_tes:Formapagamento_tes, valor_tes:Valor_tes, numero_tes:Numero_tes, data_emissao_tes:Data_emissao_tes,
                            data_venc_tes:Data_venc_tes, data_disp_tes:Data_disp_tes} )
    ;  throw(http_reply(not_found(Id))).


envia_tabela :-
    findall( _{ id:Id, id_empresa: Id_empresa, id_cliente: Id_cliente,
                id_planoContas :Id_planoContas, id_fornecedores:Id_fornecedores,
                formapagamento_tes:Formapagamento_tes, valor_tes:Valor_tes, numero_tes:Numero_tes, data_emissao_tes:Data_emissao_tes,
                data_venc_tes:Data_venc_tes, data_disp_tes:Data_disp_tes},
             tabTesouraria:tabTesouraria(   Id,Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
                                            Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
                                            Data_venc_tes, Data_disp_tes),
             Tuplas ),
    reply_json_dict(Tuplas).