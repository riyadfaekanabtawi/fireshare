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
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.animation.OvershootInterpolator;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.adapters.PostsRecyclerAdapter;
import com.betomaluje.android.fireshare.bus.BusStation;
import com.betomaluje.android.fireshare.dialogs.LoadingDialog;
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

    @Bind(R.id.textView_remaining)
    TextView textViewRemaining;

    @Bind(R.id.editText_post)
    EditText editTextPost;

    @Bind(R.id.toolbar)
    Toolbar toolbar;

    @Bind(R.id.imageButton_logout)
    ImageButton imageButtonLogout;

    @Bind(R.id.imageButton_editProfile)
    ImageButton imageButtonEditProfile;

    @Bind(R.id.imageButton_cancel)
    ImageButton imageButtonCancel;

    @Bind(R.id.imageButton_send)
    ImageButton imageButtonSend;

    boolean posting = false;
    private ServiceManager serviceManager = ServiceManager.getInstance(HomeActivity.this);
    private User user;
    private PostsRecyclerAdapter adapter;
    private int totalCharacters;
    private OvershootInterpolator overshootInterpolator = new OvershootInterpolator();

    private LoadingDialog loadingDialog;

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
        loadingDialog = new LoadingDialog(HomeActivity.this);

        toolbar.setBackgroundResource(R.drawable.left_right_gradient);
        setSupportActionBar(toolbar);

        editTextPost.clearFocus();
        SystemUtils.hideKeyboard(HomeActivity.this);

        user = UserPreferences.using(HomeActivity.this).getUser();

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

        imageButtonCancel.setOnClickListener(barButtonListener);
        imageButtonSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!posting) {
                    postText();
                }
            }
        });
        imageButtonLogout.setOnClickListener(barButtonListener);
        imageButtonEditProfile.setOnClickListener(barButtonListener);

        CustomLinearLayoutManager layoutManager = new CustomLinearLayoutManager(HomeActivity.this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);

        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setHasFixedSize(true);

        textViewUserName.setText(user.getName());

        imageViewUserProfile.setOnClickListener(barButtonListener);

        Picasso.with(HomeActivity.this).load(user.getUserImage())
                .transform(new RoundedTransformation(8, 0))
                .fit().centerCrop().placeholder(R.mipmap.icon_user).into(imageViewUserProfile);

        totalCharacters = getResources().getInteger(R.integer.max_characters);
        editTextPost.addTextChangedListener(mTextEditorWatcher);

        textViewRemaining.setText(String.format(getString(R.string.remaining_characters), totalCharacters));
    }

    private View.OnClickListener barButtonListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.imageButton_logout:
                    UserPreferences.using(HomeActivity.this).saveUser("");

                    startActivity(new Intent(HomeActivity.this, LoginActivity.class));
                    finish();
                    break;
                case R.id.imageButton_editProfile:
                    Intent updateIntent = new Intent(HomeActivity.this, RegisterActivity.class);
                    updateIntent.putExtra("update", true);
                    startActivity(updateIntent);

                    finish();
                    break;
                case R.id.imageButton_cancel:
                    toggleToolbarControls(false);
                    SystemUtils.hideKeyboard(HomeActivity.this);
                    break;
                case R.id.imageButton_send:

                    break;
                case R.id.imageView_userProfile:
                    Intent profileIntent = new Intent(HomeActivity.this, ProfileActivity.class);

                    //ActivityOptionsCompat options = ActivityOptionsCompat.makeSceneTransitionAnimation(HomeActivity.this, v, "postView");
                    //ActivityCompat.startActivity(HomeActivity.this, intent, options.toBundle());
                    startActivity(profileIntent);

                    //now we send it to the event bus
                    //BusStation.postOnMain(producePost());
                    BusStation.postOnMain(produceUser());
                    break;
            }
        }
    };

    private final TextWatcher mTextEditorWatcher = new TextWatcher() {
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        public void onTextChanged(CharSequence s, int start, int before, int count) {
            //This sets a textview to the current length
            int remain = totalCharacters - s.length();
            textViewRemaining.setText(String.format(getString(R.string.remaining_characters), remain));
        }

        public void afterTextChanged(Editable s) {
        }
    };

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
            } else {
                imageButtonEditProfile.setVisibility(View.VISIBLE);
                imageButtonLogout.setVisibility(View.VISIBLE);
            }
        }

        @Override
        public void onAnimationEnd(Animator animation) {
            mView.setLayerType(View.LAYER_TYPE_NONE, null);
            mView2.setLayerType(View.LAYER_TYPE_NONE, null);

            if (hiding) {
                mView.setVisibility(View.GONE);
                mView2.setVisibility(View.GONE);

                ObjectAnimator tx1 = ObjectAnimator.ofFloat(imageButtonLogout, View.SCALE_X, 0, 1);
                ObjectAnimator ty1 = ObjectAnimator.ofFloat(imageButtonLogout, View.SCALE_Y, 0, 1);

                ObjectAnimator tx2 = ObjectAnimator.ofFloat(imageButtonEditProfile, View.SCALE_X, 0, 1);
                ObjectAnimator ty2 = ObjectAnimator.ofFloat(imageButtonEditProfile, View.SCALE_Y, 0, 1);

                AnimatorSet set = new AnimatorSet();
                set.playTogether(tx1, ty1, tx2, ty2);
                set.setDuration(400);
                set.setInterpolator(overshootInterpolator);
                set.start();
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

    private Animator.AnimatorListener hideControlsListener = new Animator.AnimatorListener() {
        @Override
        public void onAnimationStart(Animator animation) {
            imageButtonEditProfile.setVisibility(View.GONE);
            imageButtonLogout.setVisibility(View.GONE);
        }

        @Override
        public void onAnimationEnd(Animator animation) {
            ObjectAnimator tx1 = ObjectAnimator.ofFloat(imageButtonCancel, View.SCALE_X, 0, 1);
            ObjectAnimator ty1 = ObjectAnimator.ofFloat(imageButtonCancel, View.SCALE_Y, 0, 1);

            ObjectAnimator tx2 = ObjectAnimator.ofFloat(imageButtonSend, View.SCALE_X, 0, 1);
            ObjectAnimator ty2 = ObjectAnimator.ofFloat(imageButtonSend, View.SCALE_Y, 0, 1);

            AnimatorSet set = new AnimatorSet();
            set.playTogether(tx1, ty1, tx2, ty2);
            set.setDuration(400);
            set.setStartDelay(200);
            set.setInterpolator(overshootInterpolator);
            set.addListener(new AnimationEndListener(imageButtonSend, imageButtonCancel, false));
            set.start();
        }

        @Override
        public void onAnimationCancel(Animator animation) {

        }

        @Override
        public void onAnimationRepeat(Animator animation) {

        }
    };

    private void toggleToolbarControls(boolean showControls) {
        if (!showControls) {
            //hide them and show logout
            ObjectAnimator tx1 = ObjectAnimator.ofFloat(imageButtonCancel, View.SCALE_X, 1, 0);
            ObjectAnimator ty1 = ObjectAnimator.ofFloat(imageButtonCancel, View.SCALE_Y, 1, 0);

            ObjectAnimator tx2 = ObjectAnimator.ofFloat(imageButtonSend, View.SCALE_X, 1, 0);
            ObjectAnimator ty2 = ObjectAnimator.ofFloat(imageButtonSend, View.SCALE_Y, 1, 0);

            AnimatorSet set = new AnimatorSet();
            set.playTogether(tx1, ty1, tx2, ty2);
            set.setDuration(400);
            set.setStartDelay(200);
            set.setInterpolator(overshootInterpolator);
            set.addListener(new AnimationEndListener(imageButtonSend, imageButtonCancel, true));
            set.start();

        } else {
            //show them, hide logout
            ObjectAnimator tx1 = ObjectAnimator.ofFloat(imageButtonLogout, View.SCALE_X, 1, 0);
            ObjectAnimator ty1 = ObjectAnimator.ofFloat(imageButtonLogout, View.SCALE_Y, 1, 0);

            ObjectAnimator tx2 = ObjectAnimator.ofFloat(imageButtonEditProfile, View.SCALE_X, 1, 0);
            ObjectAnimator ty2 = ObjectAnimator.ofFloat(imageButtonEditProfile, View.SCALE_Y, 1, 0);

            AnimatorSet set = new AnimatorSet();
            set.playTogether(tx1, ty1, tx2, ty2);
            set.setDuration(400);
            set.setInterpolator(overshootInterpolator);
            set.addListener(hideControlsListener);
            set.start();
        }
    }

    private void fillPosts() {
        loadingDialog.show();
        serviceManager.getPosts(new ServiceManager.ServiceManagerHandler<ArrayList<Post>>() {
            @Override
            public void loaded(ArrayList<Post> data) {
                super.loaded(data);
                adapter = new PostsRecyclerAdapter(HomeActivity.this, data);
                adapter.setOnPostClicked(onPostClicked);
                recyclerView.setAdapter(adapter);
                loadingDialog.dismiss();
                loadingDialog.cancel();
            }

            @Override
            public void error(String error) {
                super.error(error);
                loadingDialog.dismiss();
                loadingDialog.cancel();
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

            //now we send it to the event bus
            BusStation.postOnMain(produceUser());
        }
    };

    @Produce
    public User produceUser() {
        return user;
    }

    private void postText() {
        editTextPost.clearFocus();
        posting = true;
        loadingDialog.show();

        String text = editTextPost.getText().toString();

        if (text.length() > totalCharacters) {
            text = text.substring(0, totalCharacters);
        }

        if (!text.isEmpty()) {
            Log.e("HOME", "Post text");
            SystemUtils.hideKeyboard(HomeActivity.this);

            serviceManager.createPost(String.valueOf(user.getId()), text, new ServiceManager.ServiceManagerHandler<Post>() {
                @Override
                public void loaded(Post data) {
                    super.loaded(data);
                    Toast.makeText(HomeActivity.this, "Agregaste tu post!", Toast.LENGTH_SHORT).show();
                    editTextPost.setText("");

                    if (adapter == null) {
                        ArrayList<Post> temp = new ArrayList<Post>(1);
                        temp.add(data);
                        adapter = new PostsRecyclerAdapter(HomeActivity.this, temp);
                    }

                    adapter.addPost(data);
                    adapter.notifyDataSetChanged();
                    recyclerView.scrollToPosition(0);

                    toggleToolbarControls(false);

                    posting = false;
                    loadingDialog.dismiss();
                    loadingDialog.cancel();
                }

                @Override
                public void error(String error) {
                    super.error(error);
                    Toast.makeText(HomeActivity.this, "Hubo un error agregando tu post. Intenta en unos momentos", Toast.LENGTH_LONG).show();
                    posting = false;
                    loadingDialog.dismiss();
                    loadingDialog.cancel();
                }
            });
        } else {
            Toast.makeText(HomeActivity.this, "Para publicar, tienes que escribir algo", Toast.LENGTH_SHORT).show();
            posting = false;
            loadingDialog.dismiss();
            loadingDialog.cancel();
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
    protected void onStart() {
        super.onStart();
        BusStation.getBus().register(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        BusStation.getBus().unregister(this);
        if (loadingDialog.isShowing()) {
            loadingDialog.dismiss();
            loadingDialog.cancel();
        }
    }
}
