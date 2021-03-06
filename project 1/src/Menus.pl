mainMenu:-
	clrscr,
	write('       :: Sixteen Stone ::       '), nl,
	write('                                 '), nl,
	write('   1. Player vs. Player          '), nl,
	write('   2. Player vs. Computer        '), nl,
	write('   3. Computer vs. Computer      '), nl,
	write('   4. About                      '), nl,
	write('   5. Exit                       '), nl,
	write('                                 '), nl,
	write('   > '),
	getChar(OP), (
		OP = '1' -> middleState(Board), fillBoard(Board, 0, 0, 'Blue');
		OP = '2' -> pvc, mainMenu;
		OP = '3' -> pvc, mainMenu;
		OP = '4' -> aboutMenu, mainMenu;
		OP = '5';
		mainMenu).

aboutMenu:-
	clrscr,
	write('       :: About ::               '), nl,
	write('                                 '), nl,
	write('   Authors:                      '), nl,
	write('      - Miguel Pereira           '), nl,
	write('      - Pedro Silva              '), nl,
	write('                                 '), nl,
	write('   Press Enter to continue...    '),
	get_char(_).

pvc:-
	clrscr,
	write('  Not implemented.'), nl,
	write('  Press Enter to return...'),
	get_char(_).
			