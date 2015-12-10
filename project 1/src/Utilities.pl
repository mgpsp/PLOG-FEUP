printCell(empty, ' ').
printCell(red, '#').
printCell(blue, '*').

clrscr:-
	clrscr(70), !.

clrscr(0).
clrscr(N):-
	nl,
	N1 is N - 1,
	clrscr(N1).

getChar(C):-
	get_char(C),
	get_char(_).

getInt(I):-
	get_code(K),
	get_code(_),
	I is K - 48.

emptyBoard(Board):-
	Board = [[empty, empty, empty, empty, empty],
			[empty, empty, empty, empty, empty],
			[empty, empty, empty, empty, empty],
			[empty, empty, empty, empty, empty],
			[empty, empty, empty, empty, empty]].

middleState(Board):-
	Board = [[empty, blue, empty, blue, empty],
			[red, red, empty, blue, empty],
			[empty, red, red, red, blue],
			[blue, empty, red, empty, blue],
			[red, blue, red, red, blue]].

finalState(Board):-
	Board = [[empty, blue, empty, empty, red],
			[empty, empty, empty, empty, empty],
			[empty, empty, empty, empty, blue],
			[empty, empty, empty, empty, blue],
			[empty, empty, empty, empty, blue]].

% ======================== %
%    MATRIX MANUPULATION   %
% ======================== %

getMatrixElemAt(0, ElemCol, [ListAtTheHead|_], Elem):-
	getListElemAt(ElemCol, ListAtTheHead, Elem).
getMatrixElemAt(ElemRow, ElemCol, [_|RemainingLists], Elem):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	getMatrixElemAt(ElemRow1, ElemCol, RemainingLists, Elem).

getListElemAt(0, [ElemAtTheHead|_], ElemAtTheHead).
getListElemAt(Pos, [_|RemainingElems], Elem):-
	Pos > 0,
	Pos1 is Pos-1,
	getListElemAt(Pos1, RemainingElems, Elem).

setMatrixElemAtWith(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
	setListElemAtWith(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).
setMatrixElemAtWith(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	setMatrixElemAtWith(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

setListElemAtWith(0, Elem, [_|L], [Elem|L]).
setListElemAtWith(I, Elem, [H|L], [H|ResL]):-
	I > 0,
	I1 is I-1,
	setListElemAtWith(I1, Elem, L, ResL).
