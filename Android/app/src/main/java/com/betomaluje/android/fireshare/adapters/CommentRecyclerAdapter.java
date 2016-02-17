package com.betomaluje.android.fireshare.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.interfaces.OnCommentClicked;
import com.betomaluje.android.fireshare.models.Comment;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.utils.RoundedTransformation;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 1/27/16.
 */
public class CommentRecyclerAdapter extends RecyclerView.Adapter<CommentRecyclerAdapter.CommentRowViewHolder> {

    private Context context;
    private LayoutInflater inflater;
    private ArrayList<Comment> comments;
    private OnCommentClicked onCommentClicked;
    private long userId;

    public CommentRecyclerAdapter(Context context, long userId, ArrayList<Comment> comments, OnCommentClicked onCommentClicked) {
        this.context = context;
        this.userId = userId;
        this.comments = comments;
        this.onCommentClicked = onCommentClicked;
        this.inflater = LayoutInflater.from(context);
    }

    public class CommentRowViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        @Bind(R.id.imageView_userProfile)
        ImageView imageViewUserProfile;

        @Bind(R.id.textView_userName)
        TextView textViewUserName;

        @Bind(R.id.textView_comment)
        TextView textViewComment;

        @Bind(R.id.textView_date)
        TextView textViewDate;

        @Bind(R.id.imageView_hot)
        ImageView imageViewHot;

        @Bind(R.id.imageButton_like)
        ImageButton imageButtonLike;

        @Bind(R.id.imageButton_dislike)
        ImageButton imageButtonDislike;

        @Bind(R.id.imageButton_report)
        ImageButton imageButtonReport;

        @Bind(R.id.imageButton_delete)
        ImageButton imageButtonDelete;

        public CommentRowViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
            imageButtonLike.setOnClickListener(this);
            imageButtonDislike.setOnClickListener(this);
            imageButtonReport.setOnClickListener(this);
            imageButtonDelete.setOnClickListener(this);
        }

        public void setDataIntoView(Context context, Comment comment, int position) {
            Picasso.with(context).load(comment.getUser().getUserImage(User.IMAGE_TYPE.SMALL))
                    .transform(new RoundedTransformation(8, 0))
                    .fit().centerCrop().placeholder(R.mipmap.icon_user).into(imageViewUserProfile);

            textViewUserName.setText(comment.getUser().getName());
            textViewComment.setText(comment.getText());

            imageViewHot.setVisibility(position == 0 ? View.VISIBLE : View.GONE);

            textViewDate.setText(comment.getDate(context));

            imageButtonDelete.setVisibility(comment.getUser().getId() == userId ? View.VISIBLE : View.GONE);

            changeButtonColors(comment);
        }

        private void changeButtonColors(Comment comment) {
            if (comment.userDidVote()) {
                imageButtonLike.setImageResource(comment.userDidUpVote() ? R.mipmap.heart_on : R.mipmap.heart_off);
                imageButtonDislike.setImageResource(comment.userDidDownVote() ? R.mipmap.heart_break_on : R.mipmap.heart_break_off);
            } else {
                imageButtonLike.setImageResource(R.mipmap.heart_off);
                imageButtonDislike.setImageResource(R.mipmap.heart_break_off);
            }
        }

        @Override
        public void onClick(View v) {
            int position = getLayoutPosition();
            if (onCommentClicked != null)
                onCommentClicked.onCommentClicked(v, position, comments.get(position));
        }
    }

    public void addComment(Comment comment) {
        comments.add(comment);
        notifyItemInserted(comments.size() - 1);
    }

    public void removeComment(int position) {
        comments.remove(position);
        notifyItemChanged(position);
    }

    public void modifyComment(Comment comment, int position) {
        comments.set(position, comment);
        notifyItemChanged(position);
    }

    @Override
    public CommentRowViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = inflater.inflate(R.layout.comment_item_row_2, parent, false);
        return new CommentRowViewHolder(view);
    }

    @Override
    public void onBindViewHolder(CommentRowViewHolder holder, int position) {
        holder.setDataIntoView(context, comments.get(position), position);
    }

    @Override
    public int getItemCount() {
        return comments.size();
    }
}
