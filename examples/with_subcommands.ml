let () =
  Sources.add_subcommand ~name:"chromium" (Extra_sources.chromium_bookmarks ()) ;
  Sources.add_subcommand ~name:"mpcload" (Extra_sources.mpc_playlists ())

let run =
  let open Dmlenu in
  let app_state = {
    prompt = "" ;
    compl = Completion.make_state (Sources.binaries_with_subcommands) ;
  }
  in
  match run app_state default_conf with
  | None -> ()
  | Some command -> Printf.printf "%s\n%!" command
