package com.betomaluje.android.fireshare.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.bus.BusStation;
import com.betomaluje.android.fireshare.interfaces.OnCommentClicked;
import com.betomaluje.android.fireshare.interfaces.OnPostClicked;
import com.betomaluje.android.fireshare.models.Comment;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.services.ServiceManager;
import com.squareup.otto.Subscribe;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 2/18/16.
 */
public class WarningDialog extends Dialog {

    public enum TYPE {
        REPORT_COMMENT, REPORT_POST, DELETE_COMMENT, DELETE_POST
    }

    private TYPE type;

    @Bind(R.id.textView_text)
    TextView textViewText;

    @Bind(R.id.button_ok)
    Button buttonOk;

    @Bind(R.id.button_cancel)
    Button buttonCancel;

    private Context context;
    private String text;
    private boolean isReport;

    private OnCommentClicked onCommentClicked;
    private OnPostClicked onPostClicked;

    public WarningDialog(Context context, TYPE type) {
        super(context, R.style.Theme_FullScreenDialog);

        setCanceledOnTouchOutside(true);
        setCancelable(true);
        setContentView(R.layout.warning_dialog);
        ButterKnife.bind(this);

        final Window window = getWindow();
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT);
        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        window.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#CC000000")));

        this.context = context;
        this.type = type;

        isReport = type == TYPE.REPORT_COMMENT || type == TYPE.REPORT_POST;

        if (isReport) {
            text = context.getString(R.string.warning_dialog_text_report);
        } else {
            text = context.getString(R.string.warning_dialog_text_delete);
        }

        buttonCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cancel();
                dismiss();
            }
        });
    }

    public WarningDialog(Context context, TYPE type, final OnCommentClicked onCommentClicked, final Comment comment) {
        super(context, R.style.Theme_FullScreenDialog);

        setCanceledOnTouchOutside(true);
        setCancelable(true);
        setContentView(R.layout.warning_dialog);
        ButterKnife.bind(this);

        final Window window = getWindow();
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT);
        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        window.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#CC000000")));

        this.context = context;
        this.type = type;
        this.onCommentClicked = onCommentClicked;

        isReport = type == TYPE.REPORT_COMMENT || type == TYPE.REPORT_POST;

        if (isReport) {
            text = context.getString(R.string.warning_dialog_text_report);
        } else {
            text = context.getString(R.string.warning_dialog_text_delete);

            buttonOk.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (onCommentClicked != null) {
                        onCommentClicked.onCommentClicked(v, -1, comment);
                    }

                    cancel();
                    dismiss();
                }
            });
        }

        buttonCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cancel();
                dismiss();
            }
        });
    }

    public WarningDialog(Context context, final TYPE type, final OnPostClicked onPostClicked) {
        super(context, R.style.Theme_FullScreenDialog);

        setCanceledOnTouchOutside(true);
        setCancelable(true);
        setContentView(R.layout.warning_dialog);
        ButterKnife.bind(this);

        final Window window = getWindow();
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT);
        window.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        window.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#CC000000")));

        this.context = context;
        this.type = type;
        this.onPostClicked = onPostClicked;

        isReport = type == TYPE.REPORT_COMMENT || type == TYPE.REPORT_POST;

        if (isReport) {
            text = context.getString(R.string.warning_dialog_text_report);
        } else {
            text = context.getString(R.string.warning_dialog_text_delete);

            buttonOk.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (onPostClicked != null) {
                        onPostClicked.onPostClicked(v, -1, null);
                    }

                    cancel();
                    dismiss();
                }
            });
        }

        buttonCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cancel();
                dismiss();
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        BusStation.getBus().register(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        BusStation.getBus().unregister(this);
    }

    @Subscribe
    public void onData(final Comment comment) {

        if (isReport) {
            textViewText.setText(String.format(text, comment.getUser().getName(), comment.getText()));

            buttonOk.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    ServiceManager.getInstance(context).reportComment(String.valueOf(comment.getId()), new ServiceManager.ServiceManagerHandler<Boolean>() {
                        @Override
                        public void loaded(Boolean data) {
                            super.loaded(data);
                            cancel();
                            dismiss();
                            createToast(context.getString(R.string.comment_report_success));
                        }

                        @Override
                        public void error(String error) {
                            super.error(error);
                            cancel();
                            dismiss();
                            createToast(context.getString(R.string.comment_report_success));
                        }
                    });
                }
            });
        } else {
            textViewText.setText(text);
        }
    }

    @Subscribe
    public void onData(final Post post) {
        if (isReport) {
            textViewText.setText(String.format(text, post.getUser().getName(), post.getText()));

            buttonOk.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    ServiceManager.getInstance(context).reportPost(String.valueOf(post.getId()), new ServiceManager.ServiceManagerHandler<Boolean>() {
                        @Override
                        public void loaded(Boolean data) {
                            super.loaded(data);
                            cancel();
                            dismiss();
                            createToast(context.getString(R.string.post_report_success));
                        }

                        @Override
                        public void error(String error) {
                            super.error(error);
                            cancel();
                            dismiss();
                            createToast(context.getString(R.string.error_report));
                        }
                    });
                }
            });
        } else {
            textViewText.setText(text);
        }
    }

    private void createToast(String message) {
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
    }

}
