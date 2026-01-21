`include "m_proc4.v"

module m_top();
    reg r_clk = 0;
    initial #150 forever # 50 r_clk =~ r_clk;
    m_proc4 m (r_clk);
    initial begin
        m.m3.mem[0] = {12'd7, 5'd0, 3'd0, 5'd1, 7'h13};
        m.m3.mem[1] = {7'd0, 5'd1, 5'd0, 3'h2, 5'd8, 7'h23};
        m.m3.mem[2] = {12'd8, 5'd0, 3'b010, 5'd3, 7'h3};
    end
    initial #99 forever #100 $display("%3d %d %d %d %h", $time, m.w_r1, m.w_s2, m.w_rt, m.w_ir);
    initial #400 $finish;
endmodule