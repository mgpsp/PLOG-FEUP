:- use_module(library(clpfd)).
:- use_module(library(samsort)).
:- use_module(library(lists)).

permutations([], []).
permutations([Line | Board], [ResultLine | Result]):-
	length(Line, N),
	length(ResultLine, N),
	length(P, N),
	sorting(ResultLine, P, Line),
	permutations(Board, Result).

checkSum([], _).
checkSum([Column | Columns], Sum):-
	sum(Column, #=, Sum),
	checkSum(Columns, Sum).

sortBoard([], []).
sortBoard([Line | Board], [SortedLine | SortedBoard]):-
	samsort(Line, SortedLine),
	sortBoard(Board, SortedBoard).

flattenList([], []).
flattenList([Line | List], Result):-
	is_list(Line), flattenList(Line, Result2), append(Result2, Tmp, Result), flattenList(List, Tmp).
flattenList([Line | List], [Line | Result]):-
	\+is_list(Line), flattenList(List, Result).

solvePinwheel(Board, Result, Sum):-
	sortBoard(Board, SortedBoard),
	permutations(SortedBoard, Result),
	transpose(Result, Columns),
	checkSum(Columns, Sum),
	flattenList(Result, Results),
	labeling([], Results).