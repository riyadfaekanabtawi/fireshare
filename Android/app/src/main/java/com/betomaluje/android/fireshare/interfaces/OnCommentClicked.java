package com.betomaluje.android.fireshare.interfaces;

import android.view.View;

import com.betomaluje.android.fireshare.models.Comment;

/**
 * Created by betomaluje on 2/4/16.
 */
public interface OnCommentClicked {

    void onCommentClicked(View v, int position, Comment comment);

}
