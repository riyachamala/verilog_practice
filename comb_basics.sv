// 2:1 mux
module mux_2to1 (
  input sel,
  input a, b,
  output out
);
  // if sel = 0, then out = a
  // if sel = 1, then out = b
  assign out = sel ? b : a;

endmodule


// 4:1 mux
module mux_4to1 (
  input a, b, c, d,
  input [1:0] sel,
  output out
);

  always @(*) begin
    case(sel)
      2'b00: out = a;
      2'b01: out = b;
      2'b10: out = c;
      2'b11: out = d;
      default: out = 1'bx;
    endcase
  end
  
endmodule


// 4:1 mux
module mux_4to1 (
  input [3:0] data_in
  input [1:0] sel,
  output out
);
  assign out = data_in[sel]; // will convert itself since sel is defined as 2 bit
endmodule


// 8:1 mux
module mux_8to1 (
  input [7:0] data_in,
  input [2:0] sel,
  output out
);
  assign out = data_in[sel];
endmodule


// 1:4 demux
module demux_1to4 (
  input in,
  input [1:0] sel,
  output [3:0] out
);
  
  always @(*) begin
    out = 4'b0; // clear outputs
    
    case(sel)
      2'b00: out[0] = in;
      2'b01: out[1] = in;
      2'b10: out[2] = in;
      2'b11: out[3] = in;
      // default: out = 4'b0; - NO, PRESET OUT SO THAT ALL SPACES ARE FILLED AND NO LATCHES
    endcase
  end

endmodule

// half adder
module half_adder (
  input a, b,
  output c_out, sum
);

  assign sum = a ^ b;
  assign c_out = a & b;
endmodule

// full adder - uses the half adder
module full_adder (
  input a, b, cin,
  output c_out, sum
);
  wire c_out1, c_out2, sum1;
  
  half_adder ha1 (.a(a), .b(b), .c_out(c_out1), .sum(sum1));
  half_adder ha2 (.a(sum1), .b(cin), .c_out(c_out2), .sum(sum));
  assign c_out = c_out1 | c_out2;
endmodule


// full adder
module full_adder (
  input a, b, cin,
  output c_out, sum
);
  assign sum = a ^ b ^ cin;
  assign c_out = a & b | cin & (a ^ b);
endmodule


// 4-bit ripple carry adder
module ripple_adder (
  input [3:0] a, b,
  input cin,
  output [3:0] sum,
  output c_out
);
  wire c0, c1, c2;
  
  full_adder f0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .c_out(c0));
  full_adder f1 (.a(a[1]), .b(b[1]), .cin(c0), .sum(sum[1]), .c_out(c1));
  full_adder f2 (.a(a[2]), .b(b[2]), .cin(c1), .sum(sum[2]), .c_out(c2));
  full_adder f3 (.a(a[3]), .b(b[3]), .cin(c2), .sum(sum[3]), .c_out(c_out));
endmodule

// simple 4-bit comparator
module comparator (
  input [3:0] a, b,
  output a_gt_b, a_eq_b, a_lt_b
);
  assign a_gt_b = (a[3] > b[3]) | 
    (a[3] == b[3]) & (a[2] > b[2]) | 
    (a[3] == b[3]) & (a[2] == b[2]) & (a[1] > b[1]) | 
    (a[3] == b[3]) & (a[2] == b[2]) & (a[1] == b[1]) & (a[0] > b[0]);
  
  assign a_eq_b = (a[3] == b[3]) & (a[2] == b[2]) & (a[1] == b[1]) & (a[0] == b[0]);
  assign a_lt_b = (a_gt_b | a_eq_b) ? 0 : 1;
endmodule

// priority encoder, 8:3
module priority_encoder (
  input [7:0] in,
  input en,
  output [2:0] out,
  output valid
);
  always @(*) begin
    if (~en) begin
      out = 3'b0;
      valid = 1'b0;
    end
    
    else if (in[7] == 1) out = 3'b111;
    else if (in[6] == 1) out = 3'b110;
    else if (in[5] == 1) out = 3'b101;
    else if (in[4] == 1) out = 3'b100;
    else if (in[3] == 1) out = 3'b011;
    else if (in[2] == 1) out = 3'b010;
    else if (in[1] == 1) out = 3'b001;
    else if (in[0] == 1) out = 3'b000;
    else out = 3'b0;

    if (en) begin
      valid = |in; // true if any input is high
    end
  end

endmodule
      
// 3:8 decoder
module decoder (
  input [2:0] in,
  input en,
  output [7:0] out,
  output valid
);

  always @(*) begin
    if (~en) begin
      out = 8'b0;
      valid = 1'b0;
    end
    else begin
      out = 8'b0; // KEEP FORGETTING TO SET A DEFAULT!!
      case(in)
        3'b000: out[0] = 1'b1;
        3'b001: out[1] = 1'b1;
        3'b010: out[2] = 1'b1;
        3'b011: out[3] = 1'b1;
        3'b100: out[4] = 1'b1;
        3'b101: out[5] = 1'b1;
        3'b110: out[6] = 1'b1;
        3'b111: out[7] = 1'b1;
      endcase

      valid = |out;
    end
  end
endmodule

// 8:3 encoder (normal) - THE DIFFERENCE IS THAT U CAN USE CASES SINCE ONLY ONE INPUT SHOULD BE ON.
module encoder (
  input [7:0] in,
  input en,
  output valid,
  output [2:0] out
);

  always @(*) begin
    if (~en) begin
      valid = 1'b0;
      out = 3'b0;
    end
    else begin
      out = 3'b0;
      case(in)
        8'b00000001: out = 3'b000;
        8'b00000010: out = 3'b001;
        8'b00000100: out = 3'b010;
        8'b00001000: out = 3'b011;
        8'b00010000: out = 3'b100;
        8'b00100000: out = 3'b101;
        8'b01000000: out = 3'b110;
        8'b10000000: out = 3'b111;
      endcase

      valid = |in;
    end
  end
endmodule
