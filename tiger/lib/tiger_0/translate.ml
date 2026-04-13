module IR = Ir
module Ast = Ast
module Temp = Temp

(* translate_expression :
   Ast.expr -> env -> (temp * instruction list)
*)
let rec translate_expression e env =
  match e with
  | Ast.Const v ->
      let t = Temp.Temp.newtemp () in
      (t, [IR.LoadImm (t, v)])

  | Ast.Var name ->
      (match Hashtbl.find_opt env name with
       | Some t -> (t, [])
       | None -> failwith ("Undefined variable: " ^ name))

  | Ast.Op (left_exp, op_type, right_exp) ->
      let (l_temp, l_instrs) = translate_expression left_exp env in
      let (r_temp, r_instrs) = translate_expression right_exp env in

      let opcode =
        match op_type with
        | Ast.Add -> IR.Plus
        | Ast.Sub -> IR.Minus
        | Ast.Mul -> IR.Times
        | Ast.Div -> IR.Div
      in

      let result_temp = Temp.Temp.newtemp () in
      let op_instr = IR.Op (result_temp, opcode, l_temp, r_temp) in

      (result_temp, l_instrs @ r_instrs @ [op_instr])


(* translate_statement *)
let rec translate_statement env instrs stmt =
  match stmt with

  | Ast.Assign (var_name, expr) ->
      let (src_temp, new_instrs) = translate_expression expr env in
      Hashtbl.replace env var_name src_temp;
      instrs @ new_instrs

  | Ast.Print expr ->
      let (value_temp, new_instrs) = translate_expression expr env in
      instrs @ new_instrs @ [IR.Print value_temp]

  | Ast.For (ident, start, stop, body) ->

      let t = Temp.Temp.newtemp () in
      let t_stop = Temp.Temp.newtemp () in
      let one = Temp.Temp.newtemp () in

      let l_start = Temp.Temp.newlabel () in
      let l_end = Temp.Temp.newlabel () in

      (* Save old binding (for scoping) *)
      let old_binding = Hashtbl.find_opt env ident in

      (* Bind loop variable *)
      Hashtbl.replace env ident t;

      (* Generate body instructions *)
      let body_instrs =
        List.fold_left (translate_statement env) [] body
      in

      (* Restore old binding after loop *)
      (match old_binding with
       | Some v -> Hashtbl.replace env ident v
       | None -> Hashtbl.remove env ident);

      instrs
      @ [
          IR.LoadImm (t, start);
          IR.LoadImm (t_stop, stop);

          IR.Label l_start;

          IR.IfGreater (t, t_stop, l_end);
        ]
      @ body_instrs
      @ [
          IR.LoadImm (one, 1);
          IR.Op (t, IR.Plus, t, one);

          IR.Goto l_start;
          IR.Label l_end;
        ]


(* trans : Ast.program -> IR.program *)
let trans program_ast =
  let env = Hashtbl.create 16 in
  List.fold_left (translate_statement env) [] program_ast
