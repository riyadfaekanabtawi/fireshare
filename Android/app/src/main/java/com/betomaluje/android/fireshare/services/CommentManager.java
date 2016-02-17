package com.betomaluje.android.fireshare.services;

import com.betomaluje.android.fireshare.models.Comment;
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

    public static void create(String userId, String postId, String text, final ServiceManagerHandler<Comment> callback) {
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
                    Comment comment = new Gson().fromJson(response.toString(), Comment.class);

                    callback.loaded(comment);
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String responseString, Throwable throwable) {
                super.onFailure(statusCode, headers, responseString, throwable);
                callback.error("null json");
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void like(String userId, final Comment comment, final int position, final ServiceManagerHandler<Comment> callback) {
        RequestParams params = new RequestParams();
        params.put("id_user", userId);
        params.put("id_comment", comment.getId());

        FireShareRestClient.post("likeComment", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                super.onSuccess(statusCode, headers, response);
                try {
                    callback.loaded(new Gson().fromJson(response.toString(), Comment.class), position);
                } catch (Exception e) {
                    callback.error("null json");
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void dislike(String userId, final Comment comment, final int position, final ServiceManagerHandler<Comment> callback) {
        RequestParams params = new RequestParams();
        params.put("id_user", userId);
        params.put("id_comment", comment.getId());

        FireShareRestClient.post("dislikeComment", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                super.onSuccess(statusCode, headers, response);
                try {
                    callback.loaded(new Gson().fromJson(response.toString(), Comment.class), position);
                } catch (Exception e) {
                    callback.error("null json");
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void report(String idComment, final ServiceManagerHandler<Boolean> callback) {
        RequestParams params = new RequestParams();
        params.put("id", idComment);

        FireShareRestClient.post("denounceComment", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                super.onSuccess(statusCode, headers, response);
                if (response.has("Result")) {
                    try {
                        if (response.getString("Result").equals("Comment has been denounced")) {
                            callback.loaded(true);
                        } else {
                            callback.error("null json");
                        }

                    } catch (JSONException e) {
                        callback.error("null json");
                    }
                } else {
                    callback.error("null json");
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }

    public static void delete(String idComment, final ServiceManagerHandler<Boolean> callback) {
        RequestParams params = new RequestParams();
        params.put("id", idComment);

        FireShareRestClient.get("deleteComment", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                super.onSuccess(statusCode, headers, response);
                if (response.has("Result")) {
                    try {
                        if (response.getString("Result").equals("Comment deleted")) {
                            callback.loaded(true);
                        } else {
                            callback.error("null json");
                        }

                    } catch (JSONException e) {
                        callback.error("null json");
                    }
                } else {
                    callback.error("null json");
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String responseString, Throwable throwable) {
                super.onFailure(statusCode, headers, responseString, throwable);
                callback.error("null json");
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                callback.error("null json");
            }
        });
    }
}
