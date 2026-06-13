module local_min(
    input wire clk,
    input wire rst,
    input wire pixel_valid,
    input wire [7:0] row0,
    input wire [7:0] row1,
    input wire [7:0] row2,
    input wire [7:0] row3,
    input wire [7:0] row4,
    input wire [7:0] row5,
    input wire [7:0] row6,
    input wire [7:0] row7,
    input wire [7:0] row8,
    input wire [7:0] row9,
    input wire [7:0] row10,
    // 11 column minimums — one per column in the sliding window
    output reg [7:0] pci_min_0,
    output reg [7:0] pci_min_1,
    output reg [7:0] pci_min_2,
    output reg [7:0] pci_min_3,
    output reg [7:0] pci_min_4,
    output reg [7:0] pci_min_5,
    output reg [7:0] pci_min_6,
    output reg [7:0] pci_min_7,
    output reg [7:0] pci_min_8,
    output reg [7:0] pci_min_9,
    output reg [7:0] pci_min_10,
    output reg pci_min_valid
);

// Step 1: Column minimum tree — find min of the 11 rows for this column
// Exactly like local_max but > becomes 
wire [7:0] v01   = (row0  < row1)  ? row0  : row1;
wire [7:0] v23   = (row2  < row3)  ? row2  : row3;
wire [7:0] v45   = (row4  < row5)  ? row4  : row5;
wire [7:0] v67   = (row6  < row7)  ? row6  : row7;
wire [7:0] v89   = (row8  < row9)  ? row8  : row9;
wire [7:0] v0123 = (v01   < v23)   ? v01   : v23;
wire [7:0] v4567 = (v45   < v67)   ? v45   : v67;
wire [7:0] v8910 = (v89   < row10) ? v89   : row10;
wire [7:0] v_lo  = (v0123 < v4567) ? v0123 : v4567;
wire [7:0] col_min = (v_lo < v8910) ? v_lo  : v8910;

// Step 2: Shift register of column minimums — C0 is oldest, C10 is newest
reg [7:0] C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10;

always @(posedge clk) begin
    if (rst) begin
        C0<=0; C1<=0; C2<=0; C3<=0; C4<=0;
        C5<=0; C6<=0; C7<=0; C8<=0; C9<=0; C10<=0;
        pci_min_valid <= 0;
    end else if (pixel_valid) begin
        // Shift old columns left, bring in new column min on right
        C0  <= C1;
        C1  <= C2;
        C2  <= C3;
        C3  <= C4;
        C4  <= C5;
        C5  <= C6;
        C6  <= C7;
        C7  <= C8;
        C8  <= C9;
        C9  <= C10;
        C10 <= col_min;   // newest column's minimum enters here

        // Output all 11 column minimums directly — Module 7 needs all of them
        pci_min_0  <= C0;
        pci_min_1  <= C1;
        pci_min_2  <= C2;
        pci_min_3  <= C3;
        pci_min_4  <= C4;
        pci_min_5  <= C5;
        pci_min_6  <= C6;
        pci_min_7  <= C7;
        pci_min_8  <= C8;
        pci_min_9  <= C9;
        pci_min_10 <= C10;

        pci_min_valid <= 1'b1;
    end else
        pci_min_valid <= 1'b0;
end

endmodule
