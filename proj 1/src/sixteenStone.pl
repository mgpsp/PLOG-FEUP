:- use_module(library(lists)).

:- include('Utilities.pl').
:- include('Menus.pl').

% ============================== %
%        STARTING POINT          %
% ============================== %

sixteenStone:-
	mainMenu.

% ============================== %
%             PLAY GAME          %
% ============================== %

fillBoard(Board, BlueStones, RedStones, Player):-
	RemainingStones is BlueStones + RedStones, !,
	(RemainingStones =:= 0 -> playGame(Board, 0, 0, Player, [move, push, sacrifice]), fail;
	RemainingStones > 0 -> true; fail),
	printBoard(Board),
	printPlayerInfo(Player), !,
	putPieceAt(Board, Player, ResultantBoard),
	updateNumPieces(Player, BlueStones, RedStones, UpdatedBS, UpdatedRS),
	getNextPlayer(Player, NextPlayer),
	fillBoard(ResultantBoard, UpdatedBS, UpdatedRS, NextPlayer).

getNextPlayer(Player, NextPlayer):-
	(Player = 'Blue' -> NextPlayer = 'Red';
	Player = 'Red' -> NextPlayer = 'Blue').

updateNumPieces(Player, BlueStones, RedStones, UpdatedBS, UpdatedRS):-
	(Player = 'Blue' -> UpdatedBS is BlueStones - 1, UpdatedRS is RedStones;
	Player = 'Red' -> UpdatedRS is RedStones - 1, UpdatedBS is BlueStones).

putPieceAt(Board, Player, ResultantBoard):-
	nl, write('  Where do you want to put the piece?'), nl, nl,
	write('    Row: '),
	getInt(X),
	write('    Column: '), !,
	getInt(Y),
	validateCoordsLimit(X, Y),
	X1 is X - 1, Y1 is Y - 1,
	validadeMovePiece(X1, Y1, Board),
	getPieceColor(Player, Piece),
	setMatrixElemAtWith(X1, Y1, Piece, Board, ResultantBoard).

validateCoordsLimit(X, Y):-
	X > 0, X < 6,
	Y > 0, Y < 6, !.

validateCoordsLimit(_, _):-
	nl, write('  Invalid input! Out of limits.'), nl, fail.

validadeMovePiece(X, Y, Board):-
	getMatrixElemAt(X, Y, Board, Cell),
	Cell == empty, !.

validadeMovePiece(_, _, _):-
	nl, write('  Invalid input! Not an empty cell.'), nl, fail.

getPieceColor(Player, Piece):-
	(Player = 'Blue' -> Piece = blue;
	Player = 'Red' -> Piece = red).

playGame(Board, BlueStones, RedStones, Player, AvailablePlays) :-
	printBoard(Board), !,
	printPlayerInfo(Player), nl,
	write('  Choose a play:'), nl, nl,
	length(AvailablePlays, S),
	S > 0,
	printAvailablePlays(AvailablePlays, 0, S), nl,
	write('  > '),
	read(Play),
	updatePlays(Play, AvailablePlays, ResultantPlays),
	playGame(Board, BlueStones, RedStones, Player, ResultantPlays).

updatePlays(Play, AvailablePlays, ResultantPlays):-
	((Play = move; Play = push) -> select(Play, AvailablePlays, ResultantPlays);
	Play = sacrifice -> append(AvailablePlays, [push, move], TmpPlays), select(Play, TmpPlays, TmpPlays1), remove_dups(TmpPlays1, ResultantPlays)).


% ============================== %
%           PRINT BOARD          %
% ============================== %

printPlayerInfo(Player):-
	nl, write('  It\'s the '), write(Player), write(' player\'s turn.'), nl.

printAvailablePlays(_, S, S).
printAvailablePlays([H|T], I, S):-
	I1 is I + 1,
	write('    '), write(H), nl,
	printAvailablePlays(T, I1, S).

printBoard(Board):-
	clrscr,
	write('     '),
    printColumnIdentifiers(0, 5), nl,
	write('   '), printSeparator(0, 5), nl,
	addElem(Board, 0, 5).

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