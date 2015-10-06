printCell(empty, ' ').
printCell(red, 'R').
printCell(blue, 'B').

state(A):-
	A = [[empty, blue, empty, red, empty],
		[blue, blue, empty, empty, empty],
		[red, blue, red, empty, empty],
		[empty, empty, empty, empty, empty],
		[blue, red, red, blue, empty]].