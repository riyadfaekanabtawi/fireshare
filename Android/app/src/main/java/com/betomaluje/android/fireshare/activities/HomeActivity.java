package com.betomaluje.android.fireshare.activities;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.animation.OvershootInterpolator;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.adapters.PostsRecyclerAdapter;
import com.betomaluje.android.fireshare.bus.BusStation;
import com.betomaluje.android.fireshare.interfaces.OnPostClicked;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.services.ServiceManager;
import com.betomaluje.android.fireshare.utils.CustomLinearLayoutManager;
import com.betomaluje.android.fireshare.utils.RoundedTransformation;
import com.betomaluje.android.fireshare.utils.SystemUtils;
import com.betomaluje.android.fireshare.utils.UserPreferences;
import com.squareup.otto.Produce;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 1/19/16.
 */
public class HomeActivity extends AppCompatActivity {

    @Bind(R.id.recyclerView)
    RecyclerView recyclerView;

    @Bind(R.id.imageView_userProfile)
    ImageView imageViewUserProfile;

    @Bind(R.id.textView_userName)
    TextView textViewUserName;

    @Bind(R.id.editText_post)
    EditText editTextPost;

    @Bind(R.id.progressBar)
    ProgressBar progressBar;

    @Bind(R.id.toolbar)
    Toolbar toolbar;

    @Bind(R.id.imageButton_cancel)
    ImageButton imageButtonCancel;

    @Bind(R.id.imageButton_send)
    ImageButton imageButtonSend;

    boolean posting = false;
    private Post selectedPost;
    private ServiceManager serviceManager = ServiceManager.getInstance(HomeActivity.this);
    private User user;
    private PostsRecyclerAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        /*
        //for transitions
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Transition explode = new Explode();
            explode.excludeTarget(android.R.id.statusBarBackground, true);
            explode.excludeTarget(android.R.id.navigationBarBackground, true);
            getWindow().setEnterTransition(explode);
            //getWindow().setReenterTransition(explode);

            Transition move = new Slide();
            move.excludeTarget(android.R.id.statusBarBackground, true);
            move.excludeTarget(android.R.id.navigationBarBackground, true);
            getWindow().setSharedElementEnterTransition(move);
            //getWindow().setSharedElementReturnTransition(move);
        }
        */

        setContentView(R.layout.activity_home);
        ButterKnife.bind(this);

        toolbar.setBackgroundResource(R.drawable.left_right_gradient);
        setSupportActionBar(toolbar);

        editTextPost.clearFocus();
        SystemUtils.hideKeyboard(HomeActivity.this);

        user = UserPreferences.getInstance().using(HomeActivity.this).getUser();

