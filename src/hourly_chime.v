module hourly_chime (
    input CP_1Hz,
    input [4:0] hours,
    input [5:0] minutes,
    input [5:0] seconds,
    input chime_active,
    output reg chime_led
);
    reg [4:0] chime_cnt;
    reg chime_enable;

    initial begin
        chime_cnt <= 0;
        chime_enable <= 0;
        chime_led <= 0;
    end

    always @(posedge CP_1Hz) begin
        if (chime_enable) begin
            if (chime_cnt > 0) begin
                chime_led <= ~chime_led;
                if (chime_led == 1) begin
                    chime_cnt <= chime_cnt - 1;
                end
            end else begin
                chime_enable <= 0;
                chime_led <= 0;
            end
        end else if (chime_active && minutes == 0 && seconds == 0) begin
            if (hours == 0) begin
                chime_cnt <= 24;
            end else begin
                chime_cnt <= hours;
            end
            chime_led <= 1;
            chime_enable <= 1;
        end
    end
endmodule
