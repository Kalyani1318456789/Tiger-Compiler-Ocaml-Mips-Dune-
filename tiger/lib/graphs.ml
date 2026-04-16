module type MGRAPH = sig
  type node
  type 'a graph

  val empty   : unit -> 'a graph
  val newNode : 'a graph -> 'a -> node
  val addEdge : (node * node) -> unit

  val succ  : 'a graph -> node -> node list
  val pred  : 'a graph -> node -> node list
  val label : 'a graph -> node -> 'a

  val clear : 'a graph -> unit
  val all   : 'a graph -> node list
end

module Graph : MGRAPH = struct

  type node = int

  type 'a graph = {
    mutable count : int;
    labels : (node, 'a) Hashtbl.t;
    succs  : (node, node list) Hashtbl.t;
    preds  : (node, node list) Hashtbl.t;
  }

  (* global current graph (because addEdge has no graph arg) *)
  let current_graph : (Obj.t graph) option ref = ref None

  let empty () =
    let g = {
      count = 0;
      labels = Hashtbl.create 32;
      succs  = Hashtbl.create 32;
      preds  = Hashtbl.create 32;
    } in
    current_graph := Some (Obj.magic g);
    g

  let newNode g lbl =
    let id = g.count in
    g.count <- g.count + 1;
    Hashtbl.add g.labels id lbl;
    Hashtbl.add g.succs id [];
    Hashtbl.add g.preds id [];
    id

  let addEdge (u, v) =
    match !current_graph with
    | None -> failwith "No active graph"
    | Some g_any ->
        let g = (Obj.magic g_any : _ graph) in
        let s = Hashtbl.find g.succs u in
        Hashtbl.replace g.succs u (v :: s);

        let p = Hashtbl.find g.preds v in
        Hashtbl.replace g.preds v (u :: p)

  let succ g n =
    try Hashtbl.find g.succs n
    with Not_found -> []

  let pred g n =
    try Hashtbl.find g.preds n
    with Not_found -> []

  let label g n =
    Hashtbl.find g.labels n

  let clear g =
    Hashtbl.clear g.labels;
    Hashtbl.clear g.succs;
    Hashtbl.clear g.preds;
    g.count <- 0

  let all g =
    Hashtbl.fold (fun k _ acc -> k :: acc) g.labels []

end
