// simple 2-floor elevator

// states: FLOOR1, FLOOR2, MOVINGUP, MOVINGDOWN
// FLOOR1 -> req2 -> MOVINGUP
// MOVINGUP -> at2 -> FLOOR2
// FLOOR2 -> req1 -> MOVINGDOWN
// MOVINGDOWN -> at1 -> FLOOR1

module elevator (
  input clk, rst,
  input req1, req2, at1, at2,
  output motor_up, motor_down, door_open
);

  typedef enum logic [1:0] {MOVINGUP, MOVINGDOWN, FLOOR1, FLOOR2} state_t;
  state_t state, next_state;

  // set up state register movement
  always_ff @(posedge clk) begin
    if (rst) begin
      state <= FLOOR1; // default
    end else begin
      state <= next_state; // pushes us to move through the fsm
    end
  end

  // set up combinational next_state logic
  always_comb begin
    next_state = state; // default set up
    case (state)
      FLOOR1: if (req2) next_state = MOVINGUP;
      MOVINGUP: if (at2) next_state = FLOOR2;
      FLOOR2: if (req1) next_state = MOVINGDOWN;
      MOVINGDOWN: if (at1) next_state = FLOOR1;
    endcase
  end

  // output logic
  assign motor_up = (state == MOVINGUP);
  assign motor_down = (state == MOVINGDOWN);
  assign door_open = (state == FLOOR1) || (state == FLOOR2);
endmodule
