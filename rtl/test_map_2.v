module \$_DLATCH_N_ (input E, input D, output Q);
  $_DFFSR_PPP_ _TECHMAP_REPLACE2_ (
  	.C(1'b0),
  	.D(1'b0),
  	.S(!E && D),
  	.R(!E && !D),
  	.Q(Q)
  );
endmodule