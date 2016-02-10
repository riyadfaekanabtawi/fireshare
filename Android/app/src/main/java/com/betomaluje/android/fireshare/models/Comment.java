package com.betomaluje.android.fireshare.models;

import android.content.Context;

import com.betomaluje.android.fireshare.utils.DateUtils;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

/**
 * Created by betomaluje on 1/7/16.
 */
public class Comment {

    @Expose
    private long id;
    @SerializedName("content")
    @Expose
    private String text;
    @Expose
    private User user;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("voted_string")
    private String votedString;

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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getVotedString() {
        return votedString;
    }

    public void setVotedString(String votedString) {
        this.votedString = votedString;
    }

    public String getDate(Context context) {
        return DateUtils.getDate(context, createdAt);
    }

    public boolean userDidVote() {
        return !votedString.endsWith("false");
    }

    public boolean userDidUpVote() {
        return votedString.endsWith("up");
    }

    public boolean userDidDownVote() {
        return votedString.endsWith("down");
    }
}
