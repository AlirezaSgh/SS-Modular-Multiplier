module ssm_sm(clk, rst, start, co, b_i, n_lt_sel, ready, clr_dp, clr_p,ld_a, ld_b, ld_n, ld_p, 
              p_src, addr_src1_sel, addr_src2_sel, shr_b, shl_a, cen, src_a);
    input clk, rst, start, co, b_i, n_lt_sel;
    output reg ready, clr_dp, ld_a, ld_b, ld_n, ld_p, 
               p_src, addr_src1_sel, addr_src2_sel, shr_b, shl_a, cen, clr_p;
    output reg[1:0] src_a;

    localparam [2:0] S0_idle = 3'd0, S1_ld = 3'd1, S2_Add_c = 3'd2,
                     S3_sub_N = 3'd3, S4_sh_A = 3'd4, S5_Sub_A = 3'd5;

    reg [2:0] ns, ps;

    always @(posedge clk, posedge rst) begin
        if(rst)
            ps <= S0_idle;
        else
            ps <= ns;
    end

    always @(ps, start, co) begin
        case (ps)
            S0_idle:    ns <= (start) ? S1_ld : S0_idle;
            S1_ld  :    ns <= (start) ? S1_ld : S2_Add_c;
            S2_Add_c:   ns <= S3_sub_N;
            S3_sub_N:   ns <= S4_sh_A;
            S4_sh_A :   ns <= S5_Sub_A; 
            S5_Sub_A:   ns <= (co) ? S0_idle : S2_Add_c;
            default:    ns <= S0_idle;
        endcase
    end

    always @(ps, b_i, n_lt_sel) begin
        {ready, clr_dp, ld_a, ld_b, ld_n, ld_p, p_src, 
         addr_src1_sel, addr_src2_sel, shr_b, shl_a, cen, src_a, clr_p} = 15'd0;
        case (ps)
            S0_idle  :    {ready, clr_dp} = 2'b11;
            S1_ld    :    {ld_a, ld_b, ld_n, src_a, clr_p} = {3'b111,2'd2, 1'b1};
            S2_Add_c :    {ld_p, p_src, addr_src1_sel, addr_src2_sel} = {1'b1, b_i, 2'b00};
            S3_sub_N :    {ld_p, p_src, addr_src1_sel, addr_src2_sel} = {1'b1, n_lt_sel, 2'b01};
            S4_sh_A  :    {shl_a, cen} = 2'b11;
            S5_Sub_A :    {ld_a, shr_b, addr_src1_sel, addr_src2_sel ,src_a} = {4'b1111, (n_lt_sel) ? 2'd1 : 2'd0};
        endcase
    end
endmodule