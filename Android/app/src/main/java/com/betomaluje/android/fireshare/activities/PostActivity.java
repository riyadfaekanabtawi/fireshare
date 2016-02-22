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

import com.betomaluje.android.fireshare.FireShareApplication;
import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.adapters.CommentRecyclerAdapter;
import com.betomaluje.android.fireshare.bus.BusStation;
import com.betomaluje.android.fireshare.dialogs.LoadingDialog;
import com.betomaluje.android.fireshare.dialogs.WarningDialog;
import com.betomaluje.android.fireshare.interfaces.OnCommentClicked;
import com.betomaluje.android.fireshare.interfaces.OnPostClicked;
import com.betomaluje.android.fireshare.models.Comment;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.services.ServiceManager;
import com.betomaluje.android.fireshare.utils.CustomLinearLayoutManager;
import com.betomaluje.android.fireshare.utils.RoundedTransformation;
import com.betomaluje.android.fireshare.utils.SystemUtils;
import com.squareup.otto.Produce;
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
    private int clickedPosition = -1;

    private String idPost;
    private Post post;
    private Comment comment;
    private User user;
    private CommentRecyclerAdapter adapter;
    private ServiceManager serviceManager = ServiceManager.getInstance(PostActivity.this);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //ActivityCompat.postponeEnterTransition(this);

        ((FireShareApplication) getApplication()).sendScreen("Vista Detalle Post");

        setContentView(R.layout.activity_post);
        ButterKnife.bind(this);
        loadingDialog = new LoadingDialog(PostActivity.this);

        toolbar.setBackgroundResource(R.drawable.left_right_gradient);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("");

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
                new WarningDialog(PostActivity.this, WarningDialog.TYPE.REPORT_POST).show();
                BusStation.postOnMain(producePost());
            }
        });

        imageButtonDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new WarningDialog(PostActivity.this, WarningDialog.TYPE.DELETE_POST, warningDialogPostClickListener).show();
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
                    ((FireShareApplication) getApplication()).sendEvent("Post", "Comment Post", "Comment Post");

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
            public void loaded(final Post data) {
                super.loaded(data);
                post = data;

                if (imageViewUserProfile != null) {
                    Picasso.with(PostActivity.this).load(post.getUser().getUserImage())
                            .transform(new RoundedTransformation(8, 0))
                            .fit().centerCrop().placeholder(R.mipmap.icon_user).into(imageViewUserProfile);

                    imageViewUserProfile.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            ProfileActivity.launchActivity(PostActivity.this, String.valueOf(data.getUser().getId()));
                        }
                    });
                }

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

    private OnCommentClicked warningDialogCommentClickListener = new OnCommentClicked() {
        @Override
        public void onCommentClicked(View v, final int position, final Comment comment) {
            switch (v.getId()) {
                case R.id.button_ok:
                    loadingDialog.show();
                    serviceManager.deleteComment(String.valueOf(comment.getId()), new ServiceManager.ServiceManagerHandler<Boolean>() {
                        @Override
                        public void loaded(Boolean data) {
                            super.loaded(data);

                            ((FireShareApplication) getApplication()).sendEvent("Comment", "Delete Comment", "Delete Comment");

                            loadingDialog.cancel();
                            loadingDialog.dismiss();
                            Toast.makeText(PostActivity.this, R.string.success_delete, Toast.LENGTH_SHORT).show();
                            adapter.removeComment(clickedPosition);
                        }

                        @Override
                        public void error(String error) {
                            super.error(error);
                            loadingDialog.cancel();
                            loadingDialog.dismiss();
                            Toast.makeText(PostActivity.this, R.string.error_delete, Toast.LENGTH_SHORT).show();
                        }
                    });

                    break;
            }
        }
    };

    private OnPostClicked warningDialogPostClickListener = new OnPostClicked() {
        @Override
        public void onPostClicked(View v, int position, Post post) {
            switch (v.getId()) {
                case R.id.button_ok:
                    loadingDialog.show();
                    serviceManager.deletePost(idPost, new ServiceManager.ServiceManagerHandler<Boolean>() {
                        @Override
                        public void loaded(Boolean data) {
                            super.loaded(data);

                            ((FireShareApplication) getApplication()).sendEvent("Post", "Delete Post", "Delete Post");

                            loadingDialog.cancel();
                            loadingDialog.dismiss();
                            Toast.makeText(PostActivity.this, R.string.success_delete, Toast.LENGTH_SHORT).show();
                            finish();
                        }

                        @Override
                        public void error(String error) {
                            super.error(error);
                            loadingDialog.cancel();
                            loadingDialog.dismiss();
                            Toast.makeText(PostActivity.this, R.string.error_delete, Toast.LENGTH_SHORT).show();
                        }
                    });
                    break;
            }
        }
    };

    private OnCommentClicked onCommentClicked = new OnCommentClicked() {
        @Override
        public void onCommentClicked(View v, final int position, final Comment comment) {
            PostActivity.this.comment = comment;

            clickedPosition = position;

            switch (v.getId()) {
                case R.id.imageButton_like:
                    serviceManager.likeComment(String.valueOf(user.getId()), comment, position, new ServiceManager.ServiceManagerHandler<Comment>() {
                        @Override
                        public void loaded(Comment data, int position) {
                            super.loaded(data);

                            ((FireShareApplication) getApplication()).sendEvent("Comment", "Like Comment", "Like Comment");

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

                            ((FireShareApplication) getApplication()).sendEvent("Comment", "UnLike Comment", "UnLike Comment");

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
                    new WarningDialog(PostActivity.this, WarningDialog.TYPE.REPORT_COMMENT).show();
                    BusStation.postOnMain(produceComment());
                    break;
                case R.id.imageButton_delete:
                    new WarningDialog(PostActivity.this, WarningDialog.TYPE.DELETE_COMMENT, warningDialogCommentClickListener, comment).show();
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

    @Produce
    public Post producePost() {
        return post;
    }

    @Produce
    public Comment produceComment() {
        return comment;
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

            idPost = b.getString("postId", "");

            getPost(idPost);
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
