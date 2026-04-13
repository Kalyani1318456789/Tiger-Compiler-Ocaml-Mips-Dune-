{
open Parser
}

rule token = parse
  | [' ' '\t' '\r' '\n'] { token lexbuf }

  | ":=" { ASSIGN }
  | "="  { EQUAL }
  | ";"  { SEMI }

  | "+" { PLUS }
  | "-" { MINUS }
  | "*" { MUL }
  | "/" { DIV }

  | "(" { LPAREN }
  | ")" { RPAREN }

  | "print" { PRINT }
  | "for"   { FOR }
  | "to"    { TO }
  | "do"    { DO }
  | "done"  { DONE }

  | ['0'-'9']+ as num
      { INT (int_of_string num) }

  | ['a'-'z' 'A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9']* as id
      { ID id }

  | eof { EOF }

  | _ { failwith "Unexpected character" }
