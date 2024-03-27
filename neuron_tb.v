`define num_inputs 18 // number of input pairs
`define numo_bits 4 // Width of each input 
`define threshold 8'h01 // 

module neuron_tb;
  
  reg signed [`numo_bits-1:0] X [`num_inputs-1:0];
  reg signed [`numo_bits-1:0] W [`num_inputs-1:0];
 //wire  signed [2*`numo_bits-1:0] S;
  wire S;
  


  generate
    if(`num_inputs==1)begin
        Neuron  uut (.X(X[0]),.W(W[0]),.threshold(`threshold),.S(S));
    end
    else begin
        Neuron  uut (.X(X),.W(W),.threshold(`threshold),.S(S));
    end
  endgenerate

    integer i;
  initial begin

    // Initialize input values
    for ( i = 0; i < `num_inputs; i++) begin
      X[i] = $random;
      $display("X[%0d] = %0d", i, X[i]);
    end
      for ( i = 0; i < `num_inputs; i++) begin
      W[i] = $random;
      $display("W[%0d] = %0d", i, W[i]);
    end
    #10;
    $display("S = %0b", S);
   
  end

endmodule


