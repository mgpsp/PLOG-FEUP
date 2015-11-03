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
	(RemainingStones =:= 0 -> playGame(Board, 1, 1, Player, [move, push, sacrifice]), fail;
	RemainingStones > 0 -> true; fail),
	printBoard(Board),
	printPlayerInfo(Player), !,
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
	validadePutPiece(X, Y, Board),
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
	nl, write('  Invalid input! Out of limits.'), nl, fail.

validadePutPiece(X, Y, Board):-
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

playGame(Board, BlueStones, RedStones, Player, AvailablePlays) :-
	printBoard(Board), !,
	printPlayerInfo(Player), nl,
	write('  Choose a play:'), nl, nl,
	length(AvailablePlays, S),
	(S =:= 0 -> getNextPlayer(Player, NextPlayer), playGame(Board, BlueStones, RedStones, NextPlayer, [move, push, sacrifice]); true),
	printAvailablePlays(AvailablePlays, 0, S), nl,
	write('  > '),
	read(Play),
	select(Play, AvailablePlays, ResultantPlays), !,
	getInputByPlay(Board, Play, ResultantBoard, Player, 1, 1, UpdatedBs, UpdatedRs, Player),
	playGame(ResultantBoard, UpdatedBs, UpdatedRs, Player, ResultantPlays).

getInputByPlay(Board, Play, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player):-
	(Play = move -> movePiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	Play = push -> pushPiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	Play = sacrifice -> sacrificePiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs);
	nl, write('  Invalid play.'), fail).

movePiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	nl, write('  What piece do you want to move?'), nl, nl,
	get_code(_),
	getCoordinates(SrcX, SrcY), !,
	validatePieceOwnership(SrcX, SrcY, Player, Board),
	nl, write('  Where do you want to move the piece?'), nl, nl,
	getCoordinates(DestX, DestY), !,
 	getPieceColor(Player, Piece),
	setMatrixElemAtWith(SrcX, SrcY, empty, Board, TmpBoard),
	setMatrixElemAtWith(DestX, DestY, Piece, TmpBoard, TmpBoard1), !,
	(( (Player = 'Blue', BlueStones > 0) ; (Player = 'Red', RedStones > 0) ) -> checkCapture(DestX, DestY, TmpBoard1, ResultantBoard, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player);
		UpdatedRs = RedStones, UpdatedBs = BlueStones).

pushPiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	nl, write('  What piece do you want to push?'), nl, nl,
	get_code(_),
	getCoordinates(SrcX, SrcY), !,
	validatePieceOwnership(SrcX, SrcY, Player, Board),
	nl, write('  In which direction do you want to push?'), nl, nl,
	write('    1. Left'), nl,
	write('    2. Left Up'), nl,
	write('    3. Up'), nl,
	write('    4. Right Up'), nl,
	write('    5. Right'), nl,
	write('    6. Right Down'), nl,
	write('    7. Down'), nl,
	write('    8. Left Down'), nl, nl,
	write(' > '),
	get_char(_),
	getChar(OP),
	((OP < 1 ; OP > 8) -> nl, write('  Invalid input.'), nl, pushPiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs)),
	getPushInput(OP, X, Y, Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs).

