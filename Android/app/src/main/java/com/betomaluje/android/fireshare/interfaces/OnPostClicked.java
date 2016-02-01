package com.betomaluje.android.fireshare.interfaces;

import android.view.View;

import com.betomaluje.android.fireshare.models.Post;

/**
 * Created by betomaluje on 1/28/16.
 */
public interface OnPostClicked {

    void onPostClicked(View v, int position, Post post);

}
