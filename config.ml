open Mirage
(* 
let upstream_host_key =
  let doc = Key.Arg.info
              ~doc: "Upstream host to query"
              ~docv:"URL"
              in
              Key.(create "upstream_host" Arg.(opt string "https://arepublixchickentendersubsonsale.com" doc))
 *)

let client = main ~packages:[package "duration"] "Unikernel.Hello" (time @-> job)

let () = register "hello" [client $ default_time]
  (* let stack =  generic_stackv4v6 default_network in
  let res_dns = resolver_dns stack in
  let conduit = conduit_direct ~tls:true stack in *)
  (* let job = [client $ default_time] in
  register "hello" job *)
