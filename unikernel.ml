open Cmdliner

let interval =
  let doc = Arg.info ~doc:"Client fetch interval (in seconds)" ["interval"]
in
Arg.(value & opt int 1 doc)

let uri_conv = 
  Arg.conv( (fun s ->  Ok (Uri.of_string s)),  Uri.pp)

let default_target = Uri.of_string "https://arepublixchickentendersubsonsale.com"

let target =
  let doc = Arg.info ~doc:"Upstream target to fetch" ["upstream"]
in
Arg.(value & opt uri_conv default_target doc)



module Hello(Time: Mirage_time.S)(C: Cohttp_lwt.S.Client)(M: Mirage_clock.MCLOCK) = struct

  module Client = Client.Make(Time)(C)(M)

  let start _time ctx _clock interval target = 
    Client.start ctx target (Duration.of_sec interval)
  
end