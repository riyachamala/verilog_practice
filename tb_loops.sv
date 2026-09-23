module tb_loop;
  reg a, b, sel;
  wire out;
  reg expected;
  int test_num;

  mux2to1 dut (.a(a), .b(b), .sel(sel), .out(out));

  initial begin
    for (int i = 0; i < 8; i++) begin
      a = i[2];
      b = i[1];
      sel = i[0];
      #10;

      expected = sel ? b : a;
      test_num = i + 1;

      if (out == expected)
        $display("test %0d passed", test_num);
      else
        $display("test %0d failed", test_num);

    end
    $finish;
  end
endmodule
