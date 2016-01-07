package com.betomaluje.android.fireshare.services;

import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.services.interfaces.FireServiceInterface;

import retrofit.Call;
import retrofit.Callback;
import retrofit.GsonConverterFactory;
import retrofit.Retrofit;

/**
 * Created by betomaluje on 1/7/16.
 */
public class ServiceManager {

    private final String BASE = "http://fireshare.anabtatec-mobile.com/";

    private FireServiceInterface fireServiceInterface;

    private static ServiceManager instance;

    public static ServiceManager getInstance() {
        if (instance == null)
            instance = new ServiceManager();

        return instance;
    }

    public ServiceManager() {
        Retrofit retrofit = new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create())
                .baseUrl(BASE)
                .build();

        fireServiceInterface = retrofit.create(FireServiceInterface.class);
    }

    public void login(String user, String password, Callback<User> callback) {
        Call<User> call = fireServiceInterface.login(user, password);
        call.enqueue(callback);
    }

    public void register(String email, String name, String password, String passwordConfirmation,
                         String encodedImage, Callback<User> callback) {
        Call<User> call = fireServiceInterface.register();
        call.enqueue(callback);
    }

}
