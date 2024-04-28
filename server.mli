module Make (CON : Conduit_mirage.S) : sig
  val start : CON.t -> int -> unit Lwt.t
end
