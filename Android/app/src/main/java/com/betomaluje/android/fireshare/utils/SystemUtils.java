package com.betomaluje.android.fireshare.utils;

import android.app.Activity;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;

/**
 * Created by betomaluje on 2/1/16.
 */
public class SystemUtils {

    public static void hideKeyboard(Activity activity) {
        activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

        if (activity.getCurrentFocus() != null) {
            InputMethodManager inputMethodManager = (InputMethodManager) activity.getSystemService(Activity.INPUT_METHOD_SERVICE);
            inputMethodManager.hideSoftInputFromWindow(activity.getCurrentFocus().getWindowToken(), 0);
        }
    }

}
