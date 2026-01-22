`default_nettype none
`include "m_mux.v"
`include "m_am_imem.v"
`include "m_adder.v"
`include "m_RF.v"
`include "m_gen_imm.v"
`include "m_alu.v"
`include "m_am_dmem.v"

module m_proc8m(w_clk);
    input wire w_clk;

    wire [31:0] w_pcin, w_ir, w_r1, w_r2, w_s2, w_in1, w_in2, w_in3, w_alu, w_ldd, w_rt, w_imm, w_tpc, w_npc;
    wire w_r, w_i, w_s, w_b, w_u, w_j, w_ld, w_tkn;
    wire w_f = !P3_s & !P3_b & |P3_rd;
    reg [31:0] r_pc=0, P1_ir = 32'h13, P1_pc=0, P2_pc=0, P3_pc=0, P2_r1=0, P2_s2=0, P2_r2=0, P3_alu=0, P3_ldd=0, P2_tpc=0;
    reg [4:0] P2_rd=0, P3_rd=0, P2_rs1=0, P2_rs2=0;
    reg P2_r=0, P2_s=0, P2_b=0, P2_ld=0, P3_s=0, P3_b=0, P3_ld=0;
    
    m_mux m0 (w_npc, P2_tpc, P2_b & w_tkn, w_pcin);
    m_adder m2 (32'h4, r_pc, w_npc);
    m_am_imem m3 (r_pc, w_ir);
    m_gen_imm m4 (P1_ir, w_imm, w_r, w_i, w_s, w_b, w_u, w_j, w_ld);
    m_RF m5 (w_clk, P1_ir[19:15], P1_ir[24:20], w_r1, w_r2, P3_rd, !P3_s & !P3_b, w_rt);
    m_adder m6 (w_imm, P1_pc, w_tpc);
    m_mux m7 (w_r2, w_imm, !w_r & !w_b, w_s2);
    m_alu m8 (w_in1, w_in2, w_alu, w_tkn);
    m_am_dmem m9 (w_clk, w_alu, P2_s, w_in3, w_ldd);
    m_mux m10 (P3_alu, P3_ldd, P3_ld, w_rt);
    m_mux m11 (P2_r1, w_rt, w_f & P2_rs1==P3_rd, w_in1);
    m_mux m12 (P2_s2, w_rt, w_f & P2_rs2==P3_rd & (P2_r|P2_b), w_in2);
    m_mux m13 (P2_r2, w_rt, w_f & P2_rs2==P3_rd, w_in3);

    always @(posedge w_clk) begin
        {r_pc,P1_ir,P1_pc} <= {w_pcin, w_ir, r_pc};
        {P2_r1,P2_s2,P2_r2,P2_rd,P2_tpc,P2_rs2,P2_rs1,P2_r,P2_s,P2_b,P2_ld,P2_pc} <= {w_r1,w_s2,w_r2,P1_ir[11:7],w_tpc,P1_ir[24:15],w_r,w_s,w_b,w_ld,P1_pc};
        {P3_alu,P3_ldd,P3_rd,P3_s,P3_b,P3_ld,P3_pc} <= {w_alu,w_ldd,P2_rd,P2_s,P2_b,P2_ld,P2_pc};
    end
endmodule