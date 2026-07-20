// module half_adder_tb;
//     reg a;
//     reg b;
//     wire s;
//     wire c_out;

//     half_adder uut (
//         .a(a),
//         .b(b),
//         .c_out(c_out),
//         .s(s)
//     );

//     initial begin
//         $display("Half-Adder Testbench");
//         $display("A B | Cout S");

//         a = 0; b = 0; #10;
//         $display("%b %b | %b   %b", a, b, c_out, s);
//         a = 0; b = 1; #10;
//         $display("%b %b | %b   %b", a, b, c_out, s);
//         a = 1; b = 0; #10;
//         $display("%b %b | %b   %b", a, b, c_out, s);
//         a = 1; b = 1; #10;
//         $display("%b %b | %b   %b", a, b, c_out, s);

//         $finish;
//     end

// endmodule

// module full_adder_tb;
//     reg a;
//     reg b;
//     reg c_in;

//     wire s;
//     wire c_out;

//     full_adder uut (
//         .a(a),
//         .b(b),
//         .c_in(c_in),
//         .s(s),
//         .c_out(c_out)
//     );

//     initial begin
//         $display("Full-Adder Testbench");
//         $display("A B Cin | Cout Sum");
//         a = 0; b = 0; c_in = 0; #10;
//         $display("%b %b  %b  |  %b    %b", a, b, c_in, c_out, s);
//         a = 0; b = 0; c_in = 1; #10;
//         $display("%b %b  %b  |  %b    %b", a, b, c_in, c_out, s);
//         a = 0; b = 1; c_in = 0; #10;
//         $display("%b %b  %b  |  %b    %b", a, b, c_in, c_out, s);
//         a = 0; b = 1; c_in = 1; #10;
//         $display("%b %b  %b  |  %b    %b", a, b, c_in, c_out, s);
//         a = 1; b = 0; c_in = 0; #10;
//         $display("%b %b  %b  |  %b    %b", a, b, c_in, c_out, s);
//         a = 1; b = 0; c_in = 1; #10;
//         $display("%b %b  %b  |  %b    %b", a, b, c_in, c_out, s);
//         a = 1; b = 1; c_in = 0; #10;
//         $display("%b %b  %b  |  %b    %b", a, b, c_in, c_out, s);
//         a = 1; b = 1; c_in = 1; #10;
//         $display("%b %b  %b  |  %b    %b", a, b, c_in, c_out, s);

//         $finish;
//     end

// endmodule

// module adder_4bit_tb;

//     reg [3:0] a;
//     reg [3:0] b;
//     wire [3:0] s;
//     wire c_out;
    
//     adder_4bit uut (
//         .a(a),
//         .b(b),
//         .s(s),
//         .c_out(c_out)
//     );
    
//     initial begin
//         $display("A     B     | Cout Sum");
    
//         a = 4'b0000; b = 4'b0000; #10;
//         $display("%b  %b  |   %b   %b", a, b, c_out, s);
//         a = 4'b0001; b = 4'b0001; #10;
//         $display("%b  %b  |   %b   %b", a, b, c_out, s);
//         a = 4'b0010; b = 4'b0011; #10;
//         $display("%b  %b  |   %b   %b", a, b, c_out, s);
//         a = 4'b0101; b = 4'b0110; #10;
//         $display("%b  %b  |   %b   %b", a, b, c_out, s);
//         a = 4'b0111; b = 4'b1000; #10;
//         $display("%b  %b  |   %b   %b", a, b, c_out, s);
//         a = 4'b1111; b = 4'b0001; #10;
//         $display("%b  %b  |   %b   %b", a, b, c_out, s);
//         a = 4'b1010; b = 4'b0101; #10;
//         $display("%b  %b  |   %b   %b", a, b, c_out, s);
//         a = 4'b1111; b = 4'b1111; #10;
//         $display("%b  %b  |   %b   %b", a, b, c_out, s);
    
//         $finish;
//     end

// endmodule

// module carry_adder_4bit_tb;

//     reg [3:0] a;
//     reg [3:0] b;
//     reg c_in;
    
//     wire [3:0] s;
//     wire c_out;
    
//     carry_adder_4bit uut (
//         .a(a),
//         .b(b),
//         .c_in(c_in),
//         .s(s),
//         .c_out(c_out)
//     );
    
//     initial begin
//         $display("Cin  A     B     | Cout Sum");
//         $monitor("%b   %b  %b  |   %b   %b",
//                  c_in, a, b, c_out, s);
    
//         c_in = 0; a = 4'b0000; b = 4'b0000; #10;
//         c_in = 0; a = 4'b0001; b = 4'b0001; #10;
//         c_in = 0; a = 4'b0011; b = 4'b0101; #10;
//         c_in = 0; a = 4'b0111; b = 4'b1000; #10;
//         c_in = 0; a = 4'b1111; b = 4'b0001; #10;
//         c_in = 0; a = 4'b1111; b = 4'b1111; #10;
    
//         c_in = 1; a = 4'b0000; b = 4'b0000; #10;
//         c_in = 1; a = 4'b0001; b = 4'b0001; #10;
//         c_in = 1; a = 4'b0011; b = 4'b0101; #10;
//         c_in = 1; a = 4'b0111; b = 4'b1000; #10;
//         c_in = 1; a = 4'b1111; b = 4'b0001; #10;
//         c_in = 1; a = 4'b1111; b = 4'b1111; #10;
    
//         $finish;
//     end

// endmodule

// module multiplier_4bit_tb;

//     reg [3:0] a;
//     reg [3:0] b;
//     wire [7:0] product;
    
//     multiplier_4bit uut (
//         .a(a),
//         .b(b),
//         .product(product)
//     );
    
//     initial begin
//         $display("A     B     | Product");
//         $monitor("%b  %b  | %b", a, b, product);
    
//         a = 4'b0000; b = 4'b0000; #10;
//         a = 4'b0001; b = 4'b0001; #10;
//         a = 4'b0010; b = 4'b0011; #10;
//         a = 4'b0011; b = 4'b0101; #10;
//         a = 4'b0100; b = 4'b0110; #10;
//         a = 4'b0101; b = 4'b0111; #10;
//         a = 4'b0110; b = 4'b1000; #10;
//         a = 4'b0111; b = 4'b1001; #10;
//         a = 4'b1000; b = 4'b1010; #10;
//         a = 4'b1001; b = 4'b1011; #10;
//         a = 4'b1010; b = 4'b1100; #10;
//         a = 4'b1011; b = 4'b1101; #10;
//         a = 4'b1100; b = 4'b1110; #10;
//         a = 4'b1101; b = 4'b1111; #10;
//         a = 4'b1110; b = 4'b1110; #10;
//         a = 4'b1111; b = 4'b1111; #10;
    
//         $finish;
//     end

// endmodule