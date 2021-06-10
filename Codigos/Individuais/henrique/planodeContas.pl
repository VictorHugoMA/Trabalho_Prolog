 /*Tabela responsável pelo armazenamento dos dados dos planos das Contas.*/
:- module(
       planodeContas,
       [ planodeContas/11, insere/11, remove/1, atualiza/11]).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   planodeContas(id_planodeContas:nonneg,
                 id_ContasBancarias:nonneg,
                 classificacao:string,
                 tipoConta:string,
                 descricao:string,
                 caixa:atom,
                 banco:atom,
                 cliente:atom,
                 fornecedor:atom,
                 entradaRecurso:atom,
                 saidaRecurso:atom).

:- initialization((db_attach('tbl_planodeContas.pl', []), %./backend/bd/
                    at_halt(db_sync(gc(always)))
                 )).

insere( Id_planodeContas, Id_ContasBancarias,
        Classificacao, TipoConta, Descricao,
        Caixa, Banco, Cliente, Fornecedor,
        EntradaRecurso, SaidaRecurso):-
    
    chave:pk(planodeContas, Id_planodeContas),
    with_mutex(planodeContas,
               assert_planodeContas(Id_planodeContas, Id_ContasBancarias,
                                    Classificacao, TipoConta, Descricao,
                                    Caixa, Banco, Cliente, Fornecedor,
                                    EntradaRecurso, SaidaRecurso)).

remove(Id_planodeContas):-
    with_mutex(planodeContas,
               assert_planodeContas(Id_planodeContas, _Id_ContasBancarias,
                                    _Classificacao, _TipoConta, _Descricao,
                                    _Caixa, _Banco, _Cliente, _Fornecedor,
                                    _EntradaRecurso, _SaidaRecurso)).

atualiza(Id_planodeContas, Id_ContasBancarias,
         Classificacao, TipoConta, Descricao,
         Caixa, Banco, Cliente, Fornecedor,
         EntradaRecurso, SaidaRecurso):-
    with_mutex(planodeContas,
               ( retractall_planodeContas(Id_planodeContas, _Id_ContasBancarias,
                                            _Classificacao, _TipoConta, _Descricao,
                                            _Caixa, _Banco, _Cliente, _Fornecedor,
                                            _EntradaRecurso, _SaidaRecurso),
                 assert_planodeContas(Id_planodeContas, Id_ContasBancarias,
                                        Classificacao, TipoConta, Descricao,
                                        Caixa, Banco, Cliente, Fornecedor,
                                        EntradaRecurso, SaidaRecurso)) ).