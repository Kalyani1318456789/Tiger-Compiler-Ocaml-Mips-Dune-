%{
open Ast
%}

%token <int> INT
%token <string> ID

%token PLUS MINUS MUL DIV
%token ASSIGN      (* := *)
%token EQUAL       (* =  *)
%token SEMI

%token LPAREN RPAREN

%token PRINT
%token FOR TO DO DONE

%token EOF

%left PLUS MINUS
%left MUL DIV

%start program
%type <Ast.stmt list> program

%%

program:
  stmt_seq EOF { $1 }

(* clean, non-ambiguous sequence *)
stmt_seq:
  | stmt { [$1] }
  | stmt SEMI stmt_seq { $1 :: $3 }
  | stmt SEMI { [$1] }   (* allows trailing ; *)

stmt:
  | ID ASSIGN expr
      { Assign ($1, $3) }

  | PRINT expr
      { Print $2 }

  | FOR ID EQUAL INT TO INT DO stmt_seq DONE
      { For ($2, $4, $6, $8) }

expr:
  | INT
      { Const $1 }

  | ID
      { Var $1 }

  | LPAREN expr RPAREN
      { $2 }

  | expr PLUS expr
      { Op ($1, Add, $3) }

  | expr MINUS expr
      { Op ($1, Sub, $3) }

  | expr MUL expr
      { Op ($1, Mul, $3) }

  | expr DIV expr
      { Op ($1, Div, $3) }
