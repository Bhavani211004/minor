`timescale 1ns/1ps

module tb_local_min;

reg clk;
reg rst;
reg pixel_valid;

reg [7:0] row0,row1,row2,row3,row4;
reg [7:0] row5,row6,row7,row8,row9,row10;

wire [7:0] pci_min_0;
wire [7:0] pci_min_1;
wire [7:0] pci_min_2;
wire [7:0] pci_min_3;
wire [7:0] pci_min_4;
wire [7:0] pci_min_5;
wire [7:0] pci_min_6;
wire [7:0] pci_min_7;
wire [7:0] pci_min_8;
wire [7:0] pci_min_9;
wire [7:0] pci_min_10;

wire pci_min_valid;

local_min DUT(
    .clk(clk),
    .rst(rst),
    .pixel_valid(pixel_valid),

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
    .row10(row10),

    .pci_min_0(pci_min_0),
    .pci_min_1(pci_min_1),
    .pci_min_2(pci_min_2),
    .pci_min_3(pci_min_3),
    .pci_min_4(pci_min_4),
    .pci_min_5(pci_min_5),
    .pci_min_6(pci_min_6),
    .pci_min_7(pci_min_7),
    .pci_min_8(pci_min_8),
    .pci_min_9(pci_min_9),
    .pci_min_10(pci_min_10),

    .pci_min_valid(pci_min_valid)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;
    pixel_valid = 0;

    #20;

    rst = 0;
    pixel_valid = 1;

    row0  = 100;
    row1  = 90;
    row2  = 80;
    row3  = 70;
    row4  = 60;
    row5  = 50;
    row6  = 40;
    row7  = 30;
    row8  = 20;
    row9  = 10;
    row10 = 5;

    #200;

    $finish;
end

always @(posedge clk)
begin
    if(pci_min_valid)
    begin
        $display(
        "Min0=%0d Min5=%0d Min10=%0d",
        pci_min_0,
        pci_min_5,
        pci_min_10
        );
    end
end

endmodule
