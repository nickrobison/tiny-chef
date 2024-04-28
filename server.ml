module Make(CON: Conduit_mirage.S) = struct

  let src = Logs.Src.create "tiny-chef.server" ~doc:"Tiny Chef Webserver"

  module Log = (val Logs.src_log src: Logs.LOG)
  module H = Cohttp_mirage.Server.Make(CON)

  let split_path path =
    let rec aux = function
      | [] | [""] -> []
      | hd::tl -> hd :: aux tl
    in
    List.filter (fun e -> e <> "") (aux (Re.Str.(split_delim (regexp_string "/") path)))

  let callback (_, conn_id) req _body = 
    let uri = Cohttp.Request.uri req in
    let headers = Cohttp.Request.headers req in
    let path = Uri.path uri in
    Log.info (fun f -> f "Received connection %s on path %s" (Cohttp.Connection.to_string conn_id) path );
    let segments = split_path path in
    let resp status body_str = H.respond ~headers ~status ~body:(Cohttp_lwt.Body.of_string body_str) () in
    match segments with
    | ["teapot"] -> resp `I_m_a_teapot "\n"
    | ["ping"] -> resp `OK "Pong\n"
      | _ -> resp `OK "Hello world\n"
    

  let start conduit port = 
    let spec = H.make ~callback () in
    Log.info (fun f -> f "Starting sever on port %d" port);
    H.listen conduit (`TCP port) spec
end