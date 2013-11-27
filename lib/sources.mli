(** Sources *)
open Completion

(** {3 Matching function & completion function} *)

val match_strict: string -> (string -> string -> match_result)
(** [match_strict s] is a matching
    function that matches only queries that
    are substrings of [s] *)

val match_in_word : string -> (string -> string -> match_result)
  -> (string -> string -> match_result)
(** [match_in_word separator f] matches a query if the current word
    (according to [separator]) matches f *)
val complete_in_word : ?drop_cont : bool -> string -> (string -> string -> string * string) -> string -> string -> string * string
(** [complete_in_word ?drop_cont separator f] completes only in the
    current word (according to separator). If drop_cont is true (default
    false), it will drop the words after the cursor. *)

type t = Completion.ex_source

(** {3 Predefined sources and sources builder} *)

val filename : t
(** A source that completes to filename *)

val from_list : (string * string) list -> t
(** A source built from a list (display, real) *)

val from_list_ : string list -> t
(** A source built from a list of candidates (display and real are the same) *)

val kleene : string -> (t -> t)
(** [kleene sep s] builds a new source that completes
    finite list of elements in [s] separated by [sep] *)

val concat : string -> t -> t -> t
(** [concat sep s1 s2] builds a new source that completes an element
    of [s1] followed by an element of [s2], separated by [sep] *)

val binaries : t
(** A source that completes a binary of the system *)

val paths : coupled_with:t -> t
(** A source that complete like [coupled_with] except when what is before the
    cursor is (syntactically) a path, i.e. start with "/", "~/", or "./" *)

val stdin : ?sep: string -> unit -> t
(** A source that reads its elements off stdin. If separator is not
    supplied, then there is a candidate per line and the real and
    display fields of the candidate is the same.  If it is supplied,
    then lines are split wrt it and the first part is used as the
    display and the second part as the real *)

val dependant_sum : string -> t -> (string -> t) -> t
(** [dependant_sum sep s f] builds the dependant sum of (s, f), ie. it
    completes along [s] first, and then it uses the candidate to determine
    which source to use for the remaining part. The two parts are
    separated by [sep]. *)

(** {2 An interactive source} *)

val add_subcommand : name:string -> t -> unit
(** [add_subcommand ~name source] adds [source] under the name [name] in the
    list of subcommands used by [binaries_with_subcommands] *)

val set_default_subcommand_hook : (string -> t) -> unit
(** When [binaries_with_subcommands] doesn't find a subcommand of a given name
    [n] it will call the default subcommand hook with the string [n].

    The default behavior of this hook (i.e. if this function is never called) is
    to look for a file ["$HOME/.config/dmlenu/n"] and treat each line of this
    file as a completion candidate; if the file doesn't exists it behaves as
    [paths ~coupled_with:binaries]. *)

val binaries_with_subcommands : t
(** Behaves as [paths ~coupled_with:binaries] for the first completions, then
    looks in the subcommands list (see {!add_subcommand} and
    {!set_default_subcommand_hook}) for the following completions. *)