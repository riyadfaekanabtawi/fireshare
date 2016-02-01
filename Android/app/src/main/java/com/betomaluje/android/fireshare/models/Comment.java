package com.betomaluje.android.fireshare.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.joda.time.DateTime;
import org.joda.time.Days;

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
    @Expose
    private boolean isHot;
    @SerializedName("created_at")
    @Expose
    private String createdAt;

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

    public boolean isHot() {
        return isHot;
    }

    public void setIsHot(boolean isHot) {
        this.isHot = isHot;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getDate() {
        if (createdAt == null || createdAt.isEmpty())
            return "";

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
}
