open Tiger

let read_file filename =
  let ch = open_in filename in
  let len = in_channel_length ch in
  let content = really_input_string ch len in
  close_in ch;
  content

(* Use MIPS instructions for blocks *)
module InstBB = struct
  type t = (string, Reg.t) Inst.t

  let isJumpLike = function
    | Inst.J _ -> true
    | Inst.Bne _ -> true
    | Inst.Beq _ -> true 
    | _ -> false

  let isTarget = function
    | Inst.Label _ -> true
    | _ -> false
end

module BB = Blocks.BasicBlocks(InstBB)

let () =
  if Array.length Sys.argv < 2 then (
    Printf.eprintf "Usage: blocks <file.tig>\n";
    exit 1
  );

  let filename = Sys.argv.(1) in
  let input = read_file filename in
  let lexbuf = Lexing.from_string input in

  let ast = Parser.program Lexer.token lexbuf in
  let ir = Translate.trans ast in
  let mips = Codegen.codegen ir in
  let blocks = BB.basicBlocks mips in

  List.iteri (fun i block ->
    Printf.printf "BLOCK %d\n" (i + 1);
    List.iter (fun inst ->
      print_endline (Inst.pretty inst)
    ) block
  ) blocks
