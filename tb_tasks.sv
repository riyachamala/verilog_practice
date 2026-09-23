module tb_mux;
  reg a, b, sel;
  wire out;

  mux2to1 dut(.a(a), .b(b), .sel(sel), .out(out));

  // create tasks BEFORE the initial test run
  task run_test(input test_a, test_b, test_sel, input string test_name);
    a = test_a;
    b = test_b;
    sel = test_sel;

    #10;

    logic expected = sel ? b : a;
    if (out == expected)
      $display("%s passed", test_name);
    else
      $display("%s failed", test_name);
  endtask

  // now run tests
  initial begin
    run_test(0, 0, 0, "test 1: a = 0, b = 0, sel = 0");
    run_test(0, 0, 1, "test 1: a = 0, b = 0, sel = 1");
    run_test(0, 1, 0, "test 1: a = 0, b = 1, sel = 0");
    run_test(0, 1, 1, "test 1: a = 0, b = 1, sel = 1");
    run_test(1, 0, 0, "test 1: a = 1, b = 0, sel = 0");
    run_test(1, 0, 1, "test 1: a = 1, b = 0, sel = 1");
    run_test(1, 1, 0, "test 1: a = 1, b = 1, sel = 0");
    run_test(1, 1, 1, "test 1: a = 1, b = 1, sel = 1");

    $finish;
  end
endmodule
