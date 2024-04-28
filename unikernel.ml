open Cmdliner

let interval =
  let doc = Arg.info ~doc:"Client fetch interval (in seconds)" ["interval"]
in
Arg.(value & opt int 5 doc)

let uri_conv = 
  Arg.conv( (fun s ->  Ok (Uri.of_string s)),  Uri.pp)

let default_target = Uri.of_string "https://arepublixchickentendersubsonsale.com"

let target =
  let doc = Arg.info ~doc:"Upstream target to fetch" ["upstream"]
in
Arg.(value & opt uri_conv default_target doc)

let http_port = 
  let doc = Arg.info ~doc:"HTTP port to listen on" ["http_port"]
in
Arg.(value & opt int 8080 doc)



module TinyChef(Time: Mirage_time.S)(CON: Conduit_mirage.S)(M: Mirage_clock.MCLOCK)(C: Cohttp_lwt.S.Client) = struct

  module Client = Client.Make(Time)(C)(M)
  module Server = Server.Make(CON)

  let start _time con _clock ctx interval target http_port = 
    let client = Client.start ctx target (Duration.of_sec interval) in
    let server = Server.start con http_port in
    Lwt.join [client; server]
  
end