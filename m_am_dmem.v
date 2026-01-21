module m_am_dmem(w_clk, w_adr, w_we, w_wd, w_rd);
    input wire [31:0] w_adr, w_wd;
    input wire w_clk, w_we;
    output wire [31:0] w_rd;
    reg [31:0] mem [63:0]; // only 64 words
    assign w_rd = mem[w_adr[7:2]]; // maybe first 2 bits are for byte offset
    always @(posedge w_clk) if (w_we) mem[w_adr[7:2]] <= w_wd;
    integer i; initial for (i=0;i<64;i=i+1) mem[i] = 32'd0;
endmodule