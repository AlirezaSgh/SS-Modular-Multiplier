module ssm #(parameter LEN = 32)(clk, rst, start, a_in, b_in, n_in, ready, p_out);
    input clk, rst, start;
    input [LEN-1:0] a_in, b_in, n_in;
    output ready;
    output[LEN-1:0] p_out;

    wire ready, clr_dp, ld_a, ld_b, ld_n, ld_p, 
         p_src, addr_src1_sel, addr_src2_sel, shr_b, shl_a, cen,
         co, b_i, n_lt_sel, clr_p;
    wire [1:0] src_a;

    ssm_dp #(LEN) dp (clk, rst, a_in, b_in, n_in, ld_a, ld_b, ld_n, ld_p, clr_dp,
                      clr_p, src_a, shl_a, shr_b, addr_src1_sel, addr_src2_sel, 
                      p_src, cen,
                      n_lt_sel, b_i, co, p_out);
    ssm_sm        sm (clk, rst, start, co, b_i, n_lt_sel, ready, clr_dp, clr_p, ld_a, ld_b, ld_n, ld_p, 
                      p_src, addr_src1_sel, addr_src2_sel, shr_b, shl_a, cen, src_a);
endmodule