

module line_buffer_pci(
    input  wire       clk,
    input  wire       rst,        // active high reset
    input  wire       wr_en,      // connect to pci_valid from Module 3
    input  wire [7:0] data_in,    // connect to pci_out  from Module 3
    output reg  [7:0] row0,       // current row (newest)
    output reg  [7:0] row1,       // 1 row ago
    output reg  [7:0] row2,
    output reg  [7:0] row3,
    output reg  [7:0] row4,
    output reg  [7:0] row5,
    output reg  [7:0] row6,
    output reg  [7:0] row7,
    output reg  [7:0] row8,
    output reg  [7:0] row9,
    output reg  [7:0] row10       // 10 rows ago (oldest)
);

// ============================================================
// PARAMETER: match ROW_LEN to your image width
// Your dataset uses 694-pixel rows (matches existing line_buffer.v)
// ============================================================
localparam ROW_LEN = 694;

// ============================================================
// 10 BRAM line buffers — lb0 introduces 1-row delay,
// lb1 introduces 2-row delay, ..., lb9 introduces 10-row delay.
// (* ram_style = "block" *) tells Vivado to use BRAM not LUTs.
// ============================================================
(* ram_style = "block" *) reg [7:0] lb0  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb1  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb2  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb3  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb4  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb5  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb6  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb7  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb8  [0:ROW_LEN-1];
(* ram_style = "block" *) reg [7:0] lb9  [0:ROW_LEN-1];

// Column pointer — wraps around at ROW_LEN
integer ptr;

always @(posedge clk) begin
    if (rst) begin
        ptr   <= 0;
        row0  <= 8'd0; row1  <= 8'd0; row2  <= 8'd0;
        row3  <= 8'd0; row4  <= 8'd0; row5  <= 8'd0;
        row6  <= 8'd0; row7  <= 8'd0; row8  <= 8'd0;
        row9  <= 8'd0; row10 <= 8'd0;
    end
    else if (wr_en) begin
        // ---- READ outputs first (this clock's values) ----
        row0  <= data_in;    // newest = straight through
        row1  <= lb0[ptr];   // 1 row ago
        row2  <= lb1[ptr];   // 2 rows ago
        row3  <= lb2[ptr];
        row4  <= lb3[ptr];
        row5  <= lb4[ptr];
        row6  <= lb5[ptr];
        row7  <= lb6[ptr];
        row8  <= lb7[ptr];
        row9  <= lb8[ptr];
        row10 <= lb9[ptr];   // 10 rows ago

        // ---- WRITE: chain each buffer into the next ----
        lb0[ptr] <= data_in;
        lb1[ptr] <= lb0[ptr];
        lb2[ptr] <= lb1[ptr];
        lb3[ptr] <= lb2[ptr];
        lb4[ptr] <= lb3[ptr];
        lb5[ptr] <= lb4[ptr];
        lb6[ptr] <= lb5[ptr];
        lb7[ptr] <= lb6[ptr];
        lb8[ptr] <= lb7[ptr];
        lb9[ptr] <= lb8[ptr];

        // ---- Advance column pointer ----
        if (ptr == ROW_LEN - 1)
            ptr <= 0;
        else
            ptr <= ptr + 1;
    end
end

endmodule
