

module linear_approx (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  d,           // d = pci_min[k] - Gi (unsigned)
    output reg  [15:0] gamma_out    // gamma scaled by 2^14
);

// ============================================================
// Step 1: Compute all 8 segments IN PARALLEL (combinational)
// Slopes = sums of left-shifts = sums of powers of 2
// NO multipliers needed — pure shift and add
// ============================================================

// Seg 0: slope = 2^8 + 2^7 + 2^5 = 256+128+32 = 416
wire [15:0] seg0 = (d < 8'd40) ?
    (16'd16384 - ((d << 8) + (d << 7) + (d << 5))) : 16'd0;

// Seg 1: slope = 2^7 + 2^6 + 2^5 = 128+64+32 = 224
wire [15:0] seg1 = (d < 8'd61) ?
    (16'd13631 - ((d << 7) + (d << 6) + (d << 5))) : 16'd0;

// Seg 2: slope = 2^7 + 2^4 + 2^2 = 128+16+4 = 148
wire [15:0] seg2 = (d < 8'd73) ?
    (16'd10747 - ((d << 7) + (d << 4) + (d << 2))) : 16'd0;

// Seg 3: slope = 2^6 + 2^4 + 2^3 = 64+16+8 = 88
wire [15:0] seg3 = (d < 8'd91) ?
    (16'd7966  - ((d << 6) + (d << 4) + (d << 3))) : 16'd0;

// Seg 4: slope = 2^5 + 2^3 + 2^2 = 32+8+4 = 44
wire [15:0] seg4 = (d < 8'd115) ?
    (16'd5017  - ((d << 5) + (d << 3) + (d << 2))) : 16'd0;

// Seg 5: slope = 2^5 = 32
wire [15:0] seg5 = (d < 8'd74) ?
    (16'd2364  -  (d << 5)) : 16'd0;

// Seg 6: slope = 2^2 + 2^1 = 4+2 = 6
wire [15:0] seg6 = (d < 8'd176) ?
    (16'd1053  - ((d << 2) + (d << 1))) : 16'd0;

// Seg 7: flat constant — the tail of the curve
wire [15:0] seg7 = 16'd416;

// ============================================================
// Step 2: MUX — select correct segment based on d range
// Boundaries: 0,32,64,96,128,160,192,224 (equal 32-wide)
// This matches the hardware-friendly equal-width approach
// ============================================================
always @(posedge clk) begin
    if (rst) begin
        gamma_out <= 16'd0;
    end else begin
        if      (d < 8'd32)  gamma_out <= (seg0 > 16'd0) ? seg0 : 16'd0;
        else if (d < 8'd64)  gamma_out <= (seg1 > 16'd0) ? seg1 : 16'd0;
        else if (d < 8'd96)  gamma_out <= (seg2 > 16'd0) ? seg2 : 16'd0;
        else if (d < 8'd128) gamma_out <= (seg3 > 16'd0) ? seg3 : 16'd0;
        else if (d < 8'd160) gamma_out <= (seg4 > 16'd0) ? seg4 : 16'd0;
        else if (d < 8'd192) gamma_out <= (seg5 > 16'd0) ? seg5 : 16'd0;
        else if (d < 8'd224) gamma_out <= (seg6 > 16'd0) ? seg6 : 16'd0;
        else                 gamma_out <= seg7;
    end
end

endmodule
