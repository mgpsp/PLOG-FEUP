:- use_module(library(clpfd)).
:- use_module(library(samsort)).
:- use_module(library(lists)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        INTERFACE       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pinwheelPuzzle:-
	clrscr,
	write('   :: Pinwheel Puzzle ::   '), nl,
	write('                            '), nl,
	write('   1. Solve in easy mode    '), nl,
	write('   2. Solve in hard mode    '), nl,
	write('   3. Exit                  '), nl,
	write('                            '), nl,
	write('   > '),
	getChar(OP), (
		OP = '1' -> clrscr, getEasyModeBoard(Board), solveAndShow(Board, 15), pinwheelPuzzle;
		OP = '2' -> clrscr, getHardModeBoard(Board), solveAndShow(Board, 20), pinwheelPuzzle;
		OP = '3';
		pinwheelPuzzle).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%         SOLVER         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

 solveAndShow(Board, Sum):-
 	solvePinwheel(Board, Result, Sum),
 	nl, write('   Press enter to show next solution or write "e" to exit. '),
 	get_char(C), 
 	((C = 'e'; C = 'E') -> get_char(_);
 	clrscr, printResult(Result)), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%         PRINTER        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

printResult(Board):-
	write('   '),
	printSeparator(0, 9), nl,
	addElem(Board, 0, 9), !.

addElem(_, S, S).
addElem([H|T], I, S):-
	I1 is I + 1,
	write('  '),
	createLine(H, 0, S),
	nl, write('   '), printSeparator(0, S), nl, !,
	addElem(T, I1, S).

createLine(_, S, S).
createLine([A|B], I, S):-
	I1 is I + 1,
	write('| '),
	write(A),
	write(' | '),
	createLine(B, I1, S).

printSeparator(S, S).
printSeparator(0, S):-
	write('--- '),
	printSeparator(1, S), !.
printSeparator(A, S):-
	A1 is A + 1,
	write('  --- '),
	printSeparator(A1, S), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%         BOARDS         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getEasyModeBoard(Board):-
	Board = [[5, 4, 6, 4, 6, 6, 4, 5, 5],
			[5, 7, 8, 4, 5, 3, 2, 6, 7],
			[8, 5, 6, 2, 1, 4, 6, 7, 4]].

getHardModeBoard(Board):-
	Board = [[3, 4, 5, 1, 10, 8, 6, 5, 3],
			[5, 4, 6, 4, 6, 6, 4, 5, 5],
			[5, 7, 8, 4, 5, 3, 2, 6, 7],
			[8, 5, 6, 2, 1, 4, 6, 7, 4]].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        UTILITIES       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getChar(C):-
	get_char(C),
	get_char(_).

clrscr:-
	clrscr(70), !.
clrscr(0).
clrscr(N):-
	nl,
	N1 is N - 1,
	clrscr(N1).