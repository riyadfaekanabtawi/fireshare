package com.betomaluje.android.fireshare.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.adapters.CommentRecyclerAdapter;
import com.betomaluje.android.fireshare.bus.BusStation;
import com.betomaluje.android.fireshare.models.Comment;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.services.ServiceManager;
import com.betomaluje.android.fireshare.utils.CustomLinearLayoutManager;
import com.betomaluje.android.fireshare.utils.RoundedTransformation;
import com.betomaluje.android.fireshare.utils.SystemUtils;
import com.squareup.otto.Subscribe;
import com.squareup.picasso.Picasso;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 1/28/16.
 */
public class PostActivity extends AppCompatActivity {

    @Bind(R.id.imageView_userProfile)
    ImageView imageViewUserProfile;

    @Bind(R.id.textView_userName)
    TextView textViewUserName;

    @Bind(R.id.textView_date)
    TextView textViewDate;

    @Bind(R.id.textView_postText)
    TextView textViewPostText;

    @Bind(R.id.recyclerView_comments)
    RecyclerView recyclerViewComments;

    @Bind(R.id.editText_comment)
    EditText editTextComment;

    @Bind(R.id.button_send)
    Button buttonSend;

    @Bind(R.id.toolbar)
    Toolbar toolbar;

    private static final String STATE_STARTING_PAGE_POSITION = "state_starting_page_position";
    private static final String STATE_CURRENT_PAGE_POSITION = "state_current_page_position";

    private int mStartingPosition;
    private int mCurrentPosition;

    private boolean posting = false;

    private Post post;
    private User user;
    private CommentRecyclerAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //ActivityCompat.postponeEnterTransition(this);

        setContentView(R.layout.activity_post);
        ButterKnife.bind(this);

        toolbar.setBackgroundResource(R.drawable.left_right_gradient);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        mStartingPosition = 0;

        Bundle b = getIntent().getExtras();
        if (b != null && b.containsKey("mStartingPosition")) {
            mStartingPosition = b.getInt("mStartingPosition", 0);
        }

        if (savedInstanceState == null) {
            mCurrentPosition = mStartingPosition;
        } else {
            mCurrentPosition = savedInstanceState.getInt(STATE_CURRENT_PAGE_POSITION);
        }

        CustomLinearLayoutManager layoutManager = new CustomLinearLayoutManager(PostActivity.this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);

        recyclerViewComments.setLayoutManager(layoutManager);
        recyclerViewComments.setHasFixedSize(true);

        buttonSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!posting) {
                    postComment();
                }
            }
        });

        BusStation.getBus().register(this);
    }

    private void postComment() {
        SystemUtils.hideKeyboard(PostActivity.this);
        posting = true;

        String text = editTextComment.getText().toString();

        if (!text.isEmpty()) {
            Log.e("HOME", "Post comment");
            ServiceManager.getInstance(PostActivity.this).createComment(String.valueOf(user.getId()), String.valueOf(post.getId()), text, new ServiceManager.ServiceManagerHandler<Comment>() {
                @Override
                public void loaded(Comment data) {
                    super.loaded(data);
                    Toast.makeText(PostActivity.this, "Agregaste tu comentario!", Toast.LENGTH_SHORT).show();
                    editTextComment.setText("");
                    editTextComment.clearFocus();

                    if (adapter != null) {
                        adapter.addComment(data);
                        recyclerViewComments.scrollToPosition(adapter.getItemCount() - 1);
                    }

                    posting = false;
                }

                @Override
                public void error(String error) {
                    super.error(error);
                    Toast.makeText(PostActivity.this, "Hubo un error agregando tu post. Intenta en unos momentos", Toast.LENGTH_LONG).show();
                    posting = false;
                }
            });
        } else {
            Toast.makeText(PostActivity.this, "Por favor ingresa algo", Toast.LENGTH_SHORT).show();
            posting = false;
        }
    }

    @Subscribe
    public void getPost(Post post) {
        this.post = post;

        if (imageViewUserProfile != null)
            Picasso.with(PostActivity.this).load(post.getUser().getUserImage())
                    .transform(new RoundedTransformation(8, 0))
                    .fit().centerCrop().placeholder(R.mipmap.ic_launcher).into(imageViewUserProfile);

        if (textViewUserName != null)
            textViewUserName.setText(post.getUser().getName());

        if (textViewDate != null)
            textViewDate.setText(post.getDate());

        if (textViewPostText != null)
            textViewPostText.setText(post.getText());

        if (recyclerViewComments != null) {
            adapter = new CommentRecyclerAdapter(PostActivity.this, post.getComments());
            recyclerViewComments.setAdapter(adapter);
        }
    }

    @Subscribe
    public void getUser(User user) {
        this.user = user;
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
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt(STATE_CURRENT_PAGE_POSITION, mCurrentPosition);
    }

    @Override
    public void finishAfterTransition() {
        Intent data = new Intent();
        data.putExtra(STATE_STARTING_PAGE_POSITION, mStartingPosition);
        data.putExtra(STATE_CURRENT_PAGE_POSITION, mCurrentPosition);
        setResult(RESULT_OK, data);
        super.finishAfterTransition();
    }

    @Override
    protected void onPause() {
        super.onPause();
        BusStation.getBus().unregister(this);
    }
}
