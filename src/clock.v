module clock (
    input CP,
    input _CR,
    input hour_adj,
    input min_adj,
    input time_display_switch,
    input chime_active,
    input alarm_active,
    input set_hour, set_minute, set_second,
    input save_alarm,
    output reg [6:0] seg,
    output reg [7:0] select,
    output chime_led,
    output alarm_led
);
    
    wire CP_1Hz, CP_1KHz;
    wire [4:0] hours;
    wire [5:0] minutes, seconds;
    wire [6:0] td_1, td_2;
    wire [4:0] to_alarm_hours;
    wire [4:0] alarm_hours;
    wire [5:0] alarm_minutes, alarm_seconds;

    divider d(
        .CP(CP),
        ._CR(_CR),
        .CP_1Hz(CP_1Hz),
        .CP_1KHz(CP_1KHz)
    );

    time_counter tc(
        .CP_1Hz(CP_1Hz),
        ._CR(_CR),
        .hour_adj(hour_adj),
        .min_adj(min_adj),
        .time_display_switch(time_display_switch),
        .hours(hours),
        .minutes(minutes),
        .seconds(seconds),
        .to_alarm_hours(to_alarm_hours),
        .time_display_1(td_1),
        .time_display_2(td_2)
    );

    hourly_chime hc(
        .CP_1Hz(CP_1Hz),
        .hours(hours),
        .minutes(minutes),
        .seconds(seconds),
        .chime_active(chime_active),
        .chime_led(chime_led)
    );

    alarm al(
        .CP_1Hz(CP_1Hz),
        ._CR(_CR),
        .alarm_active(alarm_active),
        .set_hour(set_hour),
        .set_minute(set_minute),
        .set_second(set_second),
        .save_alarm(save_alarm),
        .hours_24(to_alarm_hours),
        .minutes(minutes),
        .seconds(seconds),
        .alarm_hours(alarm_hours),
        .alarm_minutes(alarm_minutes),
        .alarm_seconds(alarm_seconds),
        .alarm_led(alarm_led)
    );

    wire [6:0] seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
    wire [6:0] seg9, seg10, seg11, seg12, seg13, seg14;

    reg [3:0] flag_1, flag_2;
    initial begin
        flag_1 <= 0;
        flag_2 <= 0;
    end
    always @(posedge CP_1KHz) begin
        flag_1 <= (flag_1 + 1) % 8;
        flag_2 <= (flag_2 + 1) % 6;
    end

    decoder d1(hours / 10, seg1);
    decoder d2(hours % 10, seg2);
    decoder d3(minutes / 10, seg3);
    decoder d4(minutes % 10, seg4);
    decoder d5(seconds / 10, seg5);
    decoder d6(seconds % 10, seg6);
    decoder d7(td_1, seg7);
    decoder d8(td_2, seg8);

    decoder a1(alarm_hours / 10, seg9);
    decoder a2(alarm_hours % 10, seg10);
    decoder a3(alarm_minutes / 10, seg11);
    decoder a4(alarm_minutes % 10, seg12);
    decoder a5(alarm_seconds / 10, seg13);
    decoder a6(alarm_seconds % 10, seg14);

    always @(flag_1 or flag_2 or time_display_switch or alarm_active) begin
        if (~alarm_active) begin
            if (flag_1 == 3'd0) begin
                select <= 8'b0111_1111;
                seg <= seg1;
            end
            if (flag_1 == 3'd1) begin
                select <= 8'b1011_1111;
                seg <= seg2;
            end
            if (flag_1 == 3'd2) begin
                select <= 8'b1101_1111;
                seg <= seg3;
            end
            if (flag_1 == 3'd3) begin
                select <= 8'b1110_1111;
                seg <= seg4;
            end
            if (flag_1 == 3'd4) begin
                select <= 8'b1111_0111;
                seg <= seg5;
            end
            if (flag_1 == 3'd5) begin
                select <= 8'b1111_1011;
                seg <= seg6;
            end
            if ((flag_1 == 3'd6 || flag_1 == 3'd7) && ~time_display_switch) begin
                select <= 8'b1111_1111;
            end
            if (flag_1 == 3'd6 && time_display_switch) begin
                select <= 8'b1111_1101;
                seg <= seg7;
            end
            if (flag_1 == 3'd7 && time_display_switch) begin
                select <= 8'b1111_1110;
                seg <= seg8;
            end
        end

        if (alarm_active) begin
            if (flag_2 == 3'd0) begin
                select <= 8'b0111_1111;
                seg <= seg9;
            end
            if (flag_2 == 3'd1) begin
                select <= 8'b1011_1111;
                seg <= seg10;
            end
            if (flag_2 == 3'd2) begin
                select <= 8'b1101_1111;
                seg <= seg11;
            end
            if (flag_2 == 3'd3) begin
                select <= 8'b1110_1111;
                seg <= seg12;
            end
            if (flag_2 == 3'd4) begin
                select <= 8'b1111_0111;
                seg <= seg13;
            end
            if (flag_2 == 3'd5) begin
                select <= 8'b1111_1011;
                seg <= seg14;
            end
        end
    end
endmodule