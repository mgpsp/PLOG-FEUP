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
	Board = [[blue, red, empty, empty, empty],
			[empty, red, blue, blue, empty],
			[blue, empty, empty, empty, empty],
			[empty, empty, empty, empty, empty],
			[empty, empty, empty, empty, empty]].

% ======================== %
%    MATRIX MANUPULATION   %
% ======================== %

%%% 1. container; 2. elem at the front.
peekFront([ElemAtTheHead|_], ElemAtTheHead).

%%% 1. element row; 2. element column; 3. matrix; 4. query element.
getMatrixElemAt(0, ElemCol, [ListAtTheHead|_], Elem):-
	getListElemAt(ElemCol, ListAtTheHead, Elem).
getMatrixElemAt(ElemRow, ElemCol, [_|RemainingLists], Elem):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	getMatrixElemAt(ElemRow1, ElemCol, RemainingLists, Elem).

%%% 1. element position; 2. list; 3. query element.
getListElemAt(0, [ElemAtTheHead|_], ElemAtTheHead).
getListElemAt(Pos, [_|RemainingElems], Elem):-
	Pos > 0,
	Pos1 is Pos-1,
	getListElemAt(Pos1, RemainingElems, Elem).

%%% 1. element row; 2. element column; 3. element to use on replacement; 3. current matrix; 4. resultant matrix.
setMatrixElemAtWith(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
	setListElemAtWith(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).
setMatrixElemAtWith(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	setMatrixElemAtWith(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

%%% 1. position; 2. element to use on replacement; 3. current list; 4. resultant list.
setListElemAtWith(0, Elem, [_|L], [Elem|L]).
setListElemAtWith(I, Elem, [H|L], [H|ResL]):-
	I > 0,
	I1 is I-1,
	setListElemAtWith(I1, Elem, L, ResL).

%%% 1. element to be replaced; 2. element to use on replacements; 3. current matrix; 4. resultant matrix.
replaceMatrixElemWith(_, _, [], []).
replaceMatrixElemWith(A, B, [Line|RL], [ResLine|ResRL]):-
	replaceListElemWith(A, B, Line, ResLine),
	replaceMatrixElemWith(A, B, RL, ResRL).

%%% 1. element to be replaced; 2. element to use on replacements; 3. current list; 4. resultant list.
replaceListElemWith(_, _, [], []).
replaceListElemWith(A, B, [A|L1], [B|L2]):-
	replaceListElemWith(A, B, L1, L2).
replaceListElemWith(A, B, [C|L1], [C|L2]):-
	C \= A,
	replaceListElemWith(A, B, L1, L2).
