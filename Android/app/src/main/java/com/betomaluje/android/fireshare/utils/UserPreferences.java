package com.betomaluje.android.fireshare.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.betomaluje.android.fireshare.models.User;
import com.google.gson.Gson;

import org.joda.time.DateTime;
import org.joda.time.Days;

/**
 * Created by betomaluje on 1/29/16.
 */
public class UserPreferences {

    private final String TAG = UserPreferences.class.getSimpleName();

    private final String USER_PREFS_KEY = "user";
    private final String USER_KEY = "data";
    private final String DATE_KEY = "date";
    private final String PUSH_TOKEN_KEY = "token_push";

    private static Context context;

    private static UserPreferences instance = new UserPreferences();

    public static UserPreferences using(Context context) {
        UserPreferences.context = context;
        return instance;
    }

    public void saveUser(String user) {
        SharedPreferences sharedPref = context.getSharedPreferences(USER_PREFS_KEY, Context.MODE_PRIVATE);

        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString(USER_KEY, user);
        editor.putString(DATE_KEY, new DateTime().toString());
        editor.commit();
    }

    public User getUser() {
        SharedPreferences sharedPref = context.getSharedPreferences(USER_PREFS_KEY, Context.MODE_PRIVATE);

        String user = sharedPref.getString(USER_KEY, "");

        if (!user.isEmpty()) {
            Gson gson = new Gson();
            return gson.fromJson(user, User.class);
        } else {
            return null;
        }
    }

    public void saveTokenPush(String token) {
        SharedPreferences sharedPref = context.getSharedPreferences(USER_PREFS_KEY, Context.MODE_PRIVATE);

        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString(PUSH_TOKEN_KEY, token);
        editor.commit();
    }

    public String getTokenPush() {
        SharedPreferences sharedPref = context.getSharedPreferences(USER_PREFS_KEY, Context.MODE_PRIVATE);

        return sharedPref.getString(PUSH_TOKEN_KEY, "");
    }

    public boolean mustLogin() {
        SharedPreferences sharedPref = context.getSharedPreferences(USER_PREFS_KEY, Context.MODE_PRIVATE);

        String loginDate = sharedPref.getString(DATE_KEY, "");

        Log.e(TAG, "time diff: " + (Math.abs(Days.daysBetween(new DateTime(), new DateTime(loginDate)).getDays())));

        return loginDate.isEmpty() || Math.abs(Days.daysBetween(new DateTime(), new DateTime(loginDate)).getDays()) >= 30;
    }

    public boolean isNew() {
        SharedPreferences sharedPref = context.getSharedPreferences(USER_PREFS_KEY, Context.MODE_PRIVATE);
        return sharedPref.getString(USER_KEY, "").isEmpty();
    }

}
