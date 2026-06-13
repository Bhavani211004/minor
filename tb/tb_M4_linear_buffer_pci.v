`timescale 1ns/1ps

module tb_line_buffer_pci;

reg clk;
reg rst;
reg wr_en;
reg [7:0] data_in;

wire [7:0] row0,row1,row2,row3,row4,row5,row6,row7,row8,row9,row10;

line_buffer_pci DUT(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .data_in(data_in),

    .row0(row0),
    .row1(row1),
    .row2(row2),
    .row3(row3),
    .row4(row4),
    .row5(row5),
    .row6(row6),
    .row7(row7),
    .row8(row8),
    .row9(row9),
    .row10(row10)
);

always #5 clk = ~clk;

integer i;

initial begin

    clk = 0;
    rst = 1;
    wr_en = 0;
    data_in = 0;

    #20;

    rst = 0;
    wr_en = 1;

    for(i=0;i<100;i=i+1)
    begin
        data_in = i;
        #10;
    end

    #100;
    $finish;
end

always @(posedge clk)
begin
    if(wr_en)
    begin
        $display(
        "Time=%0t Data=%0d Row0=%0d Row1=%0d Row10=%0d",
        $time,data_in,row0,row1,row10);
    end
end

endmodule
