package com.betomaluje.android.fireshare.models;

import com.betomaluje.android.fireshare.services.FireShareRestClient;
import com.betomaluje.android.fireshare.services.ServiceManager;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by betomaluje on 1/7/16.
 */
public class User {

    public static enum IMAGE_TYPE {
        SMALL, MEDIUM, ORIGINAL
    }

    @Expose
    private String avatar;
    @SerializedName("device_token")
    @Expose
    private String deviceToken;
    @Expose
    private String email;
    @Expose
    private long id;
    @Expose
    private String name;
    @SerializedName("recipes")
    @Expose
    private ArrayList<Post> posts;
    @SerializedName("avatar_file_name")
    @Expose
    private String avatarFileName;

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getAvatarFileName() {
        return avatarFileName;
    }

    public void setAvatarFileName(String avatarFileName) {
        this.avatarFileName = avatarFileName;
    }

    public String getDeviceToken() {
        return deviceToken;
    }

    public void setDeviceToken(String deviceToken) {
        this.deviceToken = deviceToken;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ArrayList<Post> getPosts() {
        return posts;
    }

    public void setPosts(ArrayList<Post> posts) {
        this.posts = posts;
    }

    public String getUserImage() {
        return getUserImage(IMAGE_TYPE.SMALL);
    }

    public String getUserImage(IMAGE_TYPE imageType) {
        if (avatar == null || avatar.isEmpty()) {
            String type;

            switch (imageType) {
                case SMALL:
                    type = "small";
                    break;
                case MEDIUM:
                    type = "medium";
                    break;
                case ORIGINAL:
                    type = "original";
                    break;
                default:
                    type = "small";
                    break;
            }
            return FireShareRestClient.BASE_URL + "assets/users/" + id + "/" + type + "/" + avatarFileName;
        } else {
            return FireShareRestClient.BASE_URL + avatar;
        }
    }
}
