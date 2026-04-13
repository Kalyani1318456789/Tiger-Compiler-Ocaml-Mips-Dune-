module type TEMP = sig
  type temp
  val newtemp      : unit -> temp
  val tempToString : temp -> string

  (* Labels for control flow *)
  type label
  val newlabel      : unit -> label
  val labelToString : label -> string
end


module Temp : TEMP = struct

  (* ===== TEMPS ===== *)

  type temp = int

  let nextTemp = ref 0

  let newtemp () =
    let t = !nextTemp in
    nextTemp := !nextTemp + 1;
    t

  let tempToString t =
    "t" ^ string_of_int t


  (* ===== LABELS ===== *)

  type label = int

  let labCount = ref 0

  let newlabel () =
    let l = !labCount in
    labCount := !labCount + 1;
    l

  let labelToString l =
    "L" ^ string_of_int l

end
