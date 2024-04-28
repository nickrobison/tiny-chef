module Make
    (Time : Mirage_time.S)
    (C : Cohttp_lwt.S.Client)
    (M : Mirage_clock.MCLOCK) : sig
  val start : C.ctx -> Uri.t -> Duration.t -> unit Lwt.t
end
