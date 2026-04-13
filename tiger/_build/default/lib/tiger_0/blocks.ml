module type INST = sig
  type t
  val isJumpLike : t -> bool
  val isTarget : t -> bool
end

module BasicBlocks (I : INST) = struct
  type block = I.t list

  let basicBlocks (ins : I.t list) =
    let rec aux curr acc = function
      | [] ->
          if curr = [] then List.rev acc
          else List.rev ((List.rev curr) :: acc)

      | i :: rest ->
          if I.isTarget i then
            let acc =
              if curr = [] then acc
              else (List.rev curr) :: acc
            in
            if I.isJumpLike i then
              aux [] (([i]) :: acc) rest
            else
              aux [i] acc rest

          else if I.isJumpLike i then
            aux [] ((List.rev (i :: curr)) :: acc) rest

          else
            aux (i :: curr) acc rest
    in
    aux [] [] ins
end
