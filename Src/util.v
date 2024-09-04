module sh_reg #(parameter LEN = 32)(clk, rst, clr, shl, shr, ld, d_in, d_out);
    input clk, rst, clr, shl, shr, ld;
    input [LEN-1:0] d_in;
    output reg[LEN-1:0] d_out;
    always @(posedge clk, posedge rst) begin
        if(rst)
            d_out <= {(LEN){1'b0}};
        else if (clr)
            d_out <= {(LEN){1'b0}};
        else if (ld)
            d_out <= d_in;
        else if (shl)
            d_out <= d_out << 1;
        else if (shr)
            d_out <= d_out >> 1;
    end

endmodule

module Counter #(
    parameter integer MAX = 32, //upper bound of count
    parameter integer WIDTH = $clog2(MAX) //bitwidth of counter
)
(
    input clk, cen, rst, clr,
    output at_max,
    output reg [WIDTH - 1 : 0] count
);

always @(posedge clk, posedge rst) begin
    if (rst) begin
        count <= 0;
    end 
    else if (clr) begin
        count <= 0;
    end 
    else if (cen) begin
        if (at_max) begin
            count <= 0;
        end else if(cen) begin
            count <= count + {{(WIDTH - 1){1'b0}}, 1'b1};
        end
    end
end

assign at_max = (count == (MAX - 1));
endmodule