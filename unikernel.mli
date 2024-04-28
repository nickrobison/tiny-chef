open Cmdliner

val interval : int Term.t
val target : Uri.t Term.t
val http_port : int Term.t

module TinyChef
    (Time : Mirage_time.S)
    (CON : Conduit_mirage.S)
    (M : Mirage_clock.MCLOCK)
    (C : Cohttp_lwt.S.Client) : sig
  val start :
    unit -> CON.t -> unit -> C.ctx -> int -> Uri.t -> int -> unit Lwt.t
end
