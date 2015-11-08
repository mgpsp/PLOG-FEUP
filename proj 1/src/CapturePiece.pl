checkCapture(X, Y, Board, ResultantBoard, BlueStones, RedStones, UpdatedBs, UpdatedRs, Player):-
	getPieceColor(Player, PlayerPiece),
	(PlayerPiece = blue -> ToCapture = red;
	PlayerPiece = red -> ToCapture = blue; fail),
	checkCaptureLeftUp(X, Y, Board, B1, PlayerPiece, ToCapture, BlueStones, RedStones, Bs1, Rs1),
	checkCaptureUp(X, Y, B1, B2, PlayerPiece, ToCapture, Bs1, Rs1, Bs2, Rs2),
	checkCaptureRightUp(X, Y, B2, B3, PlayerPiece, ToCapture, Bs2, Rs2, Bs3, Rs3),
	checkCaptureRight(X, Y, B3, B4, PlayerPiece, ToCapture, Bs3, Rs3, Bs4, Rs4),
	checkCaptureRightDown(X, Y, B4, B5, PlayerPiece, ToCapture, Bs4, Rs4, Bs5, Rs5),
	checkCaptureDown(X, Y, B5, B6, PlayerPiece, ToCapture, Bs5, Rs5, Bs6, Rs6),
	checkCaptureLeftDown(X, Y, B6, B7, PlayerPiece, ToCapture, Bs6, Rs6, Bs7, Rs7),
	checkCaptureLeft(X, Y, B7, ResultantBoard, PlayerPiece, ToCapture, Bs7, Rs7, UpdatedBs, UpdatedRs).

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

removeOneStone(BlueStones, RedStones, UpdatedBs, UpdatedRs, PlayerPiece):-
	(PlayerPiece = blue -> UpdatedBs = BlueStones - 1, UpdatedRs = RedStones + 1;
	PlayerPiece = red -> UpdatedRs = RedStones - 1, UpdatedBs = BlueStones + 1).

continueCheckCapture(PlayerPiece, BlueStones, RedStones):-
	(PlayerPiece = blue -> BlueStones > 0;
	PlayerPiece = red -> RedStones > 0; fail).