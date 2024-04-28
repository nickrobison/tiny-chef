open Mirage

let runtime_args = [runtime_arg ~pos:__POS__ "Unikernel.interval"; runtime_arg ~pos:__POS__ "Unikernel.target"; runtime_arg ~pos:__POS__ "Unikernel.http_port"]


let client = main  ~runtime_args ~packages:[package "duration"; package "cohttp-mirage"] "Unikernel.Hello" (time @-> conduit @-> mclock @-> http_client @-> job)

let () =
  let stack =  generic_stackv4v6 default_network in
  let res_dns = resolver_dns stack in
  let conduit = conduit_direct ~tls:true stack in
  let job = [client $ default_time $ conduit $ default_monotonic_clock $ cohttp_client res_dns conduit] in
  register "hello" job
