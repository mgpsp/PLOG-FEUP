:- use_module(library(lists)).

:- include('Utilities.pl').
:- include('Menus.pl').
:- include('PushPiece.pl').
:- include('CapturePiece.pl').

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
	(RemainingStones =:= 0 -> playGame(Board, 0, 0, Player, [move, push, sacrifice, pass]), fail;
	RemainingStones > 0 -> true; fail),
	printBoard(Board),
	printPlayerInfo(Player, BlueStones, RedStones), !,
	putPieceAt(Board, Player, ResultantBoard),
	updateNumPieces(Player, BlueStones, RedStones, UpdatedBs, UpdatedRs),
	getNextPlayer(Player, NextPlayer),
	fillBoard(ResultantBoard, UpdatedBs, UpdatedRs, NextPlayer).

getNextPlayer(Player, NextPlayer):-
	(Player = 'Blue' -> NextPlayer = 'Red';
	Player = 'Red' -> NextPlayer = 'Blue').

updateNumPieces(Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	(Player = 'Blue' -> UpdatedBs is BlueStones - 1, UpdatedRs is RedStones;
	Player = 'Red' -> UpdatedRs is RedStones - 1, UpdatedBs is BlueStones).

putPieceAt(Board, Player, ResultantBoard):-
	nl, write('  Where do you want to put the piece?'), nl, nl,
	getCoordinates(X, Y),
	validatePutPiece(X, Y, Board),
	getPieceColor(Player, Piece),
	setMatrixElemAtWith(X, Y, Piece, Board, ResultantBoard).

getCoordinates(X, Y):-
	write('    Row: '),
	getInt(X1),
	write('    Column: '), !,
	getInt(Y1),
	validateCoordsLimit(X1, Y1),
	X is X1 - 1, Y is Y1 - 1.

validateCoordsLimit(X, Y):-
	X > 0, X < 6,
	Y > 0, Y < 6, !.

validateCoordsLimit(_, _):-
	nl, write('  Invalid input! Out of limits.'), nl, nl, fail.

validatePutPiece(X, Y, Board):-
	getMatrixElemAt(X, Y, Board, Cell),
	Cell == empty, !.

validadePutPiece(_, _, _):-
	nl, write('  Invalid input! Not an empty cell.'), nl, fail.

getPieceColor(Player, Piece):-
	(Player = 'Blue' -> Piece = blue;
	Player = 'Red' -> Piece = red).

duplicateBoard(Board, Duplicate):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, Duplicate).

countPieces(_, 5, _, BlueP, RedP, BlueP, RedP):- !.

countPieces(Board, X, Y, BlueP, RedP, TotalB, TotalR):-
	getMatrixElemAt(X, Y, Board, Cell),
	(Cell = blue -> BP is BlueP + 1, RP is RedP;
	Cell = red -> RP is RedP + 1, BP is BlueP;
	BP is BlueP, RP is RedP),
	Y1 is Y + 1,
	(Y1 =:= 5 -> X1 is X + 1, countPieces(Board, X1, 0, BP, RP, TotalB, TotalR);
	countPieces(Board, X, Y1, BP, RP, TotalB, TotalR)).

removePlayFromList(Play, AvailablePlays, ResultantPlays):-
	!, select(Play, AvailablePlays, ResultantPlays).

removePlayFromList(_, _, _).

checkGameOver(Board):-
	countPieces(Board, 0, 0, 0, 0, BS, RS), !,
	(BS < 2 -> nl, write('Red player wins!'), nl, fail;
	RS < 2 -> nl, write('Blue player wins!'), nl, fail;
	true).

playGame(Board, BlueStones, RedStones, Player, AvailablePlays) :-
	length(AvailablePlays, S),
	(S =:= 1 -> getNextPlayer(Player, NextPlayer), playGame(Board, BlueStones, RedStones, NextPlayer, [move, push, sacrifice, pass]);
	printBoard(Board), !,
	checkGameOver(Board),
	printPlayerInfo(Player, BlueStones, RedStones), nl,
	write('  Choose a play:'), nl, nl,
	printAvailablePlays(AvailablePlays, 0, S), nl,
	write('  > '),
	read(Play),
	(Play == pass -> getNextPlayer(Player, NextPlayer), playGame(Board, BlueStones, RedStones, NextPlayer, [move, push, sacrifice, pass]); true),
	removePlayFromList(Play, AvailablePlays, ResultantPlays),
	getInputByPlay(Board, Play, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player),
	playGame(ResultantBoard, UpdatedBs, UpdatedRs, Player, ResultantPlays)).

getInputByPlay(Board, Play, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player):-
	(Play = move -> movePiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	Play = push -> pushPiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	Play = sacrifice -> sacrificePiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	duplicateBoard(Board, ResultantBoard),
	UpdatedRs is RedStones,
	UpdatedBs is BlueStones).

validateMovePiece(SrcX, SrcY, DestX, DestY, Board):-
	DifX is abs(SrcX - DestX),
	DifY is abs(SrcY - DestY),
	DifX < 2,
	DifY < 2,
	getMatrixElemAt(DestX, DestY, Board, Cell),
	Cell == empty, !.

validateMovePiece(_, _, _, _, _):-
	nl, write('  Not a valid move.'), nl, nl, fail.

movePiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	nl, write('  What piece do you want to move?'), nl, nl,
	get_code(_),
	repeat,
		getCoordinates(SrcX, SrcY),
		(validatePieceOwnership(SrcX, SrcY, Player, Board) -> !),
	nl, write('  Where do you want to move the piece?'), nl, nl,
	repeat,
		getCoordinates(DestX, DestY),
		(validateMovePiece(SrcX, SrcY, DestX, DestY, Board) -> !),
 	getPieceColor(Player, Piece),
	setMatrixElemAtWith(SrcX, SrcY, empty, Board, TmpBoard),
	setMatrixElemAtWith(DestX, DestY, Piece, TmpBoard, TmpBoard1),
	checkCapture(DestX, DestY, TmpBoard1, ResultantBoard, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player).
	
pushPiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	nl, write('  What piece do you want to push?'), nl, nl,
	get_code(_),
	repeat,
		getCoordinates(SrcX, SrcY),
		(validatePieceOwnership(SrcX, SrcY, Player, Board) -> !),
	nl, write('  In which direction do you want to push?'), nl, nl,
	write('    1. Left'), nl,
	write('    2. Left Up'), nl,
	write('    3. Up'), nl,
	write('    4. Right Up'), nl,
	write('    5. Right'), nl,
	write('    6. Right Down'), nl,
	write('    7. Down'), nl,
	write('    8. Left Down'), nl,
	write('    9. Exit'), nl, nl,
	repeat,
		write(' > '),
		getInt(OP),
		(getPushInput(OP, SrcX, SrcY, Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs) -> !).

getPushInput(OP, X, Y, Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	(OP =:= 1 -> validatePush(Board, X, Y, Player, 0 , -1), pushPieces(Board, X, Y, 0, -1, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	OP =:= 2 -> validatePush(Board, X, Y, Player, -1 , -1), pushPieces(Board, X, Y, -1, -1, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	OP =:= 3 -> validatePush(Board, X, Y, Player, -1 , 0), pushPieces(Board, X, Y, -1, 0, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	OP =:= 4 -> validatePush(Board, X, Y, Player, -1 , 1), pushPieces(Board, X, Y, -1, 1, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	OP =:= 5 -> validatePush(Board, X, Y, Player, 0 , 1), pushPieces(Board, X, Y, 0, 1, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	OP =:= 6 -> validatePush(Board, X, Y, Player, 1 , 1), pushPieces(Board, X, Y, 1, 1, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	OP =:= 7 -> validatePush(Board, X, Y, Player, 1 , 0), pushPieces(Board, X, Y, 1, 0, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	OP =:= 8 -> validatePush(Board, X, Y, Player, 1 , -1), pushPieces(Board, X, Y, 1, -1, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	duplicateBoard(Board, ResultantBoard), UpdatedBs is BlueStones, UpdatedRs is RedStones).

sacrificePiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	nl, write('  What piece do you want to sacrifice?'), nl, nl,
	get_code(_),
	repeat,
		getCoordinates(SrcX, SrcY),
		(validatePieceOwnership(SrcX, SrcY, Player, Board) -> !),
	setMatrixElemAtWith(SrcX, SrcY, empty, Board, TmpBoard),
	printBoard(TmpBoard),
	nl, write('  Choose a play:'), nl, nl,
	write('    move'), nl,
	write('    push'), nl, nl,
	write('  > '),
	read(Play),
	getInputByPlay(TmpBoard, Play, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player).

validatePieceOwnership(X, Y, Player, Board):-
	getPieceColor(Player, Piece),
	getMatrixElemAt(X, Y, Board, Cell),
	(Cell \= Piece -> nl, write('  Not your stone.'), nl, nl, fail;
	true).


% ============================== %
%           PRINT BOARD          %
% ============================== %

printPlayerInfo(Player, BlueStones, RedStones):-
	nl, write('  It\'s the '), write(Player), write(' player\'s turn'),
	(Player = 'Blue' -> write(' ('), write(BlueStones), write(' stones in the pool).');
	Player = 'Red' -> write(' ('), write(RedStones), write(' stones in the pool).')), nl.

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
