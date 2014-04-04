//2048

SIZE:4;
TARGET:2048;

.state.universe:SIZE cut (SIZE*SIZE)#0N;

print:{show .state.universe};

generate_piece:{
		blanks:where each null .state.universe;
		r:rand where not 0 = count each blanks;
		if[null r;'`gameover];
		c:rand blanks r;
		.state.universe[r;c]:rand 2 4;
		};

check_win:{any TARGET = raze .state.universe};

/
.z.pi:{$[
		x like "[xX]*"; [exit 0;];
		x like "[wW]*"; [];
		x like "[aA]*"; [];
		x like "[sS]*"; [];
		x like "[dD]*"; [];
		[]]
	};