getPushInput(OP, X, Y, Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	(OP = '1' -> pushPieceLeft(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, empty);
	OP = '2' -> pushPieceLeftUp(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, empty);
	OP = '3' -> pushPieceUp(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, empty);
	OP = '4' -> pushPieceRightUp(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, empty);
	OP = '5' -> pushPieceRight(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, empty);
	OP = '6' -> pushPieceRightDown(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, empty);
	OP = '7' -> pushPieceDown(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, empty);
	OP = '8' -> pushPieceLeftDown(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, empty);
	true).

increment(X, X1):-
	(var(X) -> X is 0),
	X1 is X + 1.

countPiecesLeft(Board, X, Y, Piece, NumPieces, NextX, NextY):-
	getMatrixElemAt(X, Y, Board, Cell),
	Cell == Piece,
	increment(NumPieces, NewNumber),
	Y1 is Y - 1, Y1 > -1,
	countPiecesLeft(Board, X, Y1, Piece, NewNumber, X, Y1).

countPiecesLeft(_, _, _, _, _, _, _).

validatePushLeft(Board, X, Y, Player):-
	getPieceColor(Player, PlayerPiece),
	countPiecesLeft(Board, X, Y, PlayerPiece, PlayerPieces, LastX, LastY),
	getNextPlayer(Player, Oponent),
	getPieceColor(Oponent, OponentPiece),
	countPiecesLeft(Board, LastX, LastY, OponentPiece, OponentPieces, LastX1, LastY1),
	nonvar(OponentePieces), nonvar(PlayerPieces),
	PlayerPieces > OponentPieces,
	OponentPieces > 0,
	((LastX1 > -1, LastX1 < 5, LastY1 > -1, LastY1 < 5) -> getMatrixElemAt(LastX1, LastY1, Board, Cell), Cell == empty).

pushPieceLeft(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, PieceToSet):-
	Y1 is Y - 1, Y1 > -1,
	getMatrixElemAt(X, Y, Board, NextPiece),
	getPieceColor(Player, Piece),
	PieceToSet == Piece,
	setMatrixElemAtWith(X, Y, PieceToSet, Board, TmpBoard),
	checkCapture(X, Y1, TmpBoard, ResultantBoard, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player),
	pushPieceLeft(ResultantBoard, X, Y1, RBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, NextPiece).

pushPieceLeft(Board, _, _, ResultantBoard, _, BlueStones, RedStones, UpdatedBs, UpdatedRs, _):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

sacrificePiece(Board, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	nl, write('  Choose a play:'), nl, nl,
	write('    move'), nl,
	write('    push'), nl, nl,
	write('  > '),
	read(Play),
	getInputByPlay(Board, Play, ResultantBoard, Player, 1, 1, UpdatedBs, UpdatedRs, Player).

validatePieceOwnership(X, Y, Player, Board):-
	getPieceColor(Player, Piece),
	getMatrixElemAt(X, Y, Board, Cell),
	(Cell \= Piece -> nl, write('  Not your stone.'), fail;
	true).

validateMovePiece(SrcX, SrcY, DestX, DestY, Board):-
	DifX is abs(SrcX - DestX),
	DifY is abs(SrcY - DestY),
	DifX < 2,
	DifY < 2,
	getMatrixElemAt(DestX, DestY, Board, Cell),
	Cell == empty, !.

validateMovePiece(_, _, _, _, _):-
	nl, write('  Not a valid move.'), nl, fail.

checkCapture(X, Y, Board, ResultantBoard, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player):-
	getPieceColor(Player, PlayerPiece),
	(PlayerPiece = blue -> ToCapture = red, BlueStones > 0;
	PlayerPiece = red -> ToCapture = blue, RedStones > 0; fail), !,
	checkCaptureLeftUp(X, Y, Board, B1, PlayerPiece, ToCapture, BlueStones, RedStones, Bs1, Rs1),
	checkCaptureUp(X, Y, B1, B2, PlayerPiece, ToCapture, Bs1, Rs1, Bs2, Rs2),
	checkCaptureRightUp(X, Y, B2, B3, PlayerPiece, ToCapture, Bs2, Rs2, Bs3, Rs3),
	checkCaptureRight(X, Y, B3, B4, PlayerPiece, ToCapture, Bs3, Rs3, Bs4, Rs4),
	checkCaptureRightDown(X, Y, B4, B5, PlayerPiece, ToCapture, Bs4, Rs4, Bs5, Rs5),
	checkCaptureDown(X, Y, B5, B6, PlayerPiece, ToCapture, Bs5, Rs5, Bs6, Rs6),
	checkCaptureLeftDown(X, Y, B6, B7, PlayerPiece, ToCapture, Bs6, Rs6, Bs7, Rs7),
	checkCaptureLeft(X, Y, B7, ResultantBoard, PlayerPiece, ToCapture, Bs7, Rs7, UpdatedBs, UpdatedRs).

removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece):-
	(PlayerPiece = blue -> UpdatedBs = BlueStones - 1, UpdatedRs = RedStones + 1;
	PlayerPiece = red -> UpdatedRs = RedStones - 1, UpdatedBs = BlueStones + 1).

continueCheckCapture(PlayerPiece, BlueStones, RedStones):-
	(PlayerPiece = blue -> BlueStones > 0;
	PlayerPiece = red -> RedStones > 0; fail).

checkCaptureLeftUp(X, Y, Board, ResultantBoard, PlayerPiece, ToCapture, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
	X1 is X - 1, X1 > -1,
	Y1 is Y - 1, Y1 > -1,
	getMatrixElemAt(X1, Y1, Board, Cell1),
	Cell1 == ToCapture,
	X2 is X - 2, X2 > -1,
	Y2 is Y - 2, Y2 > -1,
	getMatrixElemAt(X2, Y2, Board, Cell2),
	Cell2 == PlayerPiece,
	setMatrixElemAtWith(X1, Y1, PlayerPiece, Board, ResultantBoard),
	removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece).

checkCaptureLeftUp(_, _, Board, ResultantBoard, _, _, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

checkCaptureUp(X, Y, Board, ResultantBoard, PlayerPiece, ToCapture, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
	X1 is X - 1, X1 > -1,
	getMatrixElemAt(X1, Y, Board, Cell1),
	Cell1 == ToCapture,
	X2 is X - 2, X2 > -1,
	getMatrixElemAt(X2, Y, Board, Cell2),
	Cell2 == PlayerPiece,
	setMatrixElemAtWith(X1, Y, PlayerPiece, Board, ResultantBoard),
	removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece).

checkCaptureUp(_, _, Board, ResultantBoard, _, _, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

checkCaptureRightUp(X, Y, Board, ResultantBoard, PlayerPiece, ToCapture, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
	X1 is X - 1, X1 > -1,
	Y1 is Y + 1, Y1 < 5,
	getMatrixElemAt(X1, Y1, Board, Cell1),
	Cell1 == ToCapture,
	X2 is X - 2, X2 > -1,
	Y2 is Y + 2, Y2 < 5,
	getMatrixElemAt(X2, Y2, Board, Cell2),
	Cell2 == PlayerPiece,
	setMatrixElemAtWith(X1, Y1, PlayerPiece, Board, ResultantBoard),
	removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece).

checkCaptureRightUp(_, _, Board, ResultantBoard, _, _, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

checkCaptureRight(X, Y, Board, ResultantBoard, PlayerPiece, ToCapture, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
	Y1 is Y + 1, Y1 < 5,
	getMatrixElemAt(X, Y1, Board, Cell1),
	Cell1 == ToCapture,
	Y2 is Y + 2, Y2 < 5,
	getMatrixElemAt(X, Y2, Board, Cell2),
	Cell2 == PlayerPiece,
	setMatrixElemAtWith(X, Y1, PlayerPiece, Board, ResultantBoard),
	removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece).

checkCaptureRight(_, _, Board, ResultantBoard, _, _, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

checkCaptureRightDown(X, Y, Board, ResultantBoard, PlayerPiece, ToCapture, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
	X1 is X + 1, X1 < 5,
	Y1 is Y + 1, Y1 < 5,
	getMatrixElemAt(X1, Y1, Board, Cell1),
	Cell1 == ToCapture,
	X2 is X + 2, X2 < 5,
	Y2 is Y + 2, Y2 < 5,
	getMatrixElemAt(X2, Y2, Board, Cell2),
	Cell2 == PlayerPiece,
	setMatrixElemAtWith(X1, Y1, PlayerPiece, Board, ResultantBoard),
	removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece).

checkCaptureRightDown(_, _, Board, ResultantBoard, _, _, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

checkCaptureDown(X, Y, Board, ResultantBoard, PlayerPiece, ToCapture, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
	X1 is X + 1, X1 < 5,
	getMatrixElemAt(X1, Y, Board, Cell1),
	Cell1 == ToCapture,
	X2 is X + 2, X2 < 5,
	getMatrixElemAt(X2, Y, Board, Cell2),
	Cell2 == PlayerPiece,
	setMatrixElemAtWith(X1, Y, PlayerPiece, Board, ResultantBoard),
	removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece).

checkCaptureDown(_, _, Board, ResultantBoard, _, _, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

checkCaptureLeftDown(X, Y, Board, ResultantBoard, PlayerPiece, ToCapture, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
	X1 is X + 1, X1 < 5,
	Y1 is Y - 1, Y1 > -1,
	getMatrixElemAt(X1, Y1, Board, Cell1),
	Cell1 == ToCapture,
	X2 is X + 2, X2 < 5,
	Y2 is Y - 2, Y2 > -1,
	getMatrixElemAt(X2, Y2, Board, Cell2),
	Cell2 == PlayerPiece,
	setMatrixElemAtWith(X1, Y1, PlayerPiece, Board, ResultantBoard),
	removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece).

checkCaptureLeftDown(_, _, Board, ResultantBoard, _, _, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

checkCaptureLeft(X, Y, Board, ResultantBoard, PlayerPiece, ToCapture, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
	Y1 is Y - 1, Y1 > -1,
	getMatrixElemAt(X, Y1, Board, Cell1),
	Cell1 == ToCapture,
	Y2 is Y - 2, Y2 > -1,
	getMatrixElemAt(X, Y2, Board, Cell2),
	Cell2 == PlayerPiece,
	setMatrixElemAtWith(X, Y1, PlayerPiece, Board, ResultantBoard),
	removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece).

checkCaptureLeft(_, _, Board, ResultantBoard, _, _, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.

checkCaptureLeft(_, _, _, _, _, _, _, _, _, _):-
	fail.


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
