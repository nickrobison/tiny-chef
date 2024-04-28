open Lwt.Syntax

module Make(Time: Mirage_time.S)(C: Cohttp_lwt.S.Client) = struct

  let src = Logs.Src.create "tiny-chef.client" ~doc:"Tiny Chef HTTP client"

  module Log = (val Logs.src_log src: Logs.LOG)

  let request ctx uri =
    let* _resp, body = C.get ~ctx uri in
    let+ body = body |> Cohttp_lwt.Body.to_string in
        Log.info (fun f -> f "Requested");
        body



  let rec repeat (ctx: C.ctx) (uri: Uri.t) (timeout: Duration.t) = 
    let* b = request ctx uri in
    let* _ = Time.sleep_ns timeout in
      Log.info (fun f -> f "Done %s" b);
        repeat ctx uri timeout
    
  
  let start _time (ctx: C.ctx) (uri: Uri.t) =
    repeat ctx uri (Duration.of_sec 1)


end