`timescale 1ns/1ps

module half_adder(
    input a,
    input b,
    output c_out,
    output s
);

    assign s = a ^ b;
    assign c_out = a & b;

endmodule

module full_adder(
    input  a,
    input  b,
    input  c_in,
    output s,
    output c_out
);

    assign s = a ^ b ^ c_in;
    assign c_out = (a & b) | (c_in & (a ^ b));

endmodule

module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    output [3:0] s,
    output c_out

);
    wire [2:0] carry;
    half_adder ha(
        .a(a[0]),
        .b(b[0]),
        .s(s[0]),
        .c_out(carry[0])
    );
    full_adder fa0(
        .a(a[1]),
        .b(b[1]),
        .c_in(carry[0]),
        .s(s[1]),
        .c_out(carry[1])
    );
    full_adder fa1(
        .a(a[2]),
        .b(b[2]),
        .c_in(carry[1]),
        .s(s[2]),
        .c_out(carry[2])
    );
    full_adder fa2(
        .a(a[3]),
        .b(b[3]),
        .c_in(carry[2]),
        .s(s[3]),
        .c_out(c_out)
    );
  
endmodule

module carry_adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input c_in,
    output [3:0] s,
    output c_out
);

    wire [3:0] p;
    wire [3:0] g;
    wire c1, c2, c3;
    
    assign p = a ^ b;
    assign g = a & b;
    
    assign c1 = g[0] | (p[0] & c_in);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign c_out = g[3] | (p[3] & c3);
    
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .c_in(c_in),
        .s(s[0]),
        .c_out()
    );
    
    full_adder fa1 (
        .a(a[1]),
        .b(b[1]),
        .c_in(c1),
        .s(s[1]),
        .c_out()
    );
    
    full_adder fa2 (
        .a(a[2]),
        .b(b[2]),
        .c_in(c2),
        .s(s[2]),
        .c_out()
    );
    
    full_adder fa3 (
        .a(a[3]),
        .b(b[3]),
        .c_in(c3),
        .s(s[3]),
        .c_out()
    );

endmodule

module adder_8bit(
  input [7:0] a,
  input [7:0] b,
  output [7:0] out,
  input c_in,
  output c_out
);
  wire carry;
  
  carry_adder_4bit adder0 (
    .a(a[3:0]),
    .b(b[3:0]),
    .s(out[3:0]),
    .c_in(c_in),
    .c_out(carry)
  );
  
  carry_adder_4bit adder1 (
    .a(a[7:4]),
    .b(b[7:4]),
    .s(out[7:4]),
    .c_in(carry),
    .c_out(c_out)
  );
  
endmodule

module multiplier_4bit(
    input [3:0] a,
    input [3:0] b,
    output [7:0] product
);
    wire [3:0] pp0 = a & {4{b[0]}};
    wire [3:0] pp1 = a & {4{b[1]}};
    wire [3:0] pp2 = a & {4{b[2]}};
    wire [3:0] pp3 = a & {4{b[3]}};

    wire [7:0] pp0_8 = {4'b0000, pp0};
    wire [7:0] pp1_8 = {3'b000, pp1, 1'b0};
    wire [7:0] pp2_8 = {2'b00, pp2, 2'b00};
    wire [7:0] pp3_8 = {1'b0, pp3, 3'b000};

    wire [7:0] sum1;
    wire [7:0] sum2;
    wire carry1, carry2, carry3;

    adder_8bit add1 (
        .a(pp0_8),
        .b(pp1_8),
        .c_in(1'b0),
        .out(sum1),
        .c_out(carry1) 
    );

    adder_8bit add2 (
        .a(sum1),
        .b(pp2_8),
        .c_in(1'b0),
        .out(sum2),
        .c_out(carry2)
    );

    adder_8bit add3 (
        .a(sum2),
        .b(pp3_8),
        .c_in(1'b0),
        .out(product),
        .c_out(carry3)
    );

endmodule

module d_flip_flop(
    input d,
    input clk,
    input reset,
    output reg q
);

    always @(posedge clk) begin
        if(reset == 1'b1) begin
            q <= 1'b0;
        end
        else begin
            q <= d;
        end
    end

endmodule

module register_4bit(
    input [3:0] d,
    input clk,
    input reset,
    output [3:0] q
);

    d_flip_flop dff0(
        .d(d[0]),
        .q(q[0]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff1(
        .d(d[1]),
        .q(q[1]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff2(
        .d(d[2]),
        .q(q[2]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff3(
        .d(d[3]),
        .q(q[3]),
        .clk(clk),
        .reset(reset)
    );

endmodule

module register_8bit(
    input [7:0] d,
    input clk,
    input reset,
    output [7:0] q
);

    d_flip_flop dff0(
        .d(d[0]),
        .q(q[0]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff1(
        .d(d[1]),
        .q(q[1]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff2(
        .d(d[2]),
        .q(q[2]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff3(
        .d(d[3]),
        .q(q[3]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff4(
        .d(d[4]),
        .q(q[4]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff5(
        .d(d[5]),
        .q(q[5]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff6(
        .d(d[6]),
        .q(q[6]),
        .clk(clk),
        .reset(reset)
    );

    d_flip_flop dff7(
        .d(d[7]),
        .q(q[7]),
        .clk(clk),
        .reset(reset)
    );

endmodule

module PE(
    input [3:0] a_in,
    input [3:0] b_in,
    output [3:0] a_out,
    output [3:0] b_out,
    output [7:0] summation,
    input clk,
    input reset
);

    wire [7:0] next_sum;
    wire [7:0] product;

    register_4bit reg_a(
        .d(a_in),
        .q(a_out),
        .clk(clk),
        .reset(reset)
    );

    register_4bit reg_b(
        .d(b_in),
        .q(b_out),
        .clk(clk),
        .reset(reset)
    );

    multiplier_4bit mult(
        .a(a_in),
        .b(b_in),
        .product(product)
    );

    adder_8bit adder(
        .a(summation),
        .b(product),
        .out(next_sum),
        .c_in(1'b0)
    );

    register_8bit register(
        .d(next_sum),
        .q(summation),
        .clk(clk),
        .reset(reset)
    );

endmodule

module matrix_mult_4x4(
    input clk,
    input reset,
    input [3:0] row0,
    input [3:0] row1,
    input [3:0] row2,
    input [3:0] row3,
    input [3:0] col0,
    input [3:0] col1,
    input [3:0] col2,
    input [3:0] col3,
    output [7:0] sum00,
    output [7:0] sum01,
    output [7:0] sum02,
    output [7:0] sum03,
    output [7:0] sum04,
    output [7:0] sum05,
    output [7:0] sum06,
    output [7:0] sum07,
    output [7:0] sum08,
    output [7:0] sum09,
    output [7:0] sum10,
    output [7:0] sum11,
    output [7:0] sum12,
    output [7:0] sum13,
    output [7:0] sum14,
    output [7:0] sum15
);
    wire [3:0] a_out0, a_out1, a_out2, a_out3,
               a_out4, a_out5, a_out6, a_out7,
               a_out8, a_out9, a_out10, a_out11,
               a_out12, a_out13, a_out14, a_out15,
               b_out0, b_out1, b_out2, b_out3,
               b_out4, b_out5, b_out6, b_out7,
               b_out8, b_out9, b_out10, b_out11,
               b_out12, b_out13, b_out14, b_out15;

    // ================= ROW 0 =================
    PE pe0(
        .a_in(row0),        .b_in(col0),
        .a_out(a_out0),     .b_out(b_out0),
        .summation(sum00),  .clk(clk),  .reset(reset)
    );
    PE pe1(
        .a_in(a_out0),      .b_in(col1),
        .a_out(a_out1),     .b_out(b_out1),
        .summation(sum01),  .clk(clk),  .reset(reset)
    );
    PE pe2(
        .a_in(a_out1),      .b_in(col2),
        .a_out(a_out2),     .b_out(b_out2),
        .summation(sum02),  .clk(clk),  .reset(reset)
    );
    PE pe3(
        .a_in(a_out2),      .b_in(col3),
        .a_out(a_out3),     .b_out(b_out3),
        .summation(sum03),  .clk(clk),  .reset(reset)
    );

    // ================= ROW 1 =================
    PE pe4(
        .a_in(row1),        .b_in(b_out0),
        .a_out(a_out4),     .b_out(b_out4),
        .summation(sum04),  .clk(clk),  .reset(reset)
    );
    PE pe5(
        .a_in(a_out4),      .b_in(b_out1),
        .a_out(a_out5),     .b_out(b_out5),
        .summation(sum05),  .clk(clk),  .reset(reset)
    );
    PE pe6(
        .a_in(a_out5),      .b_in(b_out2),
        .a_out(a_out6),     .b_out(b_out6),
        .summation(sum06),  .clk(clk),  .reset(reset)
    );
    PE pe7(
        .a_in(a_out6),      .b_in(b_out3),
        .a_out(a_out7),     .b_out(b_out7),
        .summation(sum07),  .clk(clk),  .reset(reset)
    );

    // ================= ROW 2 =================
    PE pe8(
        .a_in(row2),        .b_in(b_out4),
        .a_out(a_out8),     .b_out(b_out8),
        .summation(sum08),  .clk(clk),  .reset(reset)
    );
    PE pe9(
        .a_in(a_out8),      .b_in(b_out5),
        .a_out(a_out9),     .b_out(b_out9),
        .summation(sum09),  .clk(clk),  .reset(reset)
    );
    PE pe10(
        .a_in(a_out9),      .b_in(b_out6),
        .a_out(a_out10),    .b_out(b_out10),
        .summation(sum10),  .clk(clk),  .reset(reset)
    );
    PE pe11(
        .a_in(a_out10),     .b_in(b_out7),
        .a_out(a_out11),    .b_out(b_out11),
        .summation(sum11),  .clk(clk),  .reset(reset)
    );

    // ================= ROW 3 =================
    PE pe12(
        .a_in(row3),        .b_in(b_out8),
        .a_out(a_out12),    .b_out(b_out12),
        .summation(sum12),  .clk(clk),  .reset(reset)
    );
    PE pe13(
        .a_in(a_out12),     .b_in(b_out9),
        .a_out(a_out13),    .b_out(b_out13),
        .summation(sum13),  .clk(clk),  .reset(reset)
    );
    PE pe14(
        .a_in(a_out13),     .b_in(b_out10),
        .a_out(a_out14),    .b_out(b_out14),
        .summation(sum14),  .clk(clk),  .reset(reset)
    );
    PE pe15(
        .a_in(a_out14),     .b_in(b_out11),
        .a_out(a_out15),    .b_out(b_out15),
        .summation(sum15),  .clk(clk),  .reset(reset)
    );

endmodule

module mem_reuse_pipe(
    input clk,
    input reset,
    input [3:0] row0_in,
    input [3:0] row1_in,
    input [3:0] row2_in,
    input [3:0] row3_in,
    input [3:0] col0_in,
    input [3:0] col1_in,
    input [3:0] col2_in,
    input [3:0] col3_in,
    output [3:0] row0_out,
    output [3:0] row1_out,
    output [3:0] row2_out,
    output [3:0] row3_out,
    output [3:0] col0_out,
    output [3:0] col1_out,
    output [3:0] col2_out,
    output [3:0] col3_out
);

    // Row 0 registers
    wire [3:0] row0_reg_out0, row0_reg_out1, row0_reg_out2;
    register_4bit row0_reg0(
        .d(row0_in),
        .q(row0_reg_out0),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row0_reg1(
        .d(row0_reg_out0),
        .q(row0_reg_out1),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row0_reg2(
        .d(row0_reg_out1),
        .q(row0_reg_out2),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row0_reg3(
        .d(row0_reg_out2),
        .q(row0_out),
        .clk(clk),
        .reset(reset)
    );

    // Row 1 registers
    wire [3:0] row1_reg_out0, row1_reg_out1, row1_reg_out2, row1_reg_out3;
    register_4bit row1_reg0(
        .d(row1_in),
        .q(row1_reg_out0),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row1_reg1(
        .d(row1_reg_out0),
        .q(row1_reg_out1),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row1_reg2(
        .d(row1_reg_out1),
        .q(row1_reg_out2),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row1_reg3(
        .d(row1_reg_out2),
        .q(row1_reg_out3),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row1_reg4(
        .d(row1_reg_out3),
        .q(row1_out),
        .clk(clk),
        .reset(reset)
    );

    // Row 2 registers
    wire [3:0] row2_reg_out0, row2_reg_out1, row2_reg_out2, row2_reg_out3, row2_reg_out4;
    register_4bit row2_reg0(
        .d(row2_in),
        .q(row2_reg_out0),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row2_reg1(
        .d(row2_reg_out0),
        .q(row2_reg_out1),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row2_reg2(
        .d(row2_reg_out1),
        .q(row2_reg_out2),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row2_reg3(
        .d(row2_reg_out2),
        .q(row2_reg_out3),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row2_reg4(
        .d(row2_reg_out3),
        .q(row2_reg_out4),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row2_reg5(
        .d(row2_reg_out4),
        .q(row2_out),
        .clk(clk),
        .reset(reset)
    );

    // Row 3 registers
    wire [3:0] row3_reg_out0, row3_reg_out1, row3_reg_out2, row3_reg_out3, row3_reg_out4, row3_reg_out5;
    register_4bit row3_reg0(
        .d(row3_in),
        .q(row3_reg_out0),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row3_reg1(
        .d(row3_reg_out0),
        .q(row3_reg_out1),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row3_reg2(
        .d(row3_reg_out1),
        .q(row3_reg_out2),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row3_reg3(
        .d(row3_reg_out2),
        .q(row3_reg_out3),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row3_reg4(
        .d(row3_reg_out3),
        .q(row3_reg_out4),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row3_reg5(
        .d(row3_reg_out4),
        .q(row3_reg_out5),
        .clk(clk),
        .reset(reset)
    );
    register_4bit row3_reg6(
        .d(row3_reg_out5),
        .q(row3_out),
        .clk(clk),
        .reset(reset)
    );

    // Col 0 registers
    wire [3:0] col0_reg_out0, col0_reg_out1, col0_reg_out2;
    register_4bit col0_reg0(
        .d(col0_in),
        .q(col0_reg_out0),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col0_reg1(
        .d(col0_reg_out0),
        .q(col0_reg_out1),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col0_reg2(
        .d(col0_reg_out1),
        .q(col0_reg_out2),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col0_reg3(
        .d(col0_reg_out2),
        .q(col0_out),
        .clk(clk),
        .reset(reset)
    );

    // Col 1 registers
    wire [3:0] col1_reg_out0, col1_reg_out1, col1_reg_out2, col1_reg_out3;
    register_4bit col1_reg0(
        .d(col1_in),
        .q(col1_reg_out0),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col1_reg1(
        .d(col1_reg_out0),
        .q(col1_reg_out1),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col1_reg2(
        .d(col1_reg_out1),
        .q(col1_reg_out2),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col1_reg3(
        .d(col1_reg_out2),
        .q(col1_reg_out3),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col1_reg4(
        .d(col1_reg_out3),
        .q(col1_out),
        .clk(clk),
        .reset(reset)
    );

    // Col 2 registers
    wire [3:0] col2_reg_out0, col2_reg_out1, col2_reg_out2, col2_reg_out3, col2_reg_out4;
    register_4bit col2_reg0(
        .d(col2_in),
        .q(col2_reg_out0),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col2_reg1(
        .d(col2_reg_out0),
        .q(col2_reg_out1),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col2_reg2(
        .d(col2_reg_out1),
        .q(col2_reg_out2),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col2_reg3(
        .d(col2_reg_out2),
        .q(col2_reg_out3),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col2_reg4(
        .d(col2_reg_out3),
        .q(col2_reg_out4),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col2_reg5(
        .d(col2_reg_out4),
        .q(col2_out),
        .clk(clk),
        .reset(reset)
    );

    // Col 3 registers
    wire [3:0] col3_reg_out0, col3_reg_out1, col3_reg_out2, col3_reg_out3, col3_reg_out4, col3_reg_out5;
    register_4bit col3_reg0(
        .d(col3_in),
        .q(col3_reg_out0),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col3_reg1(
        .d(col3_reg_out0),
        .q(col3_reg_out1),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col3_reg2(
        .d(col3_reg_out1),
        .q(col3_reg_out2),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col3_reg3(
        .d(col3_reg_out2),
        .q(col3_reg_out3),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col3_reg4(
        .d(col3_reg_out3),
        .q(col3_reg_out4),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col3_reg5(
        .d(col3_reg_out4),
        .q(col3_reg_out5),
        .clk(clk),
        .reset(reset)
    );
    register_4bit col3_reg6(
        .d(col3_reg_out5),
        .q(col3_out),
        .clk(clk),
        .reset(reset)
    );

endmodule

module systolic_array(
    input clk,
    input reset,
    input start,
    output reg isFinished,
    input [3:0] a0, input [3:0] a1, input [3:0] a2, input [3:0] a3, input [3:0] a4, input [3:0] a5, input [3:0] a6, input [3:0] a7,
    input [3:0] a8, input [3:0] a9, input [3:0] a10, input [3:0] a11, input [3:0] a12, input [3:0] a13, input [3:0] a14, input [3:0] a15,
    input [3:0] b0, input [3:0] b1, input [3:0] b2, input [3:0] b3, input [3:0] b4, input [3:0] b5, input [3:0] b6, input [3:0] b7,
    input [3:0] b8, input [3:0] b9, input [3:0] b10, input [3:0] b11, input [3:0] b12, input [3:0] b13, input [3:0] b14, input [3:0] b15,
    output [7:0] mult0, output [7:0] mult1, output [7:0] mult2, output [7:0] mult3, output [7:0] mult4,
    output [7:0] mult5, output [7:0] mult6, output [7:0] mult7, output [7:0] mult8, output [7:0] mult9,
    output [7:0] mult10, output [7:0] mult11, output [7:0] mult12, output [7:0] mult13, output [7:0] mult14, output [7:0] mult15
);
    reg [1:0] cycle_count = 2'b00;
    wire [3:0] row0, row1, row2, row3, col0, col1, col2, col3;

    reg [3:0] row0_in, row1_in, row2_in, row3_in;
    reg [3:0] col0_in, col1_in, col2_in, col3_in;

    mem_reuse_pipe mem_pipe(
        .clk(clk),
        .reset(reset),
        .row0_in(row0_in), .row1_in(row1_in), .row2_in(row2_in), .row3_in(row3_in),
        .col0_in(col0_in), .col1_in(col1_in), .col2_in(col2_in), .col3_in(col3_in),
        .row0_out(row0), .row1_out(row1), .row2_out(row2), .row3_out(row3),
        .col0_out(col0), .col1_out(col1), .col2_out(col2), .col3_out(col3)
    );

    matrix_mult_4x4 network(
        .clk(clk),
        .reset(reset),
        .row0(row0), .row1(row1), .row2(row2), .row3(row3),
        .col0(col0), .col1(col1), .col2(col2), .col3(col3),
        .sum00(mult0), .sum01(mult1), .sum02(mult2), .sum03(mult3),
        .sum04(mult4), .sum05(mult5), .sum06(mult6), .sum07(mult7),
        .sum08(mult8), .sum09(mult9), .sum10(mult10), .sum11(mult11),
        .sum12(mult12), .sum13(mult13), .sum14(mult14), .sum15(mult15)
    );

    initial begin
        isFinished = 1'b0;
    end

    always @(posedge clk) begin
        if (reset) begin
            row0_in <= 4'b0000;
            row1_in <= 4'b0000;
            row2_in <= 4'b0000;
            row3_in <= 4'b0000;
            col0_in <= 4'b0000;
            col1_in <= 4'b0000;
            col2_in <= 4'b0000;
            col3_in <= 4'b0000;
        end else if (start) begin
            if(isFinished == 1'b0) begin
                case(cycle_count)
                    2'b00: begin
                        row0_in <= a0;
                        row1_in <= a4;
                        row2_in <= a8;
                        row3_in <= a12;
                        col0_in <= b0;
                        col1_in <= b2;
                        col2_in <= b6;
                        col3_in <= b12;
                        cycle_count <= 2'b01;
                    end
                    2'b01: begin
                        row0_in <= a1;
                        row1_in <= a5;
                        row2_in <= a9;
                        row3_in <= a13;
                        col0_in <= b1;
                        col1_in <= b5;
                        col2_in <= b9;
                        col3_in <= b13;
                        cycle_count <= 2'b10;
                    end
                    2'b10: begin
                        row0_in <= a2;
                        row1_in <= a6;
                        row2_in <= a10;
                        row3_in <= a14;
                        col0_in <= b4;
                        col1_in <= b8;
                        col2_in <= b10;
                        col3_in <= b14;
                        cycle_count <= 2'b11;
                    end
                    2'b11: begin
                        row0_in <= a3;
                        row1_in <= a7;
                        row2_in <= a11;
                        row3_in <= a15;
                        col0_in <= b7;
                        col1_in <= b3;
                        col2_in <= b11;
                        col3_in <= b15;
                        cycle_count <= 2'b00;
                        isFinished <= 1'b1;
                    end
                endcase
            end
            else begin
                row0_in <= 4'b0000;
                row1_in <= 4'b0000;
                row2_in <= 4'b0000;
                row3_in <= 4'b0000;
                col0_in <= 4'b0000;
                col1_in <= 4'b0000;
                col2_in <= 4'b0000;
                col3_in <= 4'b0000;
            end
        end
    end

endmodule

module matrix_add_8x8(
    input [7:0] a0, input [7:0] a1, input [7:0] a2, input [7:0] a3,
    input [7:0] a4, input [7:0] a5, input [7:0] a6, input [7:0] a7,
    input [7:0] a8, input [7:0] a9, input [7:0] a10, input [7:0] a11,
    input [7:0] a12, input [7:0] a13, input [7:0] a14, input [7:0] a15,
    input [7:0] b0, input [7:0] b1, input [7:0] b2, input [7:0] b3,
    input [7:0] b4, input [7:0] b5, input [7:0] b6, input [7:0] b7,
    input [7:0] b8, input [7:0] b9, input [7:0] b10, input [7:0] b11,
    input [7:0] b12, input [7:0] b13, input [7:0] b14, input [7:0] b15,
    output [7:0] sum0, output [7:0] sum1, output [7:0] sum2, output [7:0] sum3,
    output [7:0] sum4, output [7:0] sum5, output [7:0] sum6, output [7:0] sum7,
    output [7:0] sum8, output [7:0] sum9, output [7:0] sum10, output [7:0] sum11,
    output [7:0] sum12, output [7:0] sum13, output [7:0] sum14, output [7:0] sum15
);
    adder_8bit add0(.a(a0), .b(b0), .out(sum0), .c_in(1'b0));
    adder_8bit add1(.a(a1), .b(b1), .out(sum1), .c_in(1'b0));
    adder_8bit add2(.a(a2), .b(b2), .out(sum2), .c_in(1'b0));
    adder_8bit add3(.a(a3), .b(b3), .out(sum3), .c_in(1'b0));
    adder_8bit add4(.a(a4), .b(b4), .out(sum4), .c_in(1'b0));
    adder_8bit add5(.a(a5), .b(b5), .out(sum5), .c_in(1'b0));
    adder_8bit add6(.a(a6), .b(b6), .out(sum6), .c_in(1'b0));
    adder_8bit add7(.a(a7), .b(b7), .out(sum7), .c_in(1'b0));
    adder_8bit add8(.a(a8), .b(b8), .out(sum8), .c_in(1'b0));
    adder_8bit add9(.a(a9), .b(b9), .out(sum9), .c_in(1'b0));
    adder_8bit add10(.a(a10), .b(b10), .out(sum10), .c_in(1'b0));
    adder_8bit add11(.a(a11), .b(b11), .out(sum11), .c_in(1'b0));
    adder_8bit add12(.a(a12), .b(b12), .out(sum12), .c_in(1'b0));
    adder_8bit add13(.a(a13), .b(b13), .out(sum13), .c_in(1'b0));
    adder_8bit add14(.a(a14), .b(b14), .out(sum14), .c_in(1'b0));
    adder_8bit add15(.a(a15), .b(b15), .out(sum15), .c_in(1'b0));
endmodule

module tensor_module(
    input clk,
    input reset,
    input start,
    input [3:0] a0, input [3:0] a1, input [3:0] a2, input [3:0] a3,
    input [3:0] a4, input [3:0] a5, input [3:0] a6, input [3:0] a7,
    input [3:0] a8, input [3:0] a9, input [3:0] a10, input [3:0] a11,
    input [3:0] a12, input [3:0] a13, input [3:0] a14, input [3:0] a15,
    input [3:0] b0, input [3:0] b1, input [3:0] b2, input [3:0] b3,
    input [3:0] b4, input [3:0] b5, input [3:0] b6, input [3:0] b7,
    input [3:0] b8, input [3:0] b9, input [3:0] b10, input [3:0] b11,
    input [3:0] b12, input [3:0] b13, input [3:0] b14, input [3:0] b15,
    input [3:0] c0, input [3:0] c1, input [3:0] c2, input [3:0] c3,
    input [3:0] c4, input [3:0] c5, input [3:0] c6, input [3:0] c7,
    input [3:0] c8, input [3:0] c9, input [3:0] c10, input [3:0] c11,
    input [3:0] c12, input [3:0] c13, input [3:0] c14, input [3:0] c15,
    output isFinished,
    output [7:0] result0, output [7:0] result1, output [7:0] result2, output [7:0] result3,
    output [7:0] result4, output [7:0] result5, output [7:0] result6, output [7:0] result7,
    output [7:0] result8, output [7:0] result9, output [7:0] result10, output [7:0] result11,
    output [7:0] result12, output [7:0] result13, output [7:0] result14, output [7:0] result15
);

    // wire isFinished;
    wire [7:0] mult0, mult1, mult2, mult3, mult4, mult5, mult6, mult7,
         mult8, mult9, mult10, mult11, mult12, mult13, mult14, mult15;
    systolic_array systolic(
        .a0(a0), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .a5(a5), .a6(a6), .a7(a7),
        .a8(a8), .a9(a9), .a10(a10), .a11(a11), .a12(a12), .a13(a13), .a14(a14), .a15(a15),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3), .b4(b4), .b5(b5), .b6(b6), .b7(b7),
        .b8(b8), .b9(b9), .b10(b10), .b11(b11), .b12(b12), .b13(b13), .b14(b14), .b15(b15),
        .mult0(mult0), .mult1(mult1), .mult2(mult2), .mult3(mult3),
        .mult4(mult4), .mult5(mult5), .mult6(mult6), .mult7(mult7),
        .mult8(mult8), .mult9(mult9), .mult10(mult10), .mult11(mult11),
        .mult12(mult12), .mult13(mult13), .mult14(mult14), .mult15(mult15),
        .clk(clk), .reset(reset), .start(start), .isFinished(isFinished)
    );

    matrix_add_8x8 adder(
        .a0(mult0), .a1(mult1), .a2(mult2), .a3(mult3),
        .a4(mult4), .a5(mult5), .a6(mult6), .a7(mult7),
        .a8(mult8), .a9(mult9), .a10(mult10), .a11(mult11),
        .a12(mult12), .a13(mult13), .a14(mult14), .a15(mult15),
        .b0({4'b0000, c0}), .b1({4'b0000, c1}), .b2({4'b0000, c2}), .b3({4'b0000, c3}),
        .b4({4'b0000, c4}), .b5({4'b0000, c5}), .b6({4'b0000, c6}), .b7({4'b0000, c7}),
        .b8({4'b0000, c8}), .b9({4'b0000, c9}), .b10({4'b0000, c10}), .b11({4'b0000, c11}),
        .b12({4'b0000, c12}), .b13({4'b0000, c13}), .b14({4'b0000, c14}), .b15({4'b0000, c15}),
        .sum0(result0), .sum1(result1), .sum2(result2), .sum3(result3),
        .sum4(result4), .sum5(result5), .sum6(result6), .sum7(result7),
        .sum8(result8), .sum9(result9), .sum10(result10), .sum11(result11),
        .sum12(result12), .sum13(result13), .sum14(result14), .sum15(result15)
    );

endmodule

module io_manager(
    input start,
    output reg isValid,
    input clk,
    input reset,

    input [3:0] a0, input [3:0] a1, input [3:0] a2, input [3:0] a3,
    input [3:0] a4, input [3:0] a5, input [3:0] a6, input [3:0] a7,
    input [3:0] a8, input [3:0] a9, input [3:0] a10, input [3:0] a11,
    input [3:0] a12, input [3:0] a13, input [3:0] a14, input [3:0] a15,
    input [3:0] b0, input [3:0] b1, input [3:0] b2, input [3:0] b3,
    input [3:0] b4, input [3:0] b5, input [3:0] b6, input [3:0] b7,
    input [3:0] b8, input [3:0] b9, input [3:0] b10, input [3:0] b11,
    input [3:0] b12, input [3:0] b13, input [3:0] b14, input [3:0] b15,
    input [3:0] c0, input [3:0] c1, input [3:0] c2, input [3:0] c3,
    input [3:0] c4, input [3:0] c5, input [3:0] c6, input [3:0] c7,
    input [3:0] c8, input [3:0] c9, input [3:0] c10, input [3:0] c11,
    input [3:0] c12, input [3:0] c13, input [3:0] c14, input [3:0] c15,

    output [7:0] result0, output [7:0] result1, output [7:0] result2, output [7:0] result3,
    output [7:0] result4, output [7:0] result5, output [7:0] result6, output [7:0] result7,
    output [7:0] result8, output [7:0] result9, output [7:0] result10, output [7:0] result11,
    output [7:0] result12, output [7:0] result13, output [7:0] result14, output [7:0] result15
);

    wire isFinished;

    tensor_module tensor(
        .start(start),
        .clk(clk),
        .reset(reset),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3),
        .a4(a4), .a5(a5), .a6(a6), .a7(a7),
        .a8(a8), .a9(a9), .a10(a10), .a11(a11),
        .a12(a12), .a13(a13), .a14(a14), .a15(a15),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3),
        .b4(b4), .b5(b5), .b6(b6), .b7(b7),
        .b8(b8), .b9(b9), .b10(b10), .b11(b11),
        .b12(b12), .b13(b13), .b14(b14), .b15(b15),
        .c0(c0), .c1(c1), .c2(c2), .c3(c3),
        .c4(c4), .c5(c5), .c6(c6), .c7(c7),
        .c8(c8), .c9(c9), .c10(c10), .c11(c11),
        .c12(c12), .c13(c13), .c14(c14), .c15(c15),
        .result0(result0), .result1(result1), .result2(result2), .result3(result3),
        .result4(result4), .result5(result5), .result6(result6), .result7(result7),
        .result8(result8), .result9(result9), .result10(result10), .result11(result11),
        .result12(result12), .result13(result13), .result14(result14), .result15(result15),
        .isFinished(isFinished)
    );

    initial begin
        isValid <= 1'b0;
    end

    always @(posedge isFinished) begin
        #115;
        isValid <= 1'b1;
    end

endmodule

module io_manager_tb;

    reg clk;
    reg reset;
    reg start;

    reg [3:0] a0, a1, a2, a3;
    reg [3:0] a4, a5, a6, a7;
    reg [3:0] a8, a9, a10, a11;
    reg [3:0] a12, a13, a14, a15;

    reg [3:0] b0, b1, b2, b3;
    reg [3:0] b4, b5, b6, b7;
    reg [3:0] b8, b9, b10, b11;
    reg [3:0] b12, b13, b14, b15;

    reg [3:0] c0, c1, c2, c3;
    reg [3:0] c4, c5, c6, c7;
    reg [3:0] c8, c9, c10, c11;
    reg [3:0] c12, c13, c14, c15;

    wire isValid;
    wire [7:0] result0, result1, result2, result3;
    wire [7:0] result4, result5, result6, result7;
    wire [7:0] result8, result9, result10, result11;
    wire [7:0] result12, result13, result14, result15;

    io_manager uut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .isValid(isValid),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3),
        .a4(a4), .a5(a5), .a6(a6), .a7(a7),
        .a8(a8), .a9(a9), .a10(a10), .a11(a11),
        .a12(a12), .a13(a13), .a14(a14), .a15(a15),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3),
        .b4(b4), .b5(b5), .b6(b6), .b7(b7),
        .b8(b8), .b9(b9), .b10(b10), .b11(b11),
        .b12(b12), .b13(b13), .b14(b14), .b15(b15),
        .c0(c0), .c1(c1), .c2(c2), .c3(c3),
        .c4(c4), .c5(c5), .c6(c6), .c7(c7),
        .c8(c8), .c9(c9), .c10(c10), .c11(c11),
        .c12(c12), .c13(c13), .c14(c14), .c15(c15),
        .result0(result0), .result1(result1), .result2(result2), .result3(result3),
        .result4(result4), .result5(result5), .result6(result6), .result7(result7),
        .result8(result8), .result9(result9), .result10(result10), .result11(result11),
        .result12(result12), .result13(result13), .result14(result14), .result15(result15)
    );

    always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, io_manager_tb);

        reset = 1'b1;
        start = 1'b0;
        
        /* 
           1 2 3 4
           2 3 4 5
           3 4 5 6
           4 5 6 7
        */
        a0 = 4'd1;  a1 = 4'd2;  a2 = 4'd3;  a3 = 4'd4;
        a4 = 4'd2;  a5 = 4'd3;  a6 = 4'd4;  a7 = 4'd5;
        a8 = 4'd3;  a9 = 4'd4;  a10= 4'd5;  a11= 4'd6;
        a12= 4'd4;  a13= 4'd5;  a14= 4'd6;  a15= 4'd7;

        /* 
           1 0 0 0
           0 1 0 0
           0 0 1 0
           0 0 0 1
        */
        b0 = 4'd1;  b1 = 4'd0;  b2 = 4'd0;  b3 = 4'd0;
        b4 = 4'd0;  b5 = 4'd1;  b6 = 4'd0;  b7 = 4'd0;
        b8 = 4'd0;  b9 = 4'd0;  b10= 4'd1;  b11= 4'd0;
        b12= 4'd0;  b13= 4'd0;  b14= 4'd0;  b15= 4'd1;

        /* 
           1 0 0 0
           1 0 0 0
           1 0 0 1
           1 0 0 1
        */
        c0 = 4'd1;  c1 = 4'd0;  c2 = 4'd0;  c3 = 4'd0;
        c4 = 4'd1;  c5 = 4'd0;  c6 = 4'd0;  c7 = 4'd0;
        c8 = 4'd1;  c9 = 4'd0;  c10= 4'd0;  c11= 4'd1;
        c12= 4'd1;  c13= 4'd0;  c14= 4'd0;  c15= 4'd1;

        #20;
        reset = 1'b0;
        
        #10;
        start = 1'b1;

        #300; 

        $display("========================================");
        $display("   IO MANAGER MODULE TEST   ");
        $display("========================================");
        
        $display("\nMatrix A:");
        $display("%2d  %2d  %2d  %2d", a0, a1, a2, a3);
        $display("%2d  %2d  %2d  %2d", a4, a5, a6, a7);
        $display("%2d  %2d  %2d  %2d", a8, a9, a10, a11);
        $display("%2d  %2d  %2d  %2d", a12, a13, a14, a15);
        
        $display("\nMatrix B (Identity):");
        $display("%2d  %2d  %2d  %2d", b0, b1, b2, b3);
        $display("%2d  %2d  %2d  %2d", b4, b5, b6, b7);
        $display("%2d  %2d  %2d  %2d", b8, b9, b10, b11);
        $display("%2d  %2d  %2d  %2d", b12, b13, b14, b15);

        $display("\nMatrix C:");
        $display("%2d  %2d  %2d  %2d", c0, c1, c2, c3);
        $display("%2d  %2d  %2d  %2d", c4, c5, c6, c7);
        $display("%2d  %2d  %2d  %2d", c8, c9, c10, c11);
        $display("%2d  %2d  %2d  %2d", c12, c13, c14, c15);

        $display("\nResulting Output Matrix:");
        $display("%2d  %2d  %2d  %2d", result0, result1, result2, result3);
        $display("%2d  %2d  %2d  %2d", result4, result5, result6, result7);
        $display("%2d  %2d  %2d  %2d", result8, result9, result10, result11);
        $display("%2d  %2d  %2d  %2d", result12, result13, result14, result15);
        $display("========================================\n");

        $finish;
    end


endmodule

// module systolic_array_tb;

//     reg clk;
//     reg reset;
//     reg start;
    
//     reg [3:0] a0, a1, a2, a3;
//     reg [3:0] a4, a5, a6, a7;
//     reg [3:0] a8, a9, a10, a11;
//     reg [3:0] a12, a13, a14, a15;
    
//     reg [3:0] b0, b1, b2, b3;
//     reg [3:0] b4, b5, b6, b7;
//     reg [3:0] b8, b9, b10, b11;
//     reg [3:0] b12, b13, b14, b15;

//     wire isFinished;
//     wire [7:0] mult0, mult1, mult2, mult3;
//     wire [7:0] mult4, mult5, mult6, mult7;
//     wire [7:0] mult8, mult9, mult10, mult11;
//     wire [7:0] mult12, mult13, mult14, mult15;

//     systolic_array uut (
//         .clk(clk),
//         .reset(reset),
//         .start(start),
//         .isFinished(isFinished),
        
//         .a0(a0), .a1(a1), .a2(a2), .a3(a3),
//         .a4(a4), .a5(a5), .a6(a6), .a7(a7),
//         .a8(a8), .a9(a9), .a10(a10), .a11(a11),
//         .a12(a12), .a13(a13), .a14(a14), .a15(a15),
        
//         .b0(b0), .b1(b1), .b2(b2), .b3(b3),
//         .b4(b4), .b5(b5), .b6(b6), .b7(b7),
//         .b8(b8), .b9(b9), .b10(b10), .b11(b11),
//         .b12(b12), .b13(b13), .b14(b14), .b15(b15),
        
//         .mult0(mult0), .mult1(mult1), .mult2(mult2), .mult3(mult3),
//         .mult4(mult4), .mult5(mult5), .mult6(mult6), .mult7(mult7),
//         .mult8(mult8), .mult9(mult9), .mult10(mult10), .mult11(mult11),
//         .mult12(mult12), .mult13(mult13), .mult14(mult14), .mult15(mult15)
//     );

//     always begin
//         clk = 1'b0;
//         #5;
//         clk = 1'b1;
//         #5;
//     end

//     initial begin
//         $dumpfile("waveform.vcd");
//         $dumpvars(0, systolic_array_tb);

//         reset = 1'b1;
//         start = 1'b0;
        
//         /* 
//            1 2 3 4
//            2 3 4 5
//            3 4 5 6
//            4 5 6 7
//         */
//         a0 = 4'd1;  a1 = 4'd2;  a2 = 4'd3;  a3 = 4'd4;
//         a4 = 4'd2;  a5 = 4'd3;  a6 = 4'd4;  a7 = 4'd5;
//         a8 = 4'd3;  a9 = 4'd4;  a10= 4'd5;  a11= 4'd6;
//         a12= 4'd4;  a13= 4'd5;  a14= 4'd6;  a15= 4'd7;

//         /* 
//            1 0 0 0
//            0 1 0 0
//            0 0 1 0
//            0 0 0 1
//         */
//         b0 = 4'd1;  b1 = 4'd0;  b2 = 4'd0;  b3 = 4'd0;
//         b4 = 4'd0;  b5 = 4'd1;  b6 = 4'd0;  b7 = 4'd0;
//         b8 = 4'd0;  b9 = 4'd0;  b10= 4'd1;  b11= 4'd0;
//         b12= 4'd0;  b13= 4'd0;  b14= 4'd0;  b15= 4'd1;

//         #20;
//         reset = 1'b0;
        
//         #10;
//         start = 1'b1;

//         #300; 

//         $display("========================================");
//         $display("   SYSTOLIC ARRAY MULTIPLICATION TEST   ");
//         $display("========================================");
        
//         $display("\nMatrix A:");
//         $display("%2d  %2d  %2d  %2d", a0, a1, a2, a3);
//         $display("%2d  %2d  %2d  %2d", a4, a5, a6, a7);
//         $display("%2d  %2d  %2d  %2d", a8, a9, a10, a11);
//         $display("%2d  %2d  %2d  %2d", a12, a13, a14, a15);
        
//         $display("\nMatrix B (Identity):");
//         $display("%2d  %2d  %2d  %2d", b0, b1, b2, b3);
//         $display("%2d  %2d  %2d  %2d", b4, b5, b6, b7);
//         $display("%2d  %2d  %2d  %2d", b8, b9, b10, b11);
//         $display("%2d  %2d  %2d  %2d", b12, b13, b14, b15);

//         $display("\nResulting Output Matrix (Should Match Matrix A):");
//         $display("%2d  %2d  %2d  %2d", mult0, mult1, mult2, mult3);
//         $display("%2d  %2d  %2d  %2d", mult4, mult5, mult6, mult7);
//         $display("%2d  %2d  %2d  %2d", mult8, mult9, mult10, mult11);
//         $display("%2d  %2d  %2d  %2d", mult12, mult13, mult14, mult15);
//         $display("========================================\n");

//         $finish;
//     end

// endmodule

// module PE_tb;

//     reg [3:0] a_in;
//     reg [3:0] b_in;
//     reg clk;
//     reg reset;
//     wire [7:0] summation;
//     wire [3:0] a_out;
//     wire [3:0] b_out;

//     PE uut (
//         .clk(clk),
//         .reset(reset),
//         .a_in(a_in),
//         .b_in(b_in),
//         .summation(summation),
//         .b_out(b_out),
//         .a_out(a_out)
//     );

//     initial begin
//         $dumpfile("waveform.vcd");
//         $dumpvars(0, PE_tb);
//     end

//     initial begin
//         reset = 1'b1;
//         a_in = 0;
//         b_in = 0;
//         #8;
//         reset = 1'b0;
//     end

//     always begin
//         clk = 1'b0;
//         #5;
//         clk = 1'b1;
//         #5;
//     end

//     always @(posedge clk) begin
//         $display("%b  %b  | %b", a_in, b_in, summation);
//     end
    
//     initial begin

//         $display("A     B     | Sum");
//         #10;
//         a_in = 4'b0000; b_in = 4'b0000; #10;
//         a_in = 4'b0001; b_in = 4'b0001; #10;
//         a_in = 4'b0010; b_in = 4'b0011; #10;
//         a_in = 4'b0011; b_in = 4'b0101; #10;
//         a_in = 4'b0100; b_in = 4'b0110; #10;
//         a_in = 4'b0101; b_in = 4'b0111; #10;
//         a_in = 4'b0110; b_in = 4'b1000; #10;
//         a_in = 4'b0111; b_in = 4'b1001; #10;
//         a_in = 4'b1000; b_in = 4'b1010; #10;
//         a_in = 4'b1001; b_in = 4'b1011; #10;
//         a_in = 4'b1010; b_in = 4'b1100; #10;
//         a_in = 4'b1011; b_in = 4'b1101; #10;
//         a_in = 4'b1100; b_in = 4'b1110; #10;
//         a_in = 4'b1101; b_in = 4'b1111; #10;
//         a_in = 4'b1110; b_in = 4'b1110; #10;
//         a_in = 4'b1111; b_in = 4'b1111; #10;
    
//         $finish;
//     end

// endmodule