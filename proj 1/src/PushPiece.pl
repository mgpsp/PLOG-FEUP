% ============================== %
%           COUNT PIECES         %
% ============================== %

countPieces(_, X, Y, _, NumPieces, NumPieces, X, Y, [_, _]).

countPieces(Board, X, Y, Piece, NumPieces, Total, NextX, NextY, [Dirx, Diry]):-
	getMatrixElemAt(X, Y, Board, Cell), !,
	Cell == Piece,
	NewNumber is NumPieces + 1,
	Y1 is Y + Diry, Y1 >= 0, Y1 < 5,
	X1 is X + Dirx, X1 >= 0, X1 < 5,
	countPieces(Board, X1, Y1, Piece, NewNumber, Total, NextX, NextY, [Dirx, Diry]).

% ============================== %
%           PUSH PIECE           %
% ============================== %

validatePush(Board, X, Y, Player, [Dirx, Diry]):-
	getPieceColor(Player, PlayerPiece),
	countPieces(Board, X, Y, PlayerPiece, 0, PlayerPieces, LastX, LastY, [Dirx, Diry]),
	getNextPlayer(Player, Oponent),
	getPieceColor(Oponent, OponentPiece),
	countPieces(Board, LastX, LastY, OponentPiece, 0, OponentPieces, LastX1, LastY1, [Dirx, Diry]),
	nonvar(OponentPieces), nonvar(PlayerPieces),
	PlayerPieces > OponentPieces,
	OponentPieces > 0,
	((LastX1 > -1, LastX1 < 5, LastY1 > -1, LastY1 < 5) -> getMatrixElemAt(LastX1, LastY1, Board, Cell), Cell == empty).

pushPieceLeft(Board, X, Y, ResultantBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, PieceToSet):-
	getMatrixElemAt(X, Y, Board, NextPiece),
	setMatrixElemAtWith(X, Y, PieceToSet, Board, ResultantBoard), !,
	Y1 is Y - 1, Y1 > -1,
	%checkCapture(X, Y1, TmpBoard, ResultantBoard, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player),
	NextPiece \= empty,
	pushPieceLeft(ResultantBoard, X, Y1, _, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs, NextPiece).

pushPieceLeft(Board, _, 0, Board, _, BlueStones, RedStones, BlueStones, RedStones, _).

/*pushPieceLeft(Board, _, _, ResultantBoard, _, BlueStones, RedStones, UpdatedBs, UpdatedRs, _):-
	getMatrixElemAt(0, 0, Board, Cell),
	setMatrixElemAtWith(0, 0, Cell, Board, ResultantBoard),
	UpdatedBs is BlueStones,
	UpdatedRs is RedStones.*/

checkCaptured(Board, X, Y, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getPieceColor(Player, PlayerPiece),
	continueCheckCapture(PlayerPiece, BlueStones, RedStones),
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

move_pieces(Board, [X, Y], [Dirx, Diry], CurrentPiece, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	(\+((X >= 0, Y >= 0, X < 5, Y < 5));
	(getMatrixElemAt(X, Y, Board, Cell), Cell == empty, CurrentPiece == empty)),
	X1 is X - Dirx, Y1 is Y - Diry,
	checkCaptured(Board, X1, Y1, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs), !.

move_pieces(Board, [X, Y], [Dirx, Diry], CurrentPiece, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	getMatrixElemAt(X, Y, Board, NextPiece),
	setMatrixElemAtWith(X, Y, CurrentPiece, Board, NextBoard),
	X1 is X + Dirx,
	Y1 is Y + Diry,
	move_pieces(NextBoard, [X1, Y1], [Dirx, Diry], NextPiece, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs).

move_pieces(Board, [X, Y], [Dirx, Diry], NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs):-
	move_pieces(Board, [X, Y], [Dirx, Diry], empty, NewBoard, Player, BlueStones, RedStones, UpdatedBs, UpdatedRs).