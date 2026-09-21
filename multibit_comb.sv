// 4-bit subtractor
// using two's complement: A - B = A + (-B)
// to get -B, invert all bits of B and add 1
module subtractor (
  input [3:0] a, b,
  output [3:0] diff,
  output overflow
);

  wire [3:0] neg_b;
  wire [4:0] sum;
  
  assign neg_b = (b ^ 4'b1111) + 4'd1; // invert b and add 1
  assign sum = a + neg_b;

  assign diff = sum[3:0];
  assign overflow = sum[4];
endmodule


// simple ALU, 4-bit
// 2-bit opcode determines operation, 00 -> ADD, 01 -> SUB, 10 -> AND, 11 -> OR
module alu (
  input [3:0] a, b, 
  input [1:0] opcode,
  output [3:0] result
  // output zero, carry, overflow
);
  always @(*) begin
    case(opcode)
      2'b00: result = a + b;
      2'b01: result = a - b;
      2'b10: result = a & b;
      2'b11: result = a | b;
      default: result = 4'b0;
    endcase
  end
endmodule

// 8-bit multiplier (unsigned)
module multiplier (
  input [7:0] a, b,
  output [15:0] result
);

  wire [15:0] mult0, mult1, mult2, mult3, mult4, mult5, mult6, mult7;
  assign mult0 = b[0] ? (a << 0) : 16'b0;
  assign mult1 = b[1] ? (a << 1) : 16'b0;
  assign mult2 = b[2] ? (a << 2) : 16'b0;
  assign mult3 = b[3] ? (a << 3) : 16'b0;
  assign mult4 = b[4] ? (a << 4) : 16'b0;
  assign mult5 = b[5] ? (a << 5) : 16'b0;
  assign mult6 = b[6] ? (a << 6) : 16'b0;
  assign mult7 = b[7] ? (a << 7) : 16'b0;

  assign result = mult0 + mult1 + mult2 + mult3 + mult4 + mult5 + mult6 + mult7;
endmodule

// 8-bit barrel shifter
module barrel_shifter (
  input [7:0] in,
  input [2:0] shift,
  output [7:0] out
);

  always @(*) begin
    case(shift)
      3'b000: out = in >> 0;
      3'b001: out = in >> 1;
      3'b010: out = in >> 2;
      3'b011: out = in >> 3;
      3'b100: out = in >> 4;
      3'b101: out = in >> 5;
      3'b110: out = in >> 6;
      3'b111: out = in >> 7;
      default: out = in >> 0;
    endcase
  end

endmodule

// parity generator
module parity_generator (
  input [7:0] in,
  input even,
  output reg parity_bit
);

  wire [3:0] add;
  wire modulus;

  assign add = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
  assign modulus = add % 4'b0010;

  always @(*) begin
    if (even) begin
      parity_bit = modulus ? 1 : 0;
    end
    else if (~even) begin
      parity_bit = modulus ? 0 : 1;
    end
  end
endmodule
