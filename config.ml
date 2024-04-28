open Mirage
(* 
let upstream_host_key =
  let doc = Key.Arg.info
              ~doc: "Upstream host to query"
              ~docv:"URL"
              in
              Key.(create "upstream_host" Arg.(opt string "https://arepublixchickentendersubsonsale.com" doc))
 *)

let client = main ~packages:[package "duration"; package "cohttp-mirage"] "Unikernel.Hello" (time @-> http_client @-> job)

let () =
  let stack =  generic_stackv4v6 default_network in
  let res_dns = resolver_dns stack in
  let conduit = conduit_direct ~tls:true stack in
  let job = [client $ default_time $ cohttp_client res_dns conduit] in
  register "hello" job
