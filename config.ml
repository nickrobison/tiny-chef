open Mirage

let runtime_args = [runtime_arg ~pos:__POS__ "Unikernel.interval"; runtime_arg ~pos:__POS__ "Unikernel.target"]


let client = main  ~runtime_args ~packages:[package "duration"; package "cohttp-mirage"] "Unikernel.Hello" (time @-> http_client @-> mclock @-> job)

let () =
  let stack =  generic_stackv4v6 default_network in
  let res_dns = resolver_dns stack in
  let conduit = conduit_direct ~tls:true stack in
  let job = [client $ default_time $ cohttp_client res_dns conduit $ default_monotonic_clock] in
  register "hello" job
