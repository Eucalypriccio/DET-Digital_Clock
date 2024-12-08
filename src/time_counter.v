module time_counter (
    input CP_1Hz,
    input _CR,
    input hour_adj, min_adj,
    input time_display_switch,
    output reg [4:0] hours,
    output reg [5:0] minutes,
    output reg [5:0] seconds,
    output reg [4:0] to_alarm_hours,
    output reg [3:0] time_display_1, time_display_2
);

    reg [4:0] hours_24, hours_12;
    reg [5:0] minutes_24, minutes_12;
    reg [5:0] seconds_24, seconds_12;

    initial begin
        hours <= 0;
        minutes <= 0;
        seconds <= 0;
        hours_24 <= 0;
        hours_12 <= 12;
        minutes_24 <= 0;
        minutes_12 <= 0;
        seconds_24 <= 0;
        seconds_12 <= 0;
        time_display_1 <= 13;
        time_display_2 <= 13;
    end

    always @(posedge CP_1Hz or negedge _CR) begin
        if (~_CR) begin
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
            hours_24 <= 0;
            hours_12 <= 12;
            minutes_24 <= 0;
            minutes_12 <= 0;
            seconds_24 <= 0;
            seconds_12 <= 0;
            time_display_1 <= 13;
            time_display_2 <= 13;
        end else begin
            if (hour_adj) begin
                if (hours_24 == 23) begin
                    hours_24 <= 0;
                end else begin
                    hours_24 <= hours_24 + 1;
                end

                if (hours_12 == 12) begin
                    hours_12 <= 1;
                end else begin
                    hours_12 <= hours_12 + 1;
                end

                seconds_24 <= 0;
                seconds_12 <= 0;
            end 
            if (min_adj) begin
                if (minutes_24 == 59) begin
                    minutes_24 <= 0;
                    if (hours_24 == 23) begin
                        hours_24 <= 0;
                    end else begin
                        hours_24 <= hours_24 + 1;
                    end
                end else begin
                    minutes_24 <= minutes_24 + 1;
                end

                if (minutes_12 == 59) begin
                    minutes_12 <= 0;
                    if (hours_12 == 12) begin
                        hours_12 <= 1;
                    end else begin
                        hours_12 <= hours_12 + 1;
                    end
                end else begin
                    minutes_12 <= minutes_12 + 1;
                end

                seconds_24 <= 0;
                seconds_12 <= 0;
            end
            if ((~hour_adj) && (~min_ajd)) begin
                if (seconds_24 == 59) begin
                    seconds_24 <= 0;
                    if (minutes_24 == 59) begin
                        minutes_24 <= 0;
                        if (hours_24 == 23) begin
                            hours_24 <= 0;
                        end else begin
                            hours_24 <= hours_24 + 1;
                        end
                    end else begin
                        minutes_24 <= minutes_24 + 1;
                    end
                end else begin
                    seconds_24 <= seconds_24 + 1;
                end

                if (seconds_12 == 59) begin
                    seconds_12 <= 0;
                    if (minutes_12 == 59) begin
                        minutes_12 <= 0;
                        if (hours_12 == 12) begin
                            hours_12 <= 1;
                        end else begin
                            hours_12 <= hours_12 + 1;
                        end
                    end else begin
                        minutes_12 <= minutes_12 + 1;
                    end
                end else begin
                    seconds_12 <= seconds_12 + 1;
                end
            end

            if (~time_display_switch) begin
                hours <= hours_24;
                minutes <= minutes_24;
                seconds <= seconds_24;
                time_display_1 <= 13;
                time_display_2 <= 13;
            end else begin
                hours <= hours_12;
                minutes <= minutes_12;
                seconds <= seconds_12;
                time_display_2 <= 12;
                if (hours_24 > 12 || hours_24 == 0)
                    time_display_1 <= 11; // PM
                else
                    time_display_1 <= 10; // AM
            end

            to_alarm_hours <= hours_24;
        end
    end
endmodule
