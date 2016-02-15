package com.betomaluje.android.fireshare.utils;

import android.content.Context;

import com.betomaluje.android.fireshare.R;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Hours;
import org.joda.time.Minutes;
import org.joda.time.Weeks;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

/**
 * Created by betomaluje on 2/4/16.
 */
public class DateUtils {

    private static DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");

    public static String getDate(Context context, String createdAt) {
        if (createdAt == null || createdAt.isEmpty())
            return "";

        DateTime program = DateTime.parse(createdAt, formatter);

        //2016-02-08T14:33:40.749-03:00
        DateTime now = new DateTime();

        String temp = now.toString();

        int minus = Integer.parseInt(temp.substring(temp.length() - 1 - 5, temp.length() - 1 - 2));

        if (minus < 0) {
            program = program.plusHours(minus);
        } else {
            program = program.minusHours(minus);
        }

        int weeksBetween = Math.abs(Weeks.weeksBetween(program, now).getWeeks());
        int daysBetween = Math.abs(Days.daysBetween(program, now).getDays());
        int hoursBetween = Math.abs(Hours.hoursBetween(program, now).getHours());
        int minutesBetween = Math.abs(Minutes.minutesBetween(program, now).getMinutes());

        String time;

        //weeks
        if (weeksBetween >= 1) {
            time = String.format(context.getString(R.string.date_weeks), weeksBetween);
        } else if (daysBetween > 0 && weeksBetween < 1) {
            time = String.format(context.getString(R.string.date_days), daysBetween);
        } else {
            if (hoursBetween > 0) {
                time = String.format(context.getString(R.string.date_hours), hoursBetween);
            } else {
                if (minutesBetween > 0) {
                    time = String.format(context.getString(R.string.date_minutes), minutesBetween);
                } else {
                    time = context.getString(R.string.date_now);
                }
            }
        }

        return time;
    }
}
