// SR latch
module sr_latch (
  input set, reset,
  output reg q, q_c
);

  always @(*) begin
    if (reset) begin
      q = 1'b0;
      q_c = 1'b1;
    end else if (set) begin
      q = 1'b1;
      q_c = 1'b0;
    end
  end
endmodule

// D-FF w/ reset (active high)
module d_ff (
  input d, clk, rst,
  output reg q // use reg since q is defined inside an always block
);

  always @(posedge clk) begin
    if (rst) begin
      q <= 1'b0;
    end else begin
      q <= d;
    end
  end
endmodule

// 4-bit left shift register (serial-in, parallel-out)
module shift_reg_l (
  input d, clk, rst,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (rst) begin
      q <= 4'b0000;
    end else begin
      q <= {q[2:0], d};
    end
  end
endmodule


// 4-bit shift reg (serial-in, parallel-out), choose left or right shift
module shift_reg (
  input d, clk, rst, left, // if left = 1, then left shift, if left = 0, then right shift
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (rst) begin
      q <= 4'b0;
    end else begin
      if (left) begin
        q <= {q[2:0], d};
      end else if (~left) begin
        q <= {d, q[3:1]};
      end
    end
  end
endmodule

// 8-bit left shift reg (parallel-in, serial-out)
module parallelin_shift_reg (
  input [3:0] p,
  input clk, rst, load, // load = 0, then shift right, load = 1, load all values
  output serial_out
);

  reg [3:0] q;
  
  always @(posedge clk) begin
    if (rst) begin
      q <= 4'b0;
    end else begin
      if (load) begin
        q <= p;
      end else if (~load) begin
        q <= {1'b0, q[3:1]};
      end
    end
  end

  assign serial_out = q[0];
endmodule

// 4-bit left ring counter
module ring_counter (
  input clk, rst,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (rst) begin
      q <= 4'b0001;
    end else begin
      q <= {q[2:0], q[3]};
    end
  end
endmodule
