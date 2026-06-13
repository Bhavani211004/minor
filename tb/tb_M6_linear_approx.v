`timescale 1ns/1ps

module tb_linear_approx;

reg clk;
reg rst;
reg [7:0] d;

wire [15:0] gamma_out;

linear_approx DUT(
    .clk(clk),
    .rst(rst),
    .d(d),
    .gamma_out(gamma_out)
);

always #5 clk = ~clk;

integer i;

initial begin

    clk = 0;
    rst = 1;
    d = 0;

    #20;

    rst = 0;

    for(i=0;i<=255;i=i+16)
    begin
        d = i;
        #10;
    end

    #100;

    $finish;
end

always @(posedge clk)
begin
    $display(
    "d=%3d gamma=%5d",
    d,
    gamma_out
    );
end

endmodule
