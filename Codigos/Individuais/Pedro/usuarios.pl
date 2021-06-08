:- module(
       usuarios,
       [ usuarios/5,
            insere/5]
   ).

:- use_module(library(persistency)).
:- persistent
   usuarios( idusuarios:nonneg,
                    usuario:atom,
                    nome:atom,
                    senha:atom,
                    confirmaSenha:atom).

:- initialization(db_attach('tbl_usuarios.pl', [])).


insere(Iduser,User,Nome,Senha,Confirmasenha):-
    with_mutex(usuarios,
               assert_usuarios(Iduser,User,Nome,Senha,Confirmasenha)).

/* remove(Iduser):-
    with_mutex(chaveUsuario,
               retract_chaveUsuario(Iduser,User,Nome,Senha,Confirmasenha)).

atualiza((Iduser,User,Nome,Senha,Confirmasenha)):-
    with_mutex(chaveUsuario,
               ( retractall_chaveUsuario(Iduser,User,Nome,Senha,Confirmasenha),
                 assert_chaveUsuario(Iduser,User,Nome,Senha,Confirmasenha)) ).
 */
sincroniza :-
    db_sync(gc(always)).