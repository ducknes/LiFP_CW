domains
  list = string*
  pattern = string*

predicates
  match(string, pattern, list)
  find_matches(string, pattern)
  matches(string, pattern)
  any_string(string, string, string)
  any_symbol(string, string, string)
  one_symbol(string, string, string)
  other_symbol(string, char, string, string)

clauses
  find_matches(InputString, Pattern) :- 
    match(InputString, Pattern, ResultMatch), !, matches(InputString, Pattern);
    nl, write(InputString, " -> "), nl,
    write("No one matches").

  matches(InputString, Pattern) :- 
    match(InputString, Pattern, ResultMatch),
    nl, write(InputString, " -> "), nl,
    write(ResultMatch), nl, fail.
  matches(_, _).

  match("", [], []).

  match(InputString, ["-"|PatternTail], [ResultHead|ResultTail]) :-
    !, any_symbol(InputString, ResultHead, RemainingString),
    match(RemainingString, PatternTail, ResultTail).
  
  match(InputString, ["*"|PatternTail], [ResultHead|ResultTail]) :-
    !, any_string(InputString, ResultHead, RemainingString),
    match(RemainingString, PatternTail, ResultTail).

  match(InputString, ["?"|PatternTail], [ResultHead|ResultTail]) :-
    !, one_symbol(InputString, ResultHead, RemainingString),
    match(RemainingString, PatternTail, ResultTail).

  match(InputString, [PatternHead|PatternTail], [ResultHead|ResultTail]) :-
    frontchar(PatternHead, Symbol, ""),
    other_symbol(InputString, Symbol, ResultHead, RemainingString),
    match(RemainingString, PatternTail, ResultTail).

  any_string(InputString, "", InputString).
  any_string(InputString, MatchedResult, RemainingString) :-
    frontchar(InputString, Head, Tail),
    any_string(Tail,  MatchedPart, RemainingString),
		frontchar(MatchedResult, Head,  MatchedPart).

  any_symbol(InputString, "", InputString).
  any_symbol(InputString, MatchedResult, RemainingString) :- 
    other_symbol(InputString, _, MatchedResult, RemainingString).

  one_symbol(InputString, MatchedResult, RemainingString) :- 
    other_symbol(InputString, _, MatchedResult, RemainingString).

  other_symbol(InputString, Symbol, MatchedResult, RemainingString) :-
    frontchar(InputString, Symbol, RemainingString),
    frontchar(MatchedResult, Symbol, "").

goal
  clearwindow,
  write("Input your string -> "), nl,
  readln(InputString), nl,
  Pattern = ["-", "C", "*", "T", "?"],
	write("Pattern -> "), nl,
	write(Pattern), nl,
	find_matches(InputString, Pattern).