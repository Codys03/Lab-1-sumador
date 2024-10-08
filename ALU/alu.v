`include "sum4b.v"
`include "Restador.v"
`include "mult.v"

module alu(
        input clk,   
        input [3:0] A, 
		input [3:0] B, 
		input [1:0] OP, 
		input  sel,
		input  init,
		output Signo,
		output done,
		output C_out,
		output C_out_s,
		output reg [5:0]resul,
		output [14:0] dis
    );

	wire [3:0] resul_sum;
	wire [3:0] resul_res;
	wire [5:0] resul_mult;
	wire [2:0] r_bitsA;
	wire [2:0] r_bitsB;
	assign r_bitsA = A[2:0];
	assign r_bitsB = B[2:0];
	
	sum4b s0(.A(A), .B(B), .Ci('b0), .Cout(C_out_s), .Sum(resul_sum));
	Restador r0(.A(A), .B(B), .Resultado(resul_res), .Signo(Signo), .sel(sel), .C_out(C_out));
	multiplicador m0(.clk(clk), .init(init), .MR(r_bitsA), .MD(r_bitsB), .done(done), .pp(resul_mult)) ;
	decoder deco(.num(resul),.Sseg(dis));


    always @(*) begin
		case (OP)
			2'b00: resul <={2'b0, resul_sum};
			2'b01: resul <= {2'b0, resul_res};
			2'b10: resul <= resul_mult;
			2'b11: resul <= 'b00000;
			default: resul <= 'b00000;
		endcase
	end


endmodule