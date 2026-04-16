open Tiger

(* Instruction interface for basic blocks *)
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
module G  = Graphs.Graph

(* Extract label from block *)
let get_label block =
  match block with
  | Inst.Label l :: _ -> Some l
  | _ -> None

(* Extract jump targets *)
let get_targets block =
  match List.rev block with
  | Inst.J l :: _ -> [l]
  | Inst.Bne (_, _, l) :: _ -> [l]
  | Inst.Beq (_, _, l) :: _ -> [l]
  | _ -> []

let build_cfg blocks =
  let g = G.empty () in

  (* label -> node *)
  let label_map = Hashtbl.create 16 in

  (* create nodes *)
  let nodes =
    List.map (fun b ->
      let n = G.newNode g b in
      (b, n)
    ) blocks
  in

  (* fill label map *)
  List.iter (fun (b, n) ->
    match get_label b with
    | Some l -> Hashtbl.add label_map l n
    | None -> ()
  ) nodes;

  (* add edges *)
  List.iteri (fun i (block, node) ->

    (* jump edges *)
    let targets = get_targets block in
    List.iter (fun l ->
      if Hashtbl.mem label_map l then
        G.addEdge (node, Hashtbl.find label_map l)
    ) targets;

    (* fall-through *)
    match List.rev block with
    | Inst.J _ :: _ -> ()  (* no fall-through *)
    | _ ->
        if i + 1 < List.length nodes then
          let (_, next_node) = List.nth nodes (i + 1) in
          G.addEdge (node, next_node)

  ) nodes;

  g

let () =
  if Array.length Sys.argv < 2 then (
    Printf.eprintf "Usage: graphs <file.tig>\n";
    exit 1
  );

  let filename = Sys.argv.(1) in

  (* read file *)
  let ch = open_in filename in
  let len = in_channel_length ch in
  let input = really_input_string ch len in
  close_in ch;

  (* pipeline *)
  let lexbuf = Lexing.from_string input in
  let ast = Parser.program Lexer.token lexbuf in
  let ir = Translate.trans ast in
  let mips = Codegen.codegen ir in
  let blocks = BB.basicBlocks mips in
  let cfg = build_cfg blocks in   (* ← inside let () = ... so OK *)

  print_endline "\nCFG:";

  let node_to_int (n : G.node) = Obj.magic n in
  let nodes = List.sort compare (G.all cfg) in

  List.iter (fun n ->
    let s = G.succ cfg n in
    Printf.printf "Node %d -> " (node_to_int n);
    List.iter (fun x ->
      Printf.printf "%d " (node_to_int x)
    ) s;
    print_newline ()
  ) nodes;
