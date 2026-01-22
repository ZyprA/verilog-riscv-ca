`default_nettype none
`include "m_alu.v"
`include "m_adder.v"
`include "m_am_imem.v"
`include "m_gen_imm.v"
`include "m_RF.v"
`include "m_mux.v"
`include "m_am_dmem.v"

module m_proc5(w_clk);
    // io
    input wire w_clk;

    // internal wires and regs
    reg [31:0] r_pc = 0;
    wire [31:0] w_npc, w_tpc, w_ir, w_imm, w_r1, w_r2, w_s2, w_alu, w_ldd, w_rt, w_pcin;
    wire w_r, w_i, w_s, w_b, w_u, w_j, w_ld, w_tkn;

    // internal modules
    m_adder m2 (32'h4, r_pc, w_npc);
    m_am_imem m3 (r_pc, w_ir);
    m_gen_imm m4 (w_ir, w_imm, w_r, w_i, w_s, w_b, w_u, w_j, w_ld);
    m_RF m5 (w_clk, w_ir[19:15], w_ir[24:20], w_r1, w_r2, w_ir[11:7], !w_s & !w_b, w_rt);
    m_adder m6 (w_imm, r_pc, w_tpc);
    m_mux m7 (w_r2, w_imm, !w_r & !w_b, w_s2);
    m_alu m8 (w_r1, w_s2, w_alu, w_tkn);
    m_am_dmem m9 (w_clk, w_alu, w_s, w_r2, w_ldd);
    m_mux m10 (w_alu, w_ldd, w_ld, w_rt);
    m_mux m11 (w_npc, w_tpc, w_b & w_tkn, w_pcin);
    always @(posedge w_clk) r_pc <= w_pcin; 

    // not used wire for detecting stop.
    wire w_halt = (!w_s & !w_b & w_ir[11:7]==5'd30);

endmodule