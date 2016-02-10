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
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.adapters.CommentRecyclerAdapter;
import com.betomaluje.android.fireshare.bus.BusStation;
import com.betomaluje.android.fireshare.dialogs.LoadingDialog;
import com.betomaluje.android.fireshare.interfaces.OnCommentClicked;
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

    @Bind(R.id.imageButton_report)
    ImageButton imageButtonReport;

    @Bind(R.id.imageButton_delete)
    ImageButton imageButtonDelete;

    @Bind(R.id.textView_postText)
    TextView textViewPostText;

    @Bind(R.id.recyclerView_comments)
    RecyclerView recyclerViewComments;

    @Bind(R.id.editText_comment)
    EditText editTextComment;

    @Bind(R.id.button_send)
    ImageButton buttonSend;

    @Bind(R.id.toolbar)
    Toolbar toolbar;

    private static final String STATE_STARTING_PAGE_POSITION = "state_starting_page_position";
    private static final String STATE_CURRENT_PAGE_POSITION = "state_current_page_position";

    private int mStartingPosition;
    private int mCurrentPosition;

    private boolean posting = false;
    private LoadingDialog loadingDialog;

    private Post post;
    private User user;
    private CommentRecyclerAdapter adapter;
    private ServiceManager serviceManager = ServiceManager.getInstance(PostActivity.this);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //ActivityCompat.postponeEnterTransition(this);

        setContentView(R.layout.activity_post);
        ButterKnife.bind(this);
        loadingDialog = new LoadingDialog(PostActivity.this);

        toolbar.setBackgroundResource(R.drawable.left_right_gradient);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        mStartingPosition = 0;

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

        imageButtonReport.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                serviceManager.reportPost(String.valueOf(post.getId()), new ServiceManager.ServiceManagerHandler<Boolean>() {
                    @Override
                    public void loaded(Boolean data) {
                        super.loaded(data);
                        createToast(getString(R.string.post_report_success));
                    }

                    @Override
                    public void error(String error) {
                        super.error(error);
                        createToast(getString(R.string.error_report));
                    }
                });
            }
        });

        imageButtonDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });

    }

    private void postComment() {
        SystemUtils.hideKeyboard(PostActivity.this);
        posting = true;
        loadingDialog.show();

        String text = editTextComment.getText().toString();

        if (!text.isEmpty()) {
            Log.e("HOME", "Post comment");
            serviceManager.createComment(String.valueOf(user.getId()), String.valueOf(post.getId()), text, new ServiceManager.ServiceManagerHandler<Comment>() {
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
                    loadingDialog.dismiss();
                    loadingDialog.cancel();
                }

                @Override
                public void error(String error) {
                    super.error(error);
                    Toast.makeText(PostActivity.this, "Hubo un error agregando tu post. Intenta en unos momentos", Toast.LENGTH_LONG).show();
                    posting = false;
                    loadingDialog.dismiss();
                    loadingDialog.cancel();
                }
            });
        } else {
            Toast.makeText(PostActivity.this, "Por favor ingresa algo", Toast.LENGTH_SHORT).show();
            posting = false;
            loadingDialog.dismiss();
            loadingDialog.cancel();
        }
    }

    public void getPost(String postId) {
        if (postId.isEmpty())
            return;

        loadingDialog.show();

        ServiceManager.getInstance(PostActivity.this).getPost(String.valueOf(user.getId()), postId, new ServiceManager.ServiceManagerHandler<Post>() {
            @Override
            public void loaded(Post data) {
                super.loaded(data);
                post = data;

                if (imageViewUserProfile != null)
                    Picasso.with(PostActivity.this).load(post.getUser().getUserImage())
                            .transform(new RoundedTransformation(8, 0))
                            .fit().centerCrop().placeholder(R.mipmap.icon_user).into(imageViewUserProfile);

                if (textViewUserName != null)
                    textViewUserName.setText(post.getUser().getName());

                if (textViewDate != null)
                    textViewDate.setText(post.getDate(PostActivity.this));

                if (textViewPostText != null)
                    textViewPostText.setText(post.getText());

                if (recyclerViewComments != null) {
                    adapter = new CommentRecyclerAdapter(PostActivity.this, user.getId(), post.getComments(), onCommentClicked);
                    recyclerViewComments.setAdapter(adapter);
                }

                imageButtonReport.setVisibility(View.VISIBLE);
                imageButtonDelete.setVisibility(data.getUser().getId() == user.getId() ? View.VISIBLE : View.GONE);

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

    private OnCommentClicked onCommentClicked = new OnCommentClicked() {
        @Override
        public void onCommentClicked(View v, int position, final Comment comment) {
            switch (v.getId()) {
                case R.id.imageButton_like:
                    serviceManager.likeComment(String.valueOf(user.getId()), comment, position, new ServiceManager.ServiceManagerHandler<Comment>() {
                        @Override
                        public void loaded(Comment data, int position) {
                            super.loaded(data);
                            if (adapter != null) {
                                adapter.modifyComment(data, position);
                            }
                        }

                        @Override
                        public void error(String error) {
                            super.error(error);
                            createToast(getString(R.string.error_like));
                        }
                    });
                    break;
                case R.id.imageButton_dislike:
                    serviceManager.dislikeComment(String.valueOf(user.getId()), comment, position, new ServiceManager.ServiceManagerHandler<Comment>() {
                        @Override
                        public void loaded(Comment data, int position) {
                            super.loaded(data);
                            if (adapter != null) {
                                adapter.modifyComment(data, position);
                            }
                        }

                        @Override
                        public void error(String error) {
                            super.error(error);
                            createToast(getString(R.string.error_dislike));
                        }
                    });
                    break;
                case R.id.imageButton_report:
                    serviceManager.reportComment(String.valueOf(comment.getId()), new ServiceManager.ServiceManagerHandler<Boolean>() {
                        @Override
                        public void loaded(Boolean data) {
                            super.loaded(data);
                            createToast(getString(R.string.comment_report_success));
                        }

                        @Override
                        public void error(String error) {
                            super.error(error);
                            //createToast(getString(R.string.error_report));
                            createToast(getString(R.string.comment_report_success));
                        }
                    });
                    break;
                case R.id.imageButton_delete:

                    break;
            }
        }
    };

    private void createToast(String message) {
        Toast.makeText(PostActivity.this, message, Toast.LENGTH_SHORT).show();
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
    protected void onStart() {
        super.onStart();
        BusStation.getBus().register(this);

        Bundle b = getIntent().getExtras();
        if (b != null) {

            if (b.containsKey("mStartingPosition")) {
                mStartingPosition = b.getInt("mStartingPosition", 0);
            }

            getPost(b.getString("postId", ""));
        }
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
