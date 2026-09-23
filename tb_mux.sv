module tb_mux;
  reg a, b, sel;
  wire out;

  // instantiate dut
  mux2to1 dut (.a(a), .b(b), .sel(sel), .out(out));

  // testcode
  initial begin
    // test 1: sel = 0, should output a
    a = 0; b = 1; sel = 0;
    #10;

    // these are ASSERTIONS
    if (out == a)
      $display("test 1 passed");
    else
      $display("test 1 failed");

    // test 2: sel = 1, should output b
    a = 0; b = 1; sel = 1;
    #10;
    
    if (out == b)
      $display("test 2 passed");
    else
      $display("test 2 failed");

    // test 3: sel = 0, should output a
    a = 1; b = 0; sel = 0;
    #10;
    
    if (out == a)
      $display("test 1 passed");
    else
      $display("test 1 failed");
    
    // test 4: sel = 1, should output b
    a = 1; b = 0; sel = 1;
    #10;
    
    if (out == b)
      $display("test 1 passed");
    else
      $display("test 1 failed");

    $finish;
  end
endmodule
