open Tiger
let read_file filename =
  let ch = open_in filename in
  let len = in_channel_length ch in
  let content = really_input_string ch len in
  close_in ch;
  content

let () =
  if Array.length Sys.argv < 2 then (
    Printf.eprintf "Usage: tc <file.tig>\n";
    exit 1
  );

  let filename = Sys.argv.(1) in

  let input = read_file filename in
  let lexbuf = Lexing.from_string input in

  let ast = Parser.program Lexer.token lexbuf in
  let ir = Translate.trans ast in
  let mips = Codegen.codegen ir in

  List.iter (fun inst ->
    print_endline (Inst.pretty inst)
  ) mips
