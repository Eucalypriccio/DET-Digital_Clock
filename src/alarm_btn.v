module alarm (
    input CP_1Hz,
    input CP_1KHz,
    input _CR,
    input alarm_active,
    input set_hour, set_minute, set_second,
    input save_alarm,
    input [4:0] hours_24,
    input [5:0] minutes,
    input [5:0] seconds,
    output reg [4:0] alarm_hours,
    output reg [5:0] alarm_minutes,
    output reg [5:0] alarm_seconds,
    output reg alarm_led
);
    
    reg [4:0] saved_hours;
    reg [5:0] saved_minutes;
    reg [5:0] saved_seconds;
    reg [3:0] lighting_time;

    initial begin
        alarm_hours <= 0;
        alarm_minutes <= 0;
        alarm_seconds <= 0;
        saved_hours <= -1;
        saved_minutes <= -1;
        saved_seconds <= -1;
        alarm_led <= 0;
        lighting_time <= 0;
    end

    wire set_hour_debounced, set_minute_debounced, set_second_debounced, save_alarm_debounced;
    debounce db1(
        .CP_1KHz(CP_1KHz),
        .btn_in(set_hour),
        .btn_out(set_hour_debounced)
    );
    debounce db2(
        .CP_1KHz(CP_1KHz),
        .btn_in(set_minute),
        .btn_out(set_minute_debounced)
    );
    debounce db3(
        .CP_1KHz(CP_1KHz),
        .btn_in(set_second),
        .btn_out(set_second_debounced)
    );
    debounce db4(
        .CP_1KHz(CP_1KHz),
        .btn_in(save_alarm),
        .btn_out(save_alarm_debounced)
    );

    always @(posedge CP_1Hz or negedge _CR) begin
        if (~_CR) begin
            alarm_hours <= 0;
            alarm_minutes <= 0;
            alarm_seconds <= 0;
            saved_hours <= -1;
            saved_minutes <= -1;
            saved_seconds <= -1;
            alarm_led <= 0;
            lighting_time <= 0;
        end else begin
            if (alarm_active) begin
                if (set_second_debounced) begin
                    alarm_seconds <= (alarm_seconds == 59) ? 0:(alarm_seconds + 1);
                end
                if (set_minute_debounced) begin
                    alarm_minutes <= (alarm_minutes == 59) ? 0:(alarm_minutes + 1); 
                end
                if (set_hour_debounced) begin
                    alarm_hours <= (alarm_hours == 23) ? 0:(alarm_hours + 1);
                end

                if (save_alarm_debounced) begin
                    saved_hours <= alarm_hours;
                    saved_minutes <= alarm_minutes;
                    saved_seconds <= alarm_seconds;
                end
            end
            
            if (saved_hours == hours_24 &&
                saved_minutes == minutes &&
                saved_seconds == seconds) begin
                alarm_led <= 1;
                lighting_time <= 0;
            end

            if (alarm_led == 1) begin
                lighting_time <= lighting_time + 1;
                if (lighting_time == 10) begin
                    alarm_led <= 0;
                end
            end
        end
    end
endmodule