package com.betomaluje.android.fireshare.viewholders;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.adapters.CommentPagerAdapter;
import com.betomaluje.android.fireshare.models.Post;
import com.squareup.picasso.Picasso;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 1/19/16.
 */
public class PostRowViewHolder extends RecyclerView.ViewHolder {

    @Bind(R.id.imageView_userProfile)
    ImageView imageViewUserProfile;

    @Bind(R.id.textView_userName)
    TextView textViewUserName;

    @Bind(R.id.textView_date)
    TextView textViewDate;

    @Bind(R.id.textView_postText)
    TextView textViewPostText;

    @Bind(R.id.viewPager_comments)
    ViewPager viewPagerComments;

    private Context context;

    public PostRowViewHolder(Context context, View itemView) {
        super(itemView);
        this.context = context;
        ButterKnife.bind(this, itemView);
    }

    public void setDataIntoView(Post post) {
        Picasso.with(context).load(post.getUserImgUrl()).fit().centerCrop().placeholder(R.mipmap.ic_launcher).into(imageViewUserProfile);

        textViewUserName.setText(post.getUserName());
        textViewDate.setText(post.getDate());
        textViewPostText.setText(post.getText());

        CommentPagerAdapter adapter = new CommentPagerAdapter(context, post.getComments());
        viewPagerComments.setAdapter(adapter);
        viewPagerComments.setClipToPadding(false);
    }
}
