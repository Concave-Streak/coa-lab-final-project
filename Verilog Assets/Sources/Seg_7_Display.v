module seg_disp(
	input [31:0] x,
    input clk,
    output reg [6:0] seg,
    output reg [7:0] an,
    output wire dp 
	 );
	 
	 
wire [2:0] s;	 
reg [3:0] digit;
wire [7:0] aen;
reg [19:0] clkdiv;

assign dp = 1;
assign s = clkdiv[19:17];
assign aen = 8'b11111111; // all turned off initially

// quad 4to1 MUX.


always @(posedge clk)// or posedge clr)
	
	case(s)
	0:digit = x[3:0];
	1:digit = x[7:4]; 
	2:digit = x[11:8]; 
	3:digit = x[15:12]; 
	4:digit = x[19:16];
    5:digit = x[23:20];
    6:digit = x[27:24]; 
    7:digit = x[31:28]; 

	default:digit = x[3:0];
	
	endcase
	
	//decoder or truth-table for 7seg display values
	always @(*)

case(digit)


//////////<---MSB-LSB<---
//////////////gfedcba////////////////////////////////////////////           a
0:seg = 7'b1000000;////0000												   __					
1:seg = 7'b1111001;////0001												f/	  /b
2:seg = 7'b0100100;////0010												  g
//                                                                       __	
3:seg = 7'b0110000;////0011										 	 e /   /c
4:seg = 7'b0011001;////0100										       __
5:seg = 7'b0010010;////0101                                            d  
6:seg = 7'b0000010;////0110
7:seg = 7'b1111000;////0111
8:seg = 7'b0000000;////1000
9:seg = 7'b0010000;////1001
'hA:seg = 7'b0001000; 
'hB:seg = 7'b0000011; 
'hC:seg = 7'b1000110;
'hD:seg = 7'b0100001;
'hE:seg = 7'b0000110;
'hF:seg = 7'b0001110;

default: seg = 7'b0000000; // U

endcase


always @(*)begin
an=8'b11111111;
if(aen[s] == 1)
an[s] = 0;
end


//clkdiv

always @(posedge clk) begin
clkdiv <= clkdiv+1;
end


endmodule




module bin32_to_bcd(
   input [31:0] bin,   // 32-bit binary input
   output reg [31:0] bcd // 32-bit BCD output (8 BCD digits)
);
   
integer i;
	
always @(bin) begin
    bcd = 0; 		 	
    for (i = 0; i < 32; i = i + 1) begin					// Iterate once for each bit in input number
        if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;	// Add 3 to BCD digits if >= 5
        if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
        if (bcd[11:8] >= 5) bcd[11:8]  = bcd[11:8]  + 3;
        if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
        if (bcd[19:16] >= 5) bcd[19:16] = bcd[19:16] + 3;
        if (bcd[23:20] >= 5) bcd[23:20] = bcd[23:20] + 3;
        if (bcd[27:24] >= 5) bcd[27:24] = bcd[27:24] + 3;
        if (bcd[31:28] >= 5) bcd[31:28] = bcd[31:28] + 3;
        bcd = {bcd[30:0], bin[31-i]};				// Shift one bit left, insert bit from input binary
    end
end

endmodule