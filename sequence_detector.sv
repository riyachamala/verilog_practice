// sequence pattern: 1011 -> moore machine
module sequence_detector (
  input clk, rst,
  input d,
  output match
);

  // S0: start (match = 0)
  // S1: 1 (match = 0)
  // S2: 10 (match = 0)
  // S3: 101 (match = 0)
  // S4: 1011 (match = 1)
  typedef enum logic [2:0] {S0, S1, S2, S3, S4} state_t; // 5 states, so 3 bits
  state_t state, next_state;

  // state movement conditions - sequential
  always_ff @(posedge clk) begin
    if (rst) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  // combinational next_state logic
  always_comb begin
    next_state = S0; // default state

    case(state)
      S0: next_state = d ? S1 : S0;
      S1: next_state = d ? S0 : S2;
      S2: next_state = d ? S3 : S0;
      S3: next_state = d ? S4 : S0;
      S4: next_state = S0;
    endcase
  end

  // assign statement for output
  assign match = (state == S4);
endmodule
