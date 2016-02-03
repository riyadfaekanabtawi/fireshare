package com.betomaluje.android.fireshare.services;

import com.betomaluje.android.fireshare.models.Comment;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.services.ServiceManager.ServiceManagerHandler;
import com.google.gson.Gson;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.joda.time.DateTime;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import cz.msebera.android.httpclient.Header;

/**
 * Created by betomaluje on 2/1/16.
 */
public class CommentManager {

    public static void createComment(String userId, String postId, String text, final ServiceManagerHandler<Comment> callback) {
        Map<String, String> user = new HashMap<>();
        user.put("id", userId);

        Map<String, String> post = new HashMap<>();
        post.put("id", postId);

        //comentario
        String id = String.valueOf(System.currentTimeMillis());
        String date = new DateTime().toString("dd-MM-yyyy HH:mm:ss");

        Map<String, String> comment = new HashMap<>();
        comment.put("id", id);
        comment.put("content", text);
        comment.put("recipe_id", postId);
        comment.put("created_at", date);
        comment.put("updated_at", date);

        RequestParams params = new RequestParams();
        params.put("user_posting", user);
        params.put("recipe_commented", post);
        params.put("comment", comment);

        FireShareRestClient.post("comment/create", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                super.onSuccess(statusCode, headers, response);
                if (response.has("Result")) {
                    //error
                    try {
                        callback.error(response.getString("Result"));
                    } catch (JSONException e) {
                        callback.error("null json");
                    }
                } else {
                    Post post = new Gson().fromJson(response.toString(), Post.class);

                    callback.loaded(post.getComments().get(post.getComments().size() - 1));
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void like(String userId, String idComment, final ServiceManagerHandler<Comment> callback) {
        RequestParams params = new RequestParams();
        params.put("id_user", userId);
        params.put("id_comment", idComment);

        FireShareRestClient.post("likeComment", params, new JsonHttpResponseHandler() {
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
                    callback.loaded(new Gson().fromJson(response.toString(), Comment.class));
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void dislike(String userId, String idComment, final ServiceManagerHandler<Comment> callback) {
        RequestParams params = new RequestParams();
        params.put("id_user", userId);
        params.put("id_comment", idComment);

        FireShareRestClient.post("dislikeComment", params, new JsonHttpResponseHandler() {
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
                    callback.loaded(new Gson().fromJson(response.toString(), Comment.class));
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
