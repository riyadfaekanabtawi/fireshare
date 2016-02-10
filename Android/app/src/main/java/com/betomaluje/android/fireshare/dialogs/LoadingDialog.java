package com.betomaluje.android.fireshare.dialogs;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.Window;
import android.view.WindowManager;

import com.betomaluje.android.fireshare.R;

/**
 * Created by betomaluje on 10/13/15.
 */
public class LoadingDialog extends Dialog {

    public LoadingDialog(Activity activity) {
        super(activity, R.style.Theme_FullScreenDialog);

        setCanceledOnTouchOutside(true);
        setCancelable(true);
        setContentView(R.layout.progress_dialog);

        final Window window = getWindow();
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT);
        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        window.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#CCF8F8F8")));
    }
}
