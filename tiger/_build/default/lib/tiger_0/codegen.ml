module IR = Ir
module MipsInst = Mips.Inst
module MipsReg = Mips.Reg
module Temp = Temp

let registers = [
  MipsReg.T0; MipsReg.T1; MipsReg.T2; MipsReg.T3;
  MipsReg.T4; MipsReg.T5; MipsReg.T6; MipsReg.T7;
  MipsReg.T8; MipsReg.T9;
  MipsReg.S0; MipsReg.S1; MipsReg.S2; MipsReg.S3;
  MipsReg.S4; MipsReg.S5; MipsReg.S6; MipsReg.S7
]

let temp_to_reg = Hashtbl.create 32
let reg_index = ref 0

let get_reg t =
  match Hashtbl.find_opt temp_to_reg t with
  | Some r -> r
  | None ->
      if !reg_index >= List.length registers then
        failwith "Error: MIPS register pool exhausted"
      else
        let r = List.nth registers !reg_index in
        reg_index := !reg_index + 1;
        Hashtbl.add temp_to_reg t r;
        r

let codegen_instr instr =
  match instr with
  | IR.LoadImm (t, v) ->
      let r = get_reg t in
      [MipsInst.Li (r, v)]

  | IR.Op (dst, op, t1, t2) ->
      let r_dst = get_reg dst in
      let r1 = get_reg t1 in
      let r2 = get_reg t2 in
      begin match op with
      | IR.Plus  -> [MipsInst.Add (r_dst, r1, r2)]
      | IR.Minus -> [MipsInst.Sub (r_dst, r1, r2)]
      | IR.Times -> [MipsInst.Mul (r_dst, r1, r2)]
      | IR.Div   -> failwith "Division not supported"
      end

  | IR.Print t ->
      let r = get_reg t in
      [
        MipsInst.Move (MipsReg.A0, r);
        MipsInst.Li (MipsReg.V0, 1);
        MipsInst.Syscall
      ]

  | IR.Label l ->
      [MipsInst.Label (Temp.Temp.labelToString l)]

  | IR.Goto l ->
      [MipsInst.J (Temp.Temp.labelToString l)]

  | IR.IfGreater (t1, t2, l) ->
      let r1 = get_reg t1 in
      let r2 = get_reg t2 in
      let tmp = MipsReg.T9 in
      [
        MipsInst.Slt (tmp, r2, r1);
        MipsInst.Bne (tmp, MipsReg.Zero, Temp.Temp.labelToString l)
      ]

let codegen ir_prog =
  Hashtbl.clear temp_to_reg;
  reg_index := 0;
  
  let main_label = [MipsInst.Label "main"] in
  let program_code = List.flatten (List.map codegen_instr ir_prog) in
  let exit_code = [
    MipsInst.Li (MipsReg.V0, 10);  (* exit syscall *)
    MipsInst.Syscall
  ] in
  
  main_label @ program_code @ exit_code
