(* Copyright (c) 2016 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open Cmdliner

let lint file =
  let open Fmt in
  let pp_ok ppf =
    pf ppf "%a @[%a@]@." (styled `Green string) "Success:" (Changes.pp ~sep:sp) in
  let pp_err ppf =
    pf ppf "%a@.%s@." (styled `Red string) "Failure:" in
  open_in file |>
  Changes.of_channel |>
  Rresult.R.pp ~ok:pp_ok ~error:pp_err stdout

let cmd =
  let chfile =
    let doc = "Change log file to lint" in
    Arg.(value & pos 0 file "CHANGES.md" & info [] ~docv:"FILE" ~doc)
  in
  let doc = "OPAM Change log plugin" in
  let man = [
    `S "DESCRIPTION";
    `S "BUGS";
    `P "Report them via e-mail to <mirageos-devel@lists.xenproject.org>, or \
        on the issue tracker at <https://github.com/dsheets/ocaml-changes/issues>";
  ] in
  Term.(pure lint $ chfile),
  Term.info "opam-changes" ~version:"1.0.0" ~doc ~man

let () =
  Fmt_tty.setup_std_outputs ();
  match Term.eval cmd with
  | `Error _ -> exit 1
  | _ -> exit 0

