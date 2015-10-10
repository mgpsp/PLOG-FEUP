printCell(empty, ' ').
printCell(red, 'R').
printCell(blue, 'B').

middleState(A):-
	A = [[empty, blue, empty, red, empty],
		[empty, red, empty, empty, empty],
		[red, red, red, empty, empty],
		[empty, empty, empty, empty, empty],
		[empty, red, red, empty, empty]].