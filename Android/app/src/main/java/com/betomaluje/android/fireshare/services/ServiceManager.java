package com.betomaluje.android.fireshare.services;

import android.content.Context;
import android.util.Log;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxCallback;
import com.androidquery.callback.AjaxStatus;
import com.betomaluje.android.fireshare.models.User;
import com.google.gson.Gson;

import org.joda.time.DateTime;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by betomaluje on 1/7/16.
 */
public class ServiceManager {

    private final String TAG = getClass().getSimpleName();

    private final String BASE = "http://fireshare.anabtatec-mobile.com/";

    private AQuery aq;

    private static ServiceManager instance;

    public static ServiceManager getInstance(Context context) {
        if (instance == null)
            instance = new ServiceManager(context);

        return instance;
    }

    private ServiceManager(Context context) {
        this.aq = new AQuery(context);
    }

    public void login(String name, String password, final ServiceManagerHandler<User> callback) {
        String url = BASE + "user/login";

        Map<String, String> params = new HashMap<>();
        params.put("password", password);
        params.put("name", name);

        aq.ajaxCancel();
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {

                if (json != null) {
                    Gson gson = new Gson();
                    callback.loaded(gson.fromJson(json.toString(), User.class));
                } else {
                    callback.error("null json");
                }

            }
        });
    }

    public void register(String email, String name, String password, String passwordConfirmation,
                         String encodedImage, final ServiceManagerHandler<User> callback) {
        String url = BASE + "user/register";

        Map<String, String> user = new HashMap<>();
        user.put("email", email);
        user.put("name", name);
        user.put("password", password);
        user.put("password_confirmation", passwordConfirmation);

        //now the image
        //generated id
        String id = String.valueOf(System.currentTimeMillis());
        String date = new DateTime().toString("dd-MM-yyyy HH:mm:ss");

        Map<String, String> image = new HashMap<>();
        image.put("id", id);
        image.put("created_at", date);
        image.put("updated_at", date);
        image.put("image_url", encodedImage);
        image.put("filename", "User-" + id + ".jpg");
        image.put("content_type", "image/jpg");
        image.put("password", password);
        image.put("password_confirmation", passwordConfirmation);

        Map<String, Map> megaMap = new HashMap<>();
        megaMap.put("user", user);
        megaMap.put("image", image);

        Log.d(TAG, "register map: " + megaMap.toString());
        Log.d(TAG, "-----------------------------------");
        printHashMap(user);
        Log.d(TAG, "-----------------------------------");
        printHashMap(image);

        aq.ajaxCancel();
        aq.ajax(url, megaMap, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {

                if (json != null) {
                    Gson gson = new Gson();
                    callback.loaded(gson.fromJson(json.toString(), User.class));
                } else {
                    callback.error("null json");
                }

            }
        });
    }

    private void printHashMap(Map<String, String> map) {
        for (Map.Entry<String, String> entry : map.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            Log.d(TAG, "( " + key + " , " + value + " )");
        }
    }

    public static abstract class ServiceManagerHandler<T> {

        public void loaded(T data) {

        }

        public void loaded(ArrayList<T> data) {

        }

        public void error(String error) {

        }
    }

}
