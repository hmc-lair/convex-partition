param n integer > 0;
	set S := 0 .. n - 1;
	set SS := 0 .. 2**n - 1;
	set POW {k in SS} := {i in S: (k div 2**i) mod 2 = 1};
