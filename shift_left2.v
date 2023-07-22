`timescale 1 ps / 100 fs
//SIGN EXTENSION
module sign_extend(sOut32,sIn16);
output [31:0] sOut32;
input [15:0] sIn16;
assign sOut32 = {{16{sIn16[15]}},sIn16};
endmodule
//SHIFT LEFT 2 MODULE
module shift_left_2(Out32, In32);
output [31:0] Out32;
input [31:0] In32;

assign Out32 = {In32[29:0],2'b00};
endmodule