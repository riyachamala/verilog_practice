module traffic_light (
  input clk, rst,
  output red_light, green_light, yellow_light
);

  typedef enum logic [1:0] {RED, GREEN, YELLOW} state_t;
  state_t state, next_state;
  reg count;
  
  wire done;
  assign done = (count == 1'b1);

  // set up when the states actually change, so both clk & 2 cycles
  always_ff @(posedge clk) begin
    if (rst) begin
      state <= RED; // set as initial state
      count <= 1'b0;
    end else begin
      if (done) begin
        state <= next_state;
        count <= 1'b0;
      end else begin
        count <= 1'b1;
      end
    end
  end

  // combinational logic for state changes
  always_comb begin
    next_state = state;

    if (done) begin
      case(state)
        RED: next_state = GREEN;
        GREEN: next_state = YELLOW;
        YELLOW: next_state = RED;
      endcase
    end
  end

  // assign output logic
  assign red_light = (state == RED);
  assign green_light = (state == GREEN);
  assign yellow_light = (state == YELLOW);
endmodule