        editTextPost.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View view, int keyCode, KeyEvent event) {
                if (keyCode == KeyEvent.KEYCODE_ENTER) {
                    if (!posting) {
                        postText();
                    }
                    return true;
                } else {
                    return false;
                }
            }
        });

        editTextPost.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toggleToolbarControls(true);
            }
        });

        imageButtonCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toggleToolbarControls(false);
                SystemUtils.hideKeyboard(HomeActivity.this);
            }
        });

        imageButtonSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!posting) {
                    postText();
                }
            }
        });

        CustomLinearLayoutManager layoutManager = new CustomLinearLayoutManager(HomeActivity.this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);

        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setHasFixedSize(true);

        textViewUserName.setText(user.getName());

        imageViewUserProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(HomeActivity.this, ProfileActivity.class);

                //ActivityOptionsCompat options = ActivityOptionsCompat.makeSceneTransitionAnimation(HomeActivity.this, v, "postView");
                //ActivityCompat.startActivity(HomeActivity.this, intent, options.toBundle());
                startActivity(intent);

                //now we send it to the event bus
                //BusStation.postOnMain(producePost());
                BusStation.postOnMain(produceUser());
            }
        });

        Picasso.with(HomeActivity.this).load(user.getUserImage())
                .transform(new RoundedTransformation(8, 0))
                .fit().centerCrop().placeholder(R.mipmap.icon_user).into(imageViewUserProfile);

        BusStation.getBus().register(this);
    }

    private class AnimationEndListener implements Animator.AnimatorListener {

        View mView;
        View mView2;
        boolean hiding;

        public AnimationEndListener(View v, View v2, boolean isHiding) {
            mView = v;
            mView2 = v2;
            hiding = isHiding;
        }

        @Override
        public void onAnimationStart(Animator animation) {
            mView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
            mView2.setLayerType(View.LAYER_TYPE_HARDWARE, null);

            if (!hiding) {
                mView.setVisibility(View.VISIBLE);
                mView2.setVisibility(View.VISIBLE);
            }
        }

        @Override
        public void onAnimationEnd(Animator animation) {
            mView.setLayerType(View.LAYER_TYPE_NONE, null);
            mView2.setLayerType(View.LAYER_TYPE_NONE, null);

            if (hiding) {
                mView.setVisibility(View.INVISIBLE);
                mView2.setVisibility(View.INVISIBLE);
            }
        }

        @Override
        public void onAnimationCancel(Animator animation) {
            mView.setLayerType(View.LAYER_TYPE_NONE, null);
            mView2.setLayerType(View.LAYER_TYPE_NONE, null);
        }

        @Override
        public void onAnimationRepeat(Animator animation) {

        }
    }

    private void toggleToolbarControls(boolean showControls) {
        if (!showControls) {
            //hide them
            ObjectAnimator tx1 = ObjectAnimator.ofFloat(imageButtonCancel, View.SCALE_X, 1, 0);
            ObjectAnimator ty1 = ObjectAnimator.ofFloat(imageButtonCancel, View.SCALE_Y, 1, 0);

            ObjectAnimator tx2 = ObjectAnimator.ofFloat(imageButtonSend, View.SCALE_X, 1, 0);
            ObjectAnimator ty2 = ObjectAnimator.ofFloat(imageButtonSend, View.SCALE_Y, 1, 0);

            AnimatorSet set = new AnimatorSet();
            set.playTogether(tx1, ty1, tx2, ty2);
            set.setDuration(400);
            set.setStartDelay(200);
            set.setInterpolator(new OvershootInterpolator());
            set.addListener(new AnimationEndListener(imageButtonSend, imageButtonCancel, true));
            set.start();
        } else {
            //show them
            ObjectAnimator tx1 = ObjectAnimator.ofFloat(imageButtonCancel, View.SCALE_X, 0, 1);
            ObjectAnimator ty1 = ObjectAnimator.ofFloat(imageButtonCancel, View.SCALE_Y, 0, 1);

            ObjectAnimator tx2 = ObjectAnimator.ofFloat(imageButtonSend, View.SCALE_X, 0, 1);
            ObjectAnimator ty2 = ObjectAnimator.ofFloat(imageButtonSend, View.SCALE_Y, 0, 1);

            AnimatorSet set = new AnimatorSet();
            set.playTogether(tx1, ty1, tx2, ty2);
            set.setDuration(400);
            set.setStartDelay(200);
            set.setInterpolator(new OvershootInterpolator());
            set.addListener(new AnimationEndListener(imageButtonSend, imageButtonCancel, false));
            set.start();
        }
    }

    private void fillPosts() {
        progressBar.setVisibility(View.VISIBLE);
        serviceManager.getPosts(new ServiceManager.ServiceManagerHandler<ArrayList<Post>>() {
            @Override
            public void loaded(ArrayList<Post> data) {
                super.loaded(data);
                adapter = new PostsRecyclerAdapter(HomeActivity.this, data);
                adapter.setOnPostClicked(onPostClicked);
                recyclerView.setAdapter(adapter);
                progressBar.setVisibility(View.GONE);
            }

            @Override
            public void error(String error) {
                super.error(error);
                progressBar.setVisibility(View.GONE);
            }
        });
    }

    private OnPostClicked onPostClicked = new OnPostClicked() {
        @Override
        public void onPostClicked(View v, int position, Post post) {
            Intent intent = new Intent(HomeActivity.this, PostActivity.class);
            Bundle b = new Bundle();
            b.putInt("mStartingPosition", position);
            b.putString("postId", String.valueOf(post.getId()));
            intent.putExtras(b);

            //ActivityOptionsCompat options = ActivityOptionsCompat.makeSceneTransitionAnimation(HomeActivity.this, v, "postView");
            //ActivityCompat.startActivity(HomeActivity.this, intent, options.toBundle());
            startActivity(intent);

            selectedPost = post;
            //now we send it to the event bus
            //BusStation.postOnMain(producePost());
            BusStation.postOnMain(produceUser());
        }
    };

    @Produce
    public Post producePost() {
        return selectedPost;
    }

    @Produce
    public User produceUser() {
        return user;
    }

    private void postText() {
        editTextPost.clearFocus();
        posting = true;

        String text = editTextPost.getText().toString();

        if (!text.isEmpty()) {
            Log.e("HOME", "Post text");
            SystemUtils.hideKeyboard(HomeActivity.this);

            serviceManager.createPost(String.valueOf(user.getId()), text, new ServiceManager.ServiceManagerHandler<Post>() {
                @Override
                public void loaded(Post data) {
                    super.loaded(data);
                    Toast.makeText(HomeActivity.this, "Agregaste tu post!", Toast.LENGTH_SHORT).show();
                    editTextPost.setText("");

                    adapter.addPost(data);
                    recyclerView.scrollToPosition(0);

                    toggleToolbarControls(false);

                    posting = false;
                }

                @Override
                public void error(String error) {
                    super.error(error);
                    Toast.makeText(HomeActivity.this, "Hubo un error agregando tu post. Intenta en unos momentos", Toast.LENGTH_LONG).show();
                    posting = false;
                }
            });
        } else {
            Toast.makeText(HomeActivity.this, "Para publicar, tienes que escribir algo", Toast.LENGTH_SHORT).show();
            posting = false;
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (adapter != null)
            adapter.notifyDataSetChanged();

        if (recyclerView != null) {
            fillPosts();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        BusStation.getBus().unregister(this);
    }
}
