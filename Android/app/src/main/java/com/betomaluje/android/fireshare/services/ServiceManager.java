package com.betomaluje.android.fireshare.services;

import android.content.Context;

import com.betomaluje.android.fireshare.models.Comment;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.models.User;

import java.util.ArrayList;

/**
 * Created by betomaluje on 1/7/16.
 */
public class ServiceManager {

    private Context context;

    private static ServiceManager instance;

    public static ServiceManager getInstance(Context context) {
        if (instance == null)
            instance = new ServiceManager(context);

        return instance;
    }

    private ServiceManager(Context context) {
        this.context = context;
    }

    /*
    ===============  USERS ===============
     */
    public void login(String name, String password, final ServiceManagerHandler<User> callback) {
        UserManager.login(context, name, password, callback);
    }

    public void register(String email, String name, String password, String passwordConfirmation,
                         String encodedImage, final ServiceManagerHandler<User> callback) {
        UserManager.register(context, email, name, password, passwordConfirmation, encodedImage, callback);
    }

    public void getUser(String userId, final ServiceManagerHandler<User> callback) {
        UserManager.getUser(userId, callback);
    }

    /*
    ===============  POSTS ===============
     */
    public void createPost(String userId, String text, final ServiceManagerHandler<Post> callback) {
        PostManager.createPost(userId, text, callback);
    }

    public void getPosts(final ServiceManagerHandler<ArrayList<Post>> callback) {
        PostManager.getPosts(callback);
    }

    public void likePost(String userId, String postId, final ServiceManagerHandler<Post> callback) {
        PostManager.likePost(userId, postId, callback);
    }

    /*
    ===============  COMMENTS ===============
     */
    public void createComment(String userId, String postId, String text, final ServiceManagerHandler<Comment> callback) {
        CommentManager.createComment(userId, postId, text, callback);
    }

    public static abstract class ServiceManagerHandler<T> {

        public void loaded(T data) {

        }

        public void error(String error) {

        }
    }

}
