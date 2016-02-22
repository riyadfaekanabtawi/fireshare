package com.betomaluje.android.fireshare.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;

import com.betomaluje.android.fireshare.R;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 2/18/16.
 */
public class ErrorDialog extends Dialog {

    @Bind(R.id.button_ok)
    Button buttonOk;

    public ErrorDialog(Context context) {
        super(context, R.style.Theme_FullScreenDialog);
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        setContentView(R.layout.error_dialog);
        ButterKnife.bind(this);

        final Window window = getWindow();
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT);
        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        window.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#CC000000")));

        buttonOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cancel();
                dismiss();
            }
        });
    }
}
