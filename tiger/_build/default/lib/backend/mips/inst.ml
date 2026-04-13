type ('l, 'r) t = Add  of 'r * 'r * 'r
                | Addi of 'r * 'r * int
                | Sub  of 'r * 'r * 'r
                | Mul  of 'r * 'r * 'r
                | And  of 'r * 'r * 'r
                | Andi of 'r * 'r * int
                | Or   of 'r * 'r * 'r
                | Xor  of 'r * 'r * 'r
                | Slt  of 'r * 'r * 'r
                | Lw   of 'r * int * 'r
                | Sw   of 'r * int * 'r
                | Beq  of 'r * 'r * 'l
                | Bne  of 'r * 'r * 'l
                | J    of 'l
                | Jal  of 'l
                | Jr   of 'r
                | Li   of 'r * int
                | Move of 'r * 'r
                | Label of 'l
                | Syscall 


let pretty (inst : (string, Reg.t) t) : string =
  match inst with
  | Add (rd, rs, rt) ->
      Printf.sprintf "add %s, %s, %s"
        (Reg.pretty rd) (Reg.pretty rs) (Reg.pretty rt)

  | Addi (rt, rs, imm) ->
      Printf.sprintf "addi %s, %s, %d"
        (Reg.pretty rt) (Reg.pretty rs) imm

  | Sub (rd, rs, rt) ->
      Printf.sprintf "sub %s, %s, %s"
        (Reg.pretty rd) (Reg.pretty rs) (Reg.pretty rt)

  | Mul (rd, rs, rt) ->
      Printf.sprintf "mul %s, %s, %s"
        (Reg.pretty rd) (Reg.pretty rs) (Reg.pretty rt)

  | And (rd, rs, rt) ->
      Printf.sprintf "and %s, %s, %s"
        (Reg.pretty rd) (Reg.pretty rs) (Reg.pretty rt)

  | Andi (rt, rs, imm) ->
      Printf.sprintf "andi %s, %s, %d"
        (Reg.pretty rt) (Reg.pretty rs) imm

  | Or (rd, rs, rt) ->
      Printf.sprintf "or %s, %s, %s"
        (Reg.pretty rd) (Reg.pretty rs) (Reg.pretty rt)

  | Xor (rd, rs, rt) ->
      Printf.sprintf "xor %s, %s, %s"
        (Reg.pretty rd) (Reg.pretty rs) (Reg.pretty rt)

  | Slt (rd, rs, rt) ->
      Printf.sprintf "slt %s, %s, %s"
        (Reg.pretty rd) (Reg.pretty rs) (Reg.pretty rt)

  | Lw (rt, offset, base) ->
      Printf.sprintf "lw %s, %d(%s)"
        (Reg.pretty rt) offset (Reg.pretty base)

  | Sw (rt, offset, base) ->
      Printf.sprintf "sw %s, %d(%s)"
        (Reg.pretty rt) offset (Reg.pretty base)

  | Beq (r1, r2, lbl) ->
      Printf.sprintf "beq %s, %s, %s"
        (Reg.pretty r1) (Reg.pretty r2) lbl

  | Bne (r1, r2, lbl) ->
      Printf.sprintf "bne %s, %s, %s"
        (Reg.pretty r1) (Reg.pretty r2) lbl

  | J lbl ->
      Printf.sprintf "j %s" lbl

  | Jal lbl ->
      Printf.sprintf "jal %s" lbl

  | Jr r ->
      Printf.sprintf "jr %s"
        (Reg.pretty r)

  | Li (rd, imm) ->
      Printf.sprintf "li %s, %d"
        (Reg.pretty rd) imm

  | Move (rd, rs) ->
      Printf.sprintf "move %s, %s"
        (Reg.pretty rd) (Reg.pretty rs)

  | Label lbl ->
      lbl ^ ":"

  | Syscall ->
    "syscall"
