package com.betomaluje.android.fireshare.dialogs;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.Button;

import com.betomaluje.android.fireshare.FireShareApplication;
import com.betomaluje.android.fireshare.R;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 2/22/16.
 */
public class TermsAndConditionsDialog extends Dialog {

    @Bind(R.id.webView)
    WebView webView;

    @Bind(R.id.button_ok)
    Button buttonOk;

    @Bind(R.id.progressBar)
    View progressBar;

    public TermsAndConditionsDialog(Context context) {
        super(context, R.style.Theme_FullScreenDialog);
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        ((FireShareApplication) ((Activity) context).getApplication()).sendScreen("Vista Terminos y Condiciones");

        setContentView(R.layout.activity_terms_and_conditions);
        ButterKnife.bind(this);

        final Window window = getWindow();
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT);
        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        window.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#CC000000")));

        webView.loadUrl(context.getString(R.string.terms_and_conditions));

        webView.setWebChromeClient(new WebChromeClient() {

            @Override
            public void onProgressChanged(WebView view, int progress) {
                if (progress == 100) {
                    progressBar.setVisibility(View.GONE);
                }
            }
        });

        buttonOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cancel();
                dismiss();
            }
        });
    }
}
