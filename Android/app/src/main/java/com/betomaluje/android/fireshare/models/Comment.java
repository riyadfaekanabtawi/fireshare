package com.betomaluje.android.fireshare.models;

import com.google.gson.annotations.Expose;

/**
 * Created by betomaluje on 1/7/16.
 */
public class Comment {

    @Expose
    private long id;
    @Expose
    private String title;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
