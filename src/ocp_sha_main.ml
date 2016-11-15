let usage () =
  Printf.eprintf "Usage: %s <256|512|sha256|sha512> <files>...\n"
    Sys.executable_name;
  exit 2

let () =
  if Array.length Sys.argv < 2 then usage ();
  let algo =
    match Sys.argv.(1) with
    | "256" | "sha256" | "SHA256" -> `SHA256
    | "512" | "sha512" | "SHA512" -> `SHA512
    | _ -> usage ()
  in
  for i = 2 to Array.length Sys.argv - 1 do
    print_endline (SHA.hash algo Sys.argv.(i))
  done
