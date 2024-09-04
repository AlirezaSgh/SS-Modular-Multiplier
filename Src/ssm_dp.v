module ssm_dp #(parameter LEN = 32) (clk, rst, a_in, b_in, n_in, ld_a, ld_b, ld_n, ld_p, clr_dp,
                                     clr_p, src_a, shl_a, shr_b, addr_src1_sel, addr_src2_sel, 
                                     p_src, cen,
                                     n_lt_sel, b_i, co, p_out);
    input clk, rst, ld_a, ld_b, ld_n, ld_p, clr_dp, clr_p, shl_a, shr_b, addr_src1_sel, addr_src2_sel, p_src, cen;
    input [1:0] src_a;
    input [LEN-1:0] a_in, b_in, n_in;
    output b_i, n_lt_sel, co;
    output [LEN-1:0] p_out;

    wire signed[LEN:0] selected_a, selected_p, adder_out, A, N, B;
    wire signed[LEN:0] selected_src1, selected_src2;
    wire [$clog2(LEN)-1:0] count;
    // Mux:
    assign selected_a = (src_a == 2'd2) ? {1'b0, a_in} :
                        (src_a == 2'd1) ? adder_out :
                        A;
    assign selected_src1 = (addr_src1_sel) ? A : p_out;
    assign selected_src2 = (addr_src2_sel) ? (~{1'b0,N} + 1) : A;
    assign selected_p = (p_src) ? adder_out : p_out;

    // Adder:
    assign adder_out = selected_src1 + selected_src2;

    // Comparator:
    assign n_lt_sel = (N < selected_src1) ? 1'b1 : 1'b0;

    assign b_i = B[0];

    // Registors:
    sh_reg #(LEN + 1) A_reg (clk, rst, clr_dp, shl_a, 1'b0, ld_a, selected_a, A),
                      B_reg (clk, rst, clr_dp, 1'b0 , shr_b, ld_b, {1'b0, b_in}, B),
                      N_reg (clk, rst, clr_dp, 1'b0 , 1'b0, ld_n, {1'b0, n_in}, N),
                      P_reg (clk, rst, clr_p, 1'b0 , 1'b0, ld_p, selected_p, p_out);

    Counter #(LEN) cntr (clk, cen, rst, clr_dp, co, count);
endmodule  