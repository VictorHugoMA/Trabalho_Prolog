:- use_module(library(persistency)).

:- persistent
   tabTesouraria(id_tesouraria:nonneg,
                id_empresa:nonneg,
                id_cliente:nonneg,
                id_planoContas:nonneg,
                id_fornecedores:nonneg,
                formapagamento_tes:string,
                valor_tes:string,
                numero_tes:string,
                data_emissao_tes:date,
                data_venc_tes:date,
                data_disp_tes:date).