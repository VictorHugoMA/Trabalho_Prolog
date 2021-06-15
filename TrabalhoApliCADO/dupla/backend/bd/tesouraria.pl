:- module(
       tabTesouraria,
       [carrega_tab/1, tabTesouraria/11, insere/11, remove/1, atualiza/11]
   ).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   tabTesouraria(id_tesouraria:nonneg,
                id_empresa:nonneg,
                id_cliente:nonneg,
                id_planoContas:nonneg,
                id_fornecedores:nonneg,
                formapagamento_tes:string,
                valor_tes:string,
                numero_tes:string,
                data_emissao_tes:string,
                data_venc_tes:string,
                data_disp_tes:string).
                
:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(  Id_tesouraria, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
         Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
         Data_venc_tes, Data_disp_tes):-
    chave:pk(tesouraria, Id_tesouraria),
    with_mutex(tabTesouraria,
               assert_tabTesouraria(Id_tesouraria, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
                                    Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
                                    Data_venc_tes, Data_disp_tes)).

remove(Id_tesouraria):-
    with_mutex(tabTesouraria,
               retract_tabTesouraria(Id_tesouraria,_, _, _, _, _, _, _, _, _, _)).

atualiza(Id_tesouraria, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
         Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
         Data_venc_tes, Data_disp_tes):-
    with_mutex(tabTesouraria,
               (  retractall_tabTesouraria(Id_tesouraria,_, _, _, _, _, _, _, _, _, _),
               
                  assert_tabTesouraria( Id_tesouraria, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
                                        Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
                                        Data_venc_tes, Data_disp_tes))).