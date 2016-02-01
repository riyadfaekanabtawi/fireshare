package com.betomaluje.android.fireshare.services;

import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.services.ServiceManager.ServiceManagerHandler;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import cz.msebera.android.httpclient.Header;

/**
 * Created by betomaluje on 2/1/16.
 */
public class PostManager {

    public static void createPost(String userId, String text, final ServiceManagerHandler<Post> callback) {
        if (!text.endsWith("..."))
            text += "...";

        RequestParams params = new RequestParams();
        params.put("id", userId);
        params.put("title", text);

        FireShareRestClient.post("/recipe/create", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                super.onSuccess(statusCode, headers, response);
                if (response.has("Result")) {
                    //error
                    try {
                        callback.error(response.getString("Description"));
                    } catch (JSONException e) {
                        callback.error("null json");
                    }
                } else {
                    callback.loaded(new Gson().fromJson(response.toString(), Post.class));
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void getPosts(final ServiceManagerHandler<ArrayList<Post>> callback) {
        FireShareRestClient.get("/posts", null, new JsonHttpResponseHandler() {

            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONArray response) {
                super.onSuccess(statusCode, headers, response);

                if (response != null && response.length() > 0) {
                    Gson gson = new Gson();
                    Type t = new TypeToken<ArrayList<Post>>() {
                    }.getType();
                    ArrayList<Post> posts = (ArrayList<Post>) gson.fromJson(response.toString(), t);
                    callback.loaded(posts);
                } else {
                    callback.error("null json");
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONArray errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void likePost(String userId, String postId, final ServiceManagerHandler<Post> callback) {
        Map<String, String> user = new HashMap<>();
        user.put("id", userId);

        Map<String, String> post = new HashMap<>();
        post.put("id", postId);

        RequestParams params = new RequestParams();
        params.put("user", user);
        params.put("post", post);

        FireShareRestClient.post("/like", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                super.onSuccess(statusCode, headers, response);
                if (response.has("Result")) {
                    //error
                    try {
                        callback.error(response.getString("Description"));
                    } catch (JSONException e) {
                        callback.error("null json");
                    }
                } else {
                    callback.loaded(new Gson().fromJson(response.toString(), Post.class));
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }
}
