open Lwt.Syntax
open Cohttp

module Make(Time: Mirage_time.S)(C: Cohttp_lwt.S.Client)(M: Mirage_clock.MCLOCK) = struct

  let src = Logs.Src.create "tiny-chef.client" ~doc:"Tiny Chef HTTP client"

  module Log = (val Logs.src_log src: Logs.LOG)

  let request ctx uri =
    let start = M.elapsed_ns () in
    let* resp, body = C.get ~ctx uri in
    let finished = M.elapsed_ns () in
    let duration = Int64.sub finished start in
    let response_code = resp |> Response.status |> Code.code_of_status in
    let+ body = body |> Cohttp_lwt.Body.to_string in
    match Code.is_success response_code with
    | false -> 
      Log.err (fun f -> f "Received response: %d after %d ms" response_code (Duration.to_ms duration));
      body
      | true -> 
          Log.info (fun f -> f "Received response: %d after %d ms" response_code (Duration.to_ms duration));
          body


  let rec repeat ctx uri timeout = 
    let* _ = request ctx uri in
    let* _ = Time.sleep_ns timeout in
      Log.info (fun f -> f "Done");
        repeat ctx uri timeout
    
  
  let start (ctx: C.ctx) (uri: Uri.t) interval =
    repeat ctx uri interval


end