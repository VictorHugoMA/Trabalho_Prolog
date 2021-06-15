/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

planodeContas(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro plano de Contas')],
        [ div(class(container),
              [ \html_requires(js('bookmark.js')),
                h1('Insira os dados para cadastro'),
                \form_planodeContas
              ]) ]).

form_planodeContas -->
    html(form([ id('planodeContas-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/planodeContas/') ],
              [ \metodo_de_envio('POST'),
                    \campo(id_ContasBancarias,'Id contas Bancarias:',text),
                    \campo(classificacao,'Classificacao:',text),
                    \campo(tipoConta,'Tipo Conta(poupanca/corrente):',text),
                    \campo(descricao,'Cnpj/CPF:',text),
                    \campo(caixa,'Caixa:',text),
                    \campo(banco,'Banco:',text),
                    \campo(cliente,'Cliente:',text),
                    \campo(fornecedor,'Fornecedor:',text),
                    \campo(entradaRecurso,'Valor de entrada:',text),
                    \campo(saidaRecurso,'Valor de saque:',text),
                \enviar_ou_cancelar('/')
              ])).

