open Lwt.Infix

module Make(Time: Mirage_time.S)(C: Cohttp_lwt.S.Client) = struct

  let src = Logs.Src.create "tiny-chef.client" ~doc:"Tiny Chef HTTP client"

  module Log = (val Logs.src_log src: Logs.LOG)

  let request ctx uri =
    C.get ~ctx uri >>= fun (_resp, body) ->
      body |> Cohttp_lwt.Body.to_string >|= fun body ->
        Log.info (fun f -> f "Requested");
        body



  let rec repeat (ctx: C.ctx) (uri: Uri.t) (timeout: Duration.t) = 
    request ctx uri >>= fun b -> 
      Log.info (fun f -> f "Done %s" b);
      Time.sleep_ns timeout >>= fun () ->
        repeat ctx uri timeout
    
  
  let start _time (ctx: C.ctx) (uri: Uri.t) =
    repeat ctx uri (Duration.of_sec 1)


end