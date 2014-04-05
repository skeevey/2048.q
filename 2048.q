//2048
// X or \\ - Exit
// WASD

SIZE:4;
TARGET:2048;
BLOCK_POOL:2 2 2 2 2 2 2 2 2 4;

print:{show .state.universe};

push_row:{
	X:x where not 0 = x;
	X:raze (sum')each reverse each 2 cut/: reverse each (where differ X) cut X;
	(neg SIZE)#(SIZE#0),X where not 0 = X};

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

score:{sum raze .state.universe};

move:{
	d:(!) . flip (
		("U"; {flip reverse each push_row each reverse each flip x});
		("D"; {flip push_row each flip x});
		("L"; {reverse each push_row each reverse each x});
		("R"; {push_row each x})
		);
	`.state.universe set d[x] .state.universe;
	generate_piece[];
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
		[]]
	};

start:{
	`.state.universe set SIZE cut (SIZE*SIZE)#0;
	`.state.victorious set 0b;
	generate_piece[];
	print[];
	};

start[];
