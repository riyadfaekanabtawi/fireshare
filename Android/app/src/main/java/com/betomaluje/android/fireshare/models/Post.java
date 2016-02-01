package com.betomaluje.android.fireshare.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.joda.time.DateTime;
import org.joda.time.Days;

import java.util.ArrayList;

/**
 * Created by betomaluje on 1/7/16.
 */
public class Post {

    @Expose
    private long id;
    @Expose
    private long likes;
    @SerializedName("title")
    @Expose
    private String text;
    @Expose
    private ArrayList<Comment> comments;
    @Expose
    private User user;
    @SerializedName("created_at")
    @Expose
    private String createdAt;

    private String date;

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

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getDate() {

        int date = Math.abs(Days.daysBetween(new DateTime(), new DateTime(createdAt)).getDays());

        if (date == 0)
            return "Hoy";
        else if (date == 1)
            return "Hace " + date + " día";
        else if (date > 1 && date <= 30)
            return "Hace " + date + " días";
        else
            return "El " + new DateTime(createdAt).toString("MM/dd/yyyy");
    }

    public void setDate(String date) {
        this.date = date;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
