type binOp = Add | Sub | Mul | Div

type expr = 
    | Const of int
    | Var of string
    | Op of expr * binOp * expr
    

type stmt =
    | Assign of string * expr
    | Print of expr
    | For of string * int * int * stmt list


type program = stmt list
