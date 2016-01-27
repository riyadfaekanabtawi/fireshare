package com.betomaluje.android.fireshare.models;

import com.google.gson.annotations.Expose;

/**
 * Created by betomaluje on 1/7/16.
 */
public class Comment {

    @Expose
    private long id;
    @Expose
    private String text;
    @Expose
    private String userImgUrl;
    @Expose
    private String userName;
    @Expose
    private boolean isHot;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getUserImgUrl() {
        return userImgUrl;
    }

    public void setUserImgUrl(String userImgUrl) {
        this.userImgUrl = userImgUrl;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public boolean isHot() {
        return isHot;
    }

    public void setIsHot(boolean isHot) {
        this.isHot = isHot;
    }
}
