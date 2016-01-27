package com.betomaluje.android.fireshare.activities;

import android.os.Bundle;
import android.support.v4.view.ViewCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.adapters.PostsRecyclerAdapter;
import com.betomaluje.android.fireshare.models.Comment;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.utils.CustomLinearLayoutManager;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.Random;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 1/19/16.
 */
public class HomeActivity extends AppCompatActivity {

    Random r = new Random();
    boolean posting = false;

    @Bind(R.id.recyclerView)
    RecyclerView recyclerView;

    @Bind(R.id.imageView_userProfile)
    ImageView imageViewUserProfile;

    @Bind(R.id.textView_userName)
    TextView textViewUserName;

    @Bind(R.id.editText_post)
    EditText editTextPost;

    @Bind(R.id.toolbar)
    Toolbar toolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        ButterKnife.bind(this);

        toolbar.setBackgroundResource(R.drawable.left_right_gradient);
        setSupportActionBar(toolbar);

        editTextPost.clearFocus();
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

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

        CustomLinearLayoutManager layoutManager = new CustomLinearLayoutManager(HomeActivity.this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);

        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setHasFixedSize(true);

        //TEST
        fillDummyPosts();

        Picasso.with(HomeActivity.this).load(getImageUrl()).fit().centerCrop().placeholder(R.mipmap.ic_launcher).into(imageViewUserProfile);
    }

    private void fillDummyPosts() {
        ArrayList<Post> posts = new ArrayList<>();

        for (int i = 1; i <= 30; i++) {
            Post post = new Post();

            post.setId(i);
            post.setLikes(r.nextInt(10000));
            post.setText("Title " + i);
            post.setUserName("User " + i);
            post.setUserImgUrl(getImageUrl());
            post.setDate(String.format("Hace %d días", i));

            int totalComments = r.nextInt(20) + 1;

            ArrayList<Comment> comments = new ArrayList<>(totalComments);

            for (int j = 1; j <= totalComments; j++) {
                Comment comment = new Comment();
                comment.setId(j);
                comment.setText("Comment " + j);
                comment.setUserName("User " + j);
                comment.setUserImgUrl(getImageUrl());
                comment.setIsHot(j == 1);

                comments.add(comment);
            }

            post.setComments(comments);

            posts.add(post);
        }

        PostsRecyclerAdapter adapter = new PostsRecyclerAdapter(HomeActivity.this, posts);
        recyclerView.setAdapter(adapter);
    }

    private String getImageUrl() {
        return String.format("https://graph.facebook.com/%s/picture?type=small", r.nextInt(99999999 - 2000000) + 2000000);
    }

    private void postText() {
        posting = true;
        Log.e("HOME", "Post text");
    }
}
