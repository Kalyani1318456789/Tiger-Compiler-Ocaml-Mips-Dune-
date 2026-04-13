open Temp

(* Binary operations *)
type binop =
  | Plus
  | Minus
  | Times
  | Div


(* IR instructions *)
type t =
  | LoadImm of Temp.temp * int
  | Op of Temp.temp * binop * Temp.temp * Temp.temp
  | Print of Temp.temp

  (* For control flow (for loops) *)
  | Label of Temp.label
  | Goto of Temp.label
  | IfGreater of Temp.temp * Temp.temp * Temp.label


(* A program is just a list of instructions *)
type program = t list
