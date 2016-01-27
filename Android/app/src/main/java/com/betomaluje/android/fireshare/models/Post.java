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
    private String text;
    @Expose
    private ArrayList<Comment> comments;
    @Expose
    private String userImgUrl;
    @Expose
    private String date;
    @Expose
    private String userName;

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

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public ArrayList<Comment> getComments() {
        return comments;
    }

    public void setComments(ArrayList<Comment> comments) {
        this.comments = comments;
    }

    public String getUserImgUrl() {
        return userImgUrl;
    }

    public void setUserImgUrl(String imgUrl) {
        this.userImgUrl = imgUrl;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}
