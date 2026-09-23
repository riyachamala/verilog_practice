module stopwatch (
  input clk, rst, start, stop, clear,
  output reg [15:0] counter,
  output running
);

  typedef enum logic [1:0] {IDLE, COUNTING, STOPPED} state_t;
  state_t state, next_state;

  always_ff @(posedge clk) begin
    if (rst) begin
      counter <= 1'b0;
      state <= IDLE;
    end else begin
      state <= next_state;

      case(state)
        IDLE: counter <= 1'b0;
        COUNTING: counter <= counter + 1'b1;
        default: ;
      endcase
    end
  end

  always_comb begin
    next_state = state;
    case(state)
      IDLE: if (start) next_state = COUNTING;
      COUNTING: if (stop) next_state = STOPPED;
      STOPPED: if (clear) next_state = IDLE;
      else if (start) next_state = COUNTING;
      default: next_state = IDLE;
    endcase
  end

  assign running = (state == COUNTING);
endmodule
