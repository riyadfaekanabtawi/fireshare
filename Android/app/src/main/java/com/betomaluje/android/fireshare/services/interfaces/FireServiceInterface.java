package com.betomaluje.android.fireshare.services.interfaces;

import com.betomaluje.android.fireshare.models.User;

import retrofit.Call;
import retrofit.http.Body;
import retrofit.http.POST;

/**
 * Created by betomaluje on 1/7/16.
 */
public interface FireServiceInterface {

    @POST("user/login")
    Call<User> login(@Body String name, @Body String password);

    @POST("user/register")
    Call<User> register();

}
