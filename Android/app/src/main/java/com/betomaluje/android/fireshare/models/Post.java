package com.betomaluje.android.fireshare.models;

import com.google.gson.annotations.Expose;

import java.util.ArrayList;

/**
 * Created by betomaluje on 1/7/16.
 */
public class Post {

    @Expose
    private long id;
    @Expose
    private long likes;
    @Expose
    private String title;
    @Expose
    private ArrayList<Comment> comments;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getLikes() {
        return likes;
    }

    public void setLikes(long likes) {
        this.likes = likes;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public ArrayList<Comment> getComments() {
        return comments;
    }

    public void setComments(ArrayList<Comment> comments) {
        this.comments = comments;
    }
}
