`include "m_adder.v"
`include "m_am_imem.v"
`include "m_RF.v"
`include "m_gen_imm.v"
`include "m_mux.v"
`include "m_am_dmem.v"

module m_proc4(w_clk);
    input wire w_clk;
    wire [31:0] w_npc, w_ir, w_r1, w_r2, w_imm, w_s2, w_alu, w_ldd, w_rt;
    wire w_r, w_i, w_s, w_b, w_u, w_j, w_ld;
    reg [31:0] r_pc = 0;
    m_adder m2 (32'h4, r_pc, w_npc);
    m_am_imem m3 (r_pc, w_ir);
    m_gen_imm m4 (w_ir, w_imm, w_r, w_i, w_s, w_b, w_u, w_j, w_ld);
    m_RF m5 (w_clk, w_ir[19:15], w_ir[24:20], w_r1, w_r2, w_ir[11:7], !w_s, w_rt);
    m_mux m6 (w_r2, w_imm, !w_r, w_s2);
    m_adder m7 (w_r1, w_s2, w_alu);
    m_am_dmem m8 (w_clk, w_alu, w_s, w_r2, w_ldd);
    m_mux m9 (w_alu, w_ldd, w_ld, w_rt);
    always @(posedge w_clk) r_pc <= w_npc;
endmodule