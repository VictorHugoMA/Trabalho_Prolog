 /*Tabela responsável pelo armazenamento dos dados dos plano das Contas.*/
:- module(
       planodeContas,
       [ carrega_tab/1, planodeContas/11, insere/11, remove/1, atualiza/11]).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
   planodeContas(id_planodeContas:integer,
                 id_ContasBancarias:integer,
                 classificacao:string,
                 tipoConta:string,
                 descricao:string,
                 caixa:string,
                 banco:string,
                 cliente:string,
                 fornecedor:string,
                 entradaRecurso:string,
                 saidaRecurso:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[])

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