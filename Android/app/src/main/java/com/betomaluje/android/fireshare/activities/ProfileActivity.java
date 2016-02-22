package com.betomaluje.android.fireshare.activities;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.betomaluje.android.fireshare.FireShareApplication;
import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.adapters.UserRecyclerAdapter;
import com.betomaluje.android.fireshare.bus.BusStation;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.services.ServiceManager;
import com.betomaluje.android.fireshare.utils.CustomLinearLayoutManager;
import com.squareup.otto.Subscribe;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 2/2/16.
 */
public class ProfileActivity extends AppCompatActivity {

    @Bind(R.id.toolbar_userName)
    TextView toolbarUserName;

    @Bind(R.id.recyclerView)
    RecyclerView recyclerView;

    @Bind(R.id.progressBar)
    ProgressBar progressBar;

    @Bind(R.id.toolbar)
    Toolbar toolbar;

    private UserRecyclerAdapter adapter;
    private boolean fromBusEvent;

    public static void launchActivity(Context context, String userId) {
        Intent profileIntent = new Intent(context, ProfileActivity.class);
        Bundle b = new Bundle();
        b.putString("userId", userId);
        profileIntent.putExtras(b);

        //ActivityOptionsCompat options = ActivityOptionsCompat.makeSceneTransitionAnimation(HomeActivity.this, v, "postView");
        //ActivityCompat.startActivity(HomeActivity.this, intent, options.toBundle());
        context.startActivity(profileIntent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ((FireShareApplication) getApplication()).sendScreen("Vista Detalle Usuario");

        setContentView(R.layout.activity_profile);
        ButterKnife.bind(this);

        toolbar.setBackgroundResource(R.drawable.left_right_gradient);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("");

        CustomLinearLayoutManager layoutManager = new CustomLinearLayoutManager(ProfileActivity.this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);

        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setHasFixedSize(true);

        fromBusEvent = true;

        Bundle b = getIntent().getExtras();
        if (b != null) {
            fromBusEvent = false;
            searchUserProfile(b.getString("userId", ""));
        }
    }

    @Subscribe
    public void getUser(final User user) {
        progressBar.setVisibility(View.VISIBLE);

        searchUserProfile(String.valueOf(user.getId()));
    }

    private void searchUserProfile(String userId) {
        if (userId == null || userId.isEmpty()) {
            Toast.makeText(ProfileActivity.this, R.string.error_no_user, Toast.LENGTH_SHORT).show();

            finish();
            return;
        }

        ServiceManager.getInstance(ProfileActivity.this).getUser(userId, new ServiceManager.ServiceManagerHandler<User>() {
            @Override
            public void loaded(User data) {
                super.loaded(data);
                toolbarUserName.setText(data.getName());
                adapter = new UserRecyclerAdapter(ProfileActivity.this, data);
                recyclerView.setAdapter(adapter);

                progressBar.setVisibility(View.GONE);
            }

            @Override
            public void error(String error) {
                super.error(error);

                progressBar.setVisibility(View.GONE);

                Toast.makeText(ProfileActivity.this, R.string.error_no_user, Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            // Respond to the action bar's Up/Home button
            case android.R.id.home:
                //supportFinishAfterTransition();
                ActivityCompat.finishAfterTransition(this);
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (fromBusEvent)
            BusStation.getBus().register(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (fromBusEvent)
            BusStation.getBus().unregister(this);
    }
}
