package com.betomaluje.android.fireshare.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

/**
 * Created by betomaluje on 2/24/16.
 */
public class VersionCheck {

    @SerializedName("Version")
    @Expose
    private String version;

    @SerializedName("URL_ANDROID")
    private String url;

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
