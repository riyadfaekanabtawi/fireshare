package com.betomaluje.android.fireshare.adapters;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.models.Comment;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 1/27/16.
 */
public class CommentPagerAdapter extends PagerAdapter {

    private Context context;
    private LayoutInflater inflater;
    private ArrayList<Comment> comments;

    private SparseArray<View> views;

    @Bind(R.id.imageView_userProfile)
    ImageView imageViewUserProfile;

    @Bind(R.id.textView_userName)
    TextView textViewUserName;

    @Bind(R.id.textView_comment)
    TextView textViewComment;

    @Bind(R.id.imageView_hot)
    ImageView imageViewHot;

    public CommentPagerAdapter(Context context, ArrayList<Comment> comments) {
        this.context = context;
        this.comments = comments;
        this.inflater = LayoutInflater.from(context);

        views = new SparseArray<>(comments.size());
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        View itemView = views.get(position);

        if (itemView == null) {
            itemView = inflater.inflate(R.layout.comment_item_row, container, false);

            views.put(position, itemView);
        }

        ButterKnife.bind(this, itemView);

        Comment comment = comments.get(position);

        Picasso.with(context).load(comment.getUserImgUrl()).fit().centerCrop().placeholder(R.mipmap.ic_launcher).into(imageViewUserProfile);

        textViewUserName.setText(comment.getUserName());
        textViewComment.setText(comment.getText());

        imageViewHot.setVisibility(comment.isHot() ? View.VISIBLE : View.GONE);

        container.addView(itemView);

        return itemView;
    }

    @Override
    public int getCount() {
        return comments.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
    }
}
