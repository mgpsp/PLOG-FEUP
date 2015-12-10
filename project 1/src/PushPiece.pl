% ============================== %
%           COUNT PIECES         %
% ============================== %

countPieces(_, X, Y, _, NumPieces, NumPieces, X, Y, _, _).

countPieces(Board, X, Y, Piece, NumPieces, Total, NextX, NextY, Dirx, Diry):-
	((X < 0 ; X > 4 ; Y < 0 ; Y > 4) -> Total is NumPieces, NextX is X, NextY is Y;
	getMatrixElemAt(X, Y, Board, Cell), !,
	Cell == Piece,
	NewNumber is NumPieces + 1,
	Y1 is Y + Diry,
	X1 is X + Dirx,
	countPieces(Board, X1, Y1, Piece, NewNumber, Total, NextX, NextY, Dirx, Diry)).

% ============================== %
%           PUSH PIECE           %
% ============================== %

validatePush(Board, X, Y, Player, Dirx, Diry):-
	getPieceColor(Player, PlayerPiece),
	countPieces(Board, X, Y, PlayerPiece, 0, PlayerPieces, LastX, LastY, Dirx, Diry),
	getNextPlayer(Player, Oponent),
	getPieceColor(Oponent, OponentPiece),
	countPieces(Board, LastX, LastY, OponentPiece, 0, OponentPieces, LastX1, LastY1, Dirx, Diry),
	PlayerPieces > OponentPieces,
	OponentPieces > 0,
	((LastX1 > -1, LastX1 < 5, LastY1 > -1, LastY1 < 5) -> getMatrixElemAt(LastX1, LastY1, Board, Cell), Cell == empty; true).

checkCaptured(Board, _, _, Board, Player, BlueStones, RedStones, BlueStones, RedStones):-
	getPieceColor(Player, PlayerPiece),
	\+((continueCheckCapture(PlayerPiece, BlueStones, RedStones))), !.

checkCaptured(Board, X, Y, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getPieceColor(Player, PlayerPiece),
	X1 is X - 1,
	X2 is X + 1,
	Y1 is Y - 1,
	Y2 is Y + 1,
	(
		(X1 >= 0, X2 < 5,
		getMatrixElemAt(X1, Y, Board, Cell), Cell == PlayerPiece,
		getMatrixElemAt(X2, Y, Board, Cell), Cell == PlayerPiece,
		setMatrixElemAtWith(X, Y, PlayerPiece, Board, NewBoard),
		removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece));

		(Y1 >= 0, Y2 < 5,
		getMatrixElemAt(X, Y1, Board, Cell), Cell == PlayerPiece,
		getMatrixElemAt(X, Y2, Board, Cell), Cell == PlayerPiece,
		setMatrixElemAtWith(X, Y, PlayerPiece, Board, NewBoard),
		removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece));

		(X1 >= 0, X2 < 5, Y1 >= 0, Y2 < 5,
		getMatrixElemAt(X1, Y1, Board, Cell), Cell == PlayerPiece,
		getMatrixElemAt(X2, Y2, Board, Cell), Cell == PlayerPiece,
		setMatrixElemAtWith(X, Y, PlayerPiece, Board, NewBoard),
		removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece));

		(X1 >= 0, X2 < 5, Y1 >= 0, Y2 < 5,
		getMatrixElemAt(X1, Y2, Board, Cell), Cell == PlayerPiece,
		getMatrixElemAt(X2, Y1, Board, Cell), Cell == PlayerPiece,
		setMatrixElemAtWith(X, Y, PlayerPiece, Board, NewBoard),
		removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece))
	).

checkCaptured(Board, _, _, Board, _, BlueStones, RedStones, BlueStones, RedStones).

addOneStone(Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	(Player == 'Blue' -> UpdatedRs is RedStones + 1, UpdatedBs is BlueStones;
	Player == 'Red' -> UpdatedBs is BlueStones + 1, UpdatedRs is RedStones).

pushPieces(Board, X, Y, Dirx, Diry, CurrentPiece, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	((\+((X >= 0, Y >= 0, X < 5, Y < 5)), addOneStone(Player, BlueStones, RedStones, BS, RS));
	(getMatrixElemAt(X, Y, Board, Cell), Cell == empty, setMatrixElemAtWith(X, Y, CurrentPiece, Board, NextBoard))),
	X1 is X - Dirx, Y1 is Y - Diry,
	(nonvar(BS) -> checkCaptured(NextBoard, X1, Y1, NewBoard, Player, BS, RS, UpdatedBs, UpdatedRs);
	checkCaptured(NextBoard, X1, Y1, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs)), !.

pushPieces(Board, X, Y, Dirx, Diry, CurrentPiece, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(X, Y, Board, NextPiece),
	setMatrixElemAtWith(X, Y, CurrentPiece, Board, NextBoard),
	checkCapture(X, Y, NextBoard, TmpBoard, BlueStones, RedStones, BS, RS, Player),
	X1 is X + Dirx,
	Y1 is Y + Diry,
	pushPieces(TmpBoard, X1, Y1, Dirx, Diry, NextPiece, NewBoard, Player, BS, RS, UpdatedBs, UpdatedRs).

pushPieces(Board, X, Y, Dirx, Diry, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	pushPieces(Board, X, Y, Dirx, Diry, empty, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs).