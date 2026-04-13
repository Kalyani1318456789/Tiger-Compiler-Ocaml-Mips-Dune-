
(* The type of tokens. *)

type token = 
  | TO
  | SEMI
  | RPAREN
  | PRINT
  | PLUS
  | MUL
  | MINUS
  | LPAREN
  | INT of (int)
  | ID of (string)
  | FOR
  | EQUAL
  | EOF
  | DONE
  | DO
  | DIV
  | ASSIGN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt list)
