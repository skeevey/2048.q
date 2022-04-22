//2048
// X or \\ - Exit
// WASD

SIZE:4;
TARGET:2048;
BLOCK_POOL:2 2 2 2 2 2 2 2 2 4;
HELP_MESSAGE:"
	2048.q - Combine blocks to reach 2048

	Controls:
	W - up
	A - left
	S - down
	D - right\n";

print:{
	-1@("Moves: ", (-6$string .state.moves), " Score: ", -6$string .state.score);
	show .state.universe
	};

push_row:{
	X:x where not 0 = x;
	X:raze (sum')each reverse each 2 cut/: reverse each (where differ X) cut X;
	(neg SIZE)#(SIZE#0),X where not 0 = X};

push_board:(!) . flip (
	("U"; {flip reverse each push_row each reverse each flip x});
	("D"; {flip push_row each flip x});
	("L"; {reverse each push_row each reverse each x});
	("R"; {push_row each x})
	);

generate_piece:{
	blanks:where each 0 = .state.universe;
	r:rand where not 0 = count each blanks;
	if[null r;:0N];
	c:rand blanks r;
	.state.universe[r;c]:rand BLOCK_POOL;
	};

check_win:{any TARGET <= raze .state.universe};

check_stuck:{
	(all 0 <> raze .state.universe) and
	(all raze all''[differ''[flip scan .state.universe]])};

refresh_stats:{
	.state.moves +: 1;
	.state.score +: score_board[x] .state.multiverse; 
	};

score:{sum raze .state.universe};  
score_row:{
	X:x where not 0 = x;
	({$[2 = count x;sum x;0]}')each reverse each 2 cut/: reverse each (where differ X) cut X
	};
score_board:(!) . flip (
	("U"; {sum (raze/) score_row each reverse each flip x});
	("D"; {sum (raze/) score_row each flip x});
	("L"; {sum (raze/) score_row each reverse each x});
	("R"; {sum (raze/) score_row each x})
	);


move:{
	`.state.multiverse set .state.universe;
	`.state.universe set push_board[x] .state.universe;
	$[not .state.multiverse ~ .state.universe;  [refresh_stats[x]; generate_piece[]]; 
		[]];
	print[];
	if[check_win[];   win[]];
	if[check_stuck[]; lose[]];
	};

win:{
	if[not .state.victorious;
		`.state.victorious set 1b;
		-1@"Well done, you win";]};
lose:{-1@$[.state.victorious;"Stuck";"Oops, you lose"]; system"x .z.pi"};

.z.pi:{
	$[
		x like "\\*";   [value x];
		x like "[xX]*"; [exit 0;];
		x like "[wW]*"; [move "U"];
		x like "[aA]*"; [move "L"];
		x like "[sS]*"; [move "D"];
		x like "[dD]*"; [move "R"];
		[] ]
	};

start:{
	`.state.universe set SIZE cut (SIZE*SIZE)#0;
	`.state.victorious set 0b;
	`.state.moves set 0j;
	`.state.score set 0j;
	system"S ",-5 sublist string `int$.z.t;
	-1@HELP_MESSAGE;
	generate_piece[];
	`.state.multiverse set .state.universe;
	print[];
	};

test:{
	//`.state.universe set (2 4 8 16;4 8 16 2;0 0 0 0;0 0 0 0); // test no_update
	//`.state.universe set (2 4 8 16;2 4 8 32;2 4 0 0;2 0 8 0); // test score_update
	`.state.universe set (2 0 0 0;2 0 0 0;2 0 0 0;0 0 0 0); // test no_update
	print[];
	show("attempt moving up");
	move "U";  // invalid move, nothing should happen
	};


start[];
//test[];
