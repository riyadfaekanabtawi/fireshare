package com.betomaluje.android.fireshare.services;

import android.content.Context;

import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.services.ServiceManager.ServiceManagerHandler;
import com.betomaluje.android.fireshare.utils.UserPreferences;
import com.google.gson.Gson;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.joda.time.DateTime;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by betomaluje on 2/1/16.
 */
public class UserManager {

    public static void login(final Context context, String name, String password, String tokenPush, final ServiceManagerHandler<User> callback) {
        RequestParams params = new RequestParams();
        params.put("email", name);
        params.put("password", password);
        params.put("device_token", tokenPush);

        FireShareRestClient.post("user/login", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, cz.msebera.android.httpclient.Header[] headers, JSONObject json) {
                super.onSuccess(statusCode, headers, json);

                if (json != null) {
                    if (json.has("Result")) {
                        //error
                        try {
                            callback.error(json.getString("Result"));
                        } catch (JSONException e) {
                            e.printStackTrace();
                            callback.error("null json");
                        }
                    } else {
                        UserPreferences.using(context).saveUser(json.toString());

                        Gson gson = new Gson();
                        callback.loaded(gson.fromJson(json.toString(), User.class));
                    }
                } else {
                    callback.error("null json");
                }
            }

            @Override
            public void onFailure(int statusCode, cz.msebera.android.httpclient.Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void register(final Context context, String email, String name, String tokenPush, String password, String passwordConfirmation,
                                String encodedImage, final ServiceManagerHandler<User> callback) {

        Map<String, String> user = new HashMap<>();
        user.put("email", email);
        user.put("name", name);
        user.put("password", password);
        user.put("password_confirmation", passwordConfirmation);
        user.put("device_token", tokenPush);

        //now the image
        //generated id
        String id = String.valueOf(System.currentTimeMillis());
        String date = new DateTime().toString("dd-MM-yyyy HH:mm:ss");

        Map<String, String> image = new HashMap<>();
        image.put("id", id);
        image.put("created_at", date);
        image.put("updated_at", date);
        image.put("image_url", "\"" + encodedImage + "\"");
        image.put("filename", "User-" + id + ".jpg");
        image.put("content_type", "image/jpg");
        image.put("password", password);
        image.put("password_confirmation", passwordConfirmation);

        RequestParams params = new RequestParams();
        params.put("user", user);
        params.put("image", image);

        FireShareRestClient.post("user/register", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, cz.msebera.android.httpclient.Header[] headers, JSONObject json) {
                super.onSuccess(statusCode, headers, json);

                if (json != null) {
                    UserPreferences.using(context).saveUser(json.toString());

                    Gson gson = new Gson();
                    callback.loaded(gson.fromJson(json.toString(), User.class));
                } else {
                    callback.error("null json");
                }
            }

            @Override
            public void onFailure(int statusCode, cz.msebera.android.httpclient.Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void getUser(String userId, final ServiceManagerHandler<User> callback) {
        RequestParams params = new RequestParams();
        params.put("id", userId);

        FireShareRestClient.get("show_user", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, cz.msebera.android.httpclient.Header[] headers, JSONObject json) {
                super.onSuccess(statusCode, headers, json);

                if (json != null) {
                    Gson gson = new Gson();
                    callback.loaded(gson.fromJson(json.toString(), User.class));
                } else {
                    callback.error("null json");
                }
            }

            @Override
            public void onFailure(int statusCode, cz.msebera.android.httpclient.Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

}
