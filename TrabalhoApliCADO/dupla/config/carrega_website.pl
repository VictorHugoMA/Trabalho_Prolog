% Configuração do servidor


% Carrega o servidor e as rotas

:- load_files([ servidor,
                rotas
              ],
              [ silent(true),
                if(not_loaded) ]).

% Inicializa o servidor para ouvir a porta 8000
:- initialization( servidor(9000) ).


% Carrega o frontend

:- load_files([ gabarito(bootstrap5),  % gabarito usando Bootstrap 5
                gabarito(boot5rest),   % Bootstrap 5 com API REST
                frontend(login),
                frontend(entrada),
                frontend(usuarios),
                frontend(clientes),
                frontend(tesouraria),
                frontend(formapagamento),
                frontend(contabancaria),
                frontend(empresa),
                frontend(planodeContas),
                frontend(fornecedores)
              ],
              [ silent(true),
                if(not_loaded) ]).


% Carrega o backend

:- load_files([ api1(api_usuarios),
                api1(api_clientes),
                api1(api_tesouraria),
                api1(api_formapagamento),
                api1(api_contabancaria),
                api1(api_empresa),
                api1(api_fornecedores),
                api1(api_planodeContas) % API REST
              ],
              [ silent(true),
                if(not_loaded),
                imports([]) ]).
