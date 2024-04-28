
module Hello(Time: Mirage_time.S)(C: Cohttp_lwt.S.Client) = struct

  module Client = Client.Make(Time)(C)

  let start time ctx = 
    Client.start time ctx (Uri.of_string "https://google.com")
  
end