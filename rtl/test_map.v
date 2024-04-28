module \$_DLATCH_P_ (input E, input D, output Q);
  $_DFFSR_PPP_ _TECHMAP_REPLACE_ (
  	.C(1'b0),
  	.D(1'b0),
  	.S(E && D),
  	.R(E && !D),
  	.Q(Q)
  );
endmodule