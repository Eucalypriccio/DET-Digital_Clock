module debounce (
    input wire CP_1KHz,
    input wire btn_in,
    output reg btn_out
);
    reg [3:0] counter;
    reg btn_in_sync;

    initial begin
        counter = 0;
        btn_out = 0;
        btn_in_sync = 0;
    end

    always @(posedge CP_1KHz) begin
        btn_in_sync <= btn_in;
    end

    always @(posedge CP_1KHz) begin
        if (btn_in_sync == btn_out) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 15) begin
                btn_out <= btn_in_sync;
                counter <= 0;
            end
        end
    end
endmodule
