package com.betomaluje.android.fireshare.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.betomaluje.android.fireshare.R;
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

    public CommentRecyclerAdapter(Context context, ArrayList<Comment> comments) {
        this.context = context;
        this.comments = comments;
        this.inflater = LayoutInflater.from(context);
    }

    public class CommentRowViewHolder extends RecyclerView.ViewHolder {

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

        public CommentRowViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }

        public void setDataIntoView(Context context, Comment comment, int position) {
            Picasso.with(context).load(comment.getUser().getUserImage(User.IMAGE_TYPE.SMALL))
                    .transform(new RoundedTransformation(8, 0))
                    .fit().centerCrop().placeholder(R.mipmap.ic_launcher).into(imageViewUserProfile);

            textViewUserName.setText(comment.getUser().getName());
            textViewComment.setText(comment.getText());

            imageViewHot.setVisibility(position == 0 ? View.VISIBLE : View.GONE);

            textViewDate.setText(comment.getDate());
        }
    }

    public void addComment(Comment comment) {
        comments.add(comment);
        notifyItemInserted(comments.size() - 1);
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
