:- module(
       usuarios,
       [ carrega_tab/1,
          usuarios/5,
            insere/5,
            remove/1,
            atualiza/5]
   ).

:- use_module(library(persistency)).
:- use_module(library(crypto)).
:- use_module(chave,[]).

:- persistent
   usuarios( idusuarios:nonneg,
                    usuario:string,
                    nome:string,
                    senha:atom,
                    confirmaSenha:string).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela,[]).

insere(Iduser,User,Nome,Senha,Confirmasenha):-
    chave:pk(usuario,Iduser),
    with_mutex(usuarios,(crypto_password_hash(Senha,Hash),
               assert_usuarios(Iduser,User,Nome,Hash,Confirmasenha))).

 remove(Iduser):-
    with_mutex(usuarios,
               retract_usuarios(Iduser,_,_,_,_)).

atualiza(Iduser,User,Nome,Senha,Confirmasenha):-
    with_mutex(usuarios,
               ( retractall_usuarios(Iduser,_,_,_,_),
                 assert_usuarios(Iduser,User,Nome,Senha,Confirmasenha)) ).

/*
senha_valida(User, Senha, Iduser, Nome):-
    usuarios(Iduser,User,Nome,Hash,Confirmasenha),
    !,
    crypto_password_hash(Senha,Hash).
*/