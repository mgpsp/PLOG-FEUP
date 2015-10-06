:- include('utilities.pl').

stone(S):-
	write('     '),
    printColumnIdentifiers(0, S), nl,
	write('   '), printSeparator(0, S), nl,
	middleState(A),
	addElem(A, 0, S).

addElem(_, S, S).
addElem([H|T], I, S):-
	I1 is I + 1,
	 printRowIdentifiers(I1),
	createLine(H, 0, S),
	nl, write('   '), printSeparator(0, S), nl,
	addElem(T, I1, S).

createLine(_, S, S):-
write('|     ').
createLine([A|B], I, S):-
	I1 is I + 1,
	write('| '),
	printCell(A, X),
	write(X),
	write(' '),
	createLine(B, I1, S).

printSeparator(S, S):-
	write('-').
printSeparator(A, S):-
	A1 is A + 1,
	write('----'),
	printSeparator(A1, S).


printColumnIdentifiers(S, S).
printColumnIdentifiers(A, S):-
	A < 10,
	A1 is A + 1,
	write(A1),
	write('   '),
	printColumnIdentifiers(A1, S).

printColumnIdentifiers(A, S):-
	A1 is A + 1,
	write(A1),
	write('  '),
	printColumnIdentifiers(A1, S).

printRowIdentifiers(G):-
	G < 10,
	write(G),
	write('  ').

printRowIdentifiers(G):-
	write(G),
	write(' ').

