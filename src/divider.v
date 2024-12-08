module divider(
    input CP,
    input _CR,
    output reg CP_1Hz,
    output reg CP_1KHz
    );
  
    reg [31:0] counter_1Hz = 32'h0;
    reg [31:0] counter_1KHz = 32'h0;

    parameter CLK_Freq_1Hz = 100000000, CLK_Freq_1KHz = 100000;

    always @(posedge CP or negedge _CR) begin
        if (~_CR) begin
        counter_1Hz <= 32'h0;
        counter_1KHz <= 32'h0;
        CP_1Hz = 0;
        CP_1KHz = 0;
        end else begin
        if (counter_1Hz == CLK_Freq_1Hz/2 - 1) begin 
            CP_1Hz = ~CP_1Hz;
            counter_1Hz <= 32'h0;
        end else begin
            counter_1Hz <= counter_1Hz + 1;
        end
        
        if (counter_1KHz == CLK_Freq_1KHz/2 - 1) begin 
            CP_1KHz = ~CP_1KHz;
            counter_1KHz <= 32'h0;
        end else begin
            counter_1KHz <= counter_1KHz + 1;
        end
        end
  end
endmodule