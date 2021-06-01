:- module(
       tabTesouraria,
       [tabTesouraria/11, insere/11]
   ).

:- use_module(library(persistency)).

:- persistent
   tabTesouraria(id_tesouraria:nonneg,
                id_empresa:nonneg,
                id_cliente:nonneg,
                id_planoContas:nonneg,
                id_fornecedores:nonneg,
                formapagamento_tes:atom,
                valor_tes:atom,
                numero_tes:atom,
                data_emissao_tes:atom,
                data_venc_tes:atom,
                data_disp_tes:atom).

:- initialization(db_attach('C:/UFU_repositorio/ProLog/Trabalho/tbl_tesouraria.pl', [])).

insere(  Id_tesouraria, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
         Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
         Data_venc_tes, Data_disp_tes):-
    with_mutex(tabTesouraria,
               assert_tabTesouraria(Id_tesouraria, Id_empresa, Id_cliente, Id_planoContas, Id_fornecedores,
                                    Formapagamento_tes, Valor_tes, Numero_tes, Data_emissao_tes,
                                    Data_venc_tes, Data_disp_tes)).
/*
remove(Id_formapagamento):-
    with_mutex(tabFormaPag,
               retract_tabFormaPag(Id_formapagamento,_)).

atualiza(Id_formapagamento, Descr_formapagento):-
    with_mutex(tabFormaPag,
               (  retractall_tabFormaPag(Id_formapagamento,_),
                  assert_tabFormaPag(Id_formapagamento, Descr_formapagento))).
*/
sincroniza:-
    db_sync(gc(always)).