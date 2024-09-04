module mul_tb();
    reg [127:0] x, y, m;
    reg clk, rst, start;

    wire rst_n;
    assign rst_n = ~rst;
    wire [127:0] p;
    wire ready, busy;
    // modu_mult_128 ut (x,y,m,p,clk,start,rst_n,
    //                  ready,busy);
    ssm #(128) UT (clk, rst, start, x, y, m, ready, p);
    always #5 clk = ~ clk;
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        x = 128'd217;
        y = 128'd189;
        m = 128'd239;
        start = 1'b0;
        #20
        rst = 1'b0;
        start = 1'b1;
        #20 
        start = 1'b0;
    end
endmodule