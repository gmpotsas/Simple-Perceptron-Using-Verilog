`define num_inputs 18 // number of input pairs
`define numo_bits 4  // Width of each input 

module Neuron(
  input signed [`numo_bits-1:0] X [`num_inputs-1:0],
  input signed [`numo_bits-1:0] W [`num_inputs-1:0],
  input signed [2*`numo_bits-1:0] threshold,
  output S
);
 wire [2*`numo_bits-1:0] Products [`num_inputs-1:0];
 wire [2*`numo_bits-1:0] PartialSums [`num_inputs-1:0];
 wire [2*`numo_bits-1:0] Sum1;

  genvar i,j;
  generate
    for (i = 0; i < `num_inputs; i=i+1) begin 
      if(`num_inputs==1)begin   // case where one pair of inputs gets treated with a single multipl, adder and one mux
         Multiplier  uut_mult (
           .A(X[0]),
           .B(W[0]),
           .Product(Products[0]));
        A add1(.A(Products[0]),.B(threshold),.S(Sum1));
       // assign S = Sum1[2*`numo_bits-1];
        mux21 M1(.a(1'b1),.b(1'b0),.Control(Sum1[2*`numo_bits-1]),.y(S)); // if MSB is 0 the number is greater than 0 so decide 1(positive) else the number is negative decide 0
        end
      else begin // on any other case iterate through the inputs and create inputs-1 mults and inputs-2 adders plus one adder for the threshold addition
         Multiplier uut(
          .A(X[i]),
          .B(W[i]),
          .Product(Products[i])
        );
          if(i==`num_inputs-1)begin // creation of mults is finished 
            A add(.A(Products[0]),.B(Products[1]),.S(PartialSums[0]));
            if(i>=2)begin
              for(j=1; j<i; j=j+1)begin
              A add(.A(PartialSums[j-1]),.B(Products[j+1]),.S(PartialSums[j]));
              if(j==i-1)begin
                A add2(.A(PartialSums[j]),.B(threshold),.S(Sum1));
                mux21 M1(.a(1'b1),.b(1'b0),.Control(Sum1[2*`numo_bits-1]),.y(S));
                //assign Sum = Sum1;
              end
            end
            end
            else begin
              A add2(.A(PartialSums[0]),.B(threshold),.S(Sum1));
              mux21 M1(.a(1'b1),.b(1'b0),.Control(Sum1[2*`numo_bits-1]),.y(S));
              //assign Sum=Sum1;
            end
            end 
      end
    end
  endgenerate
 
endmodule

module A (
  input signed [2*`numo_bits-1:0] A,B, // Input array
  output  signed [2*`numo_bits-1:0] S       // Output sum
);
  
assign S = A + B;

endmodule
     

module Multiplier (
   input  signed [`numo_bits-1:0] A,B,
   output signed  [2*`numo_bits-1:0] Product);
   assign Product=A*B;
endmodule



module mux21(input a,b,Control,
             output reg y);
        always @(a or b or Control)
          if(Control==1) y<=b;
        else y<=a;
endmodule
        