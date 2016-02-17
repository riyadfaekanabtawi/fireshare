package com.betomaluje.android.fireshare.viewholders;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.support.v4.view.ViewCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.RecyclerView;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.activities.ProfileActivity;
import com.betomaluje.android.fireshare.adapters.CommentPagerAdapter;
import com.betomaluje.android.fireshare.interfaces.OnPostClicked;
import com.betomaluje.android.fireshare.models.Comment;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.utils.ImageUtils;
import com.betomaluje.android.fireshare.utils.RoundedTransformation;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 1/19/16.
 */
public class PostRowViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

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

    @Bind(R.id.linearLayout_users)
    LinearLayout linearLayoutUsers;

    @Bind(R.id.divider)
    View divider;

    @Bind(R.id.divider2)
    View divider2;

    private Context context;
    private OnPostClicked onPostClicked;
    private Post post;
    private int imageWidth;
    private int totalToDisplay = 3, actualLength;
    private ArrayList<View> views;

    public PostRowViewHolder(final Context context, final View itemView, OnPostClicked onPostClicked) {
        super(itemView);
        this.context = context;
        if (onPostClicked != null)
            this.onPostClicked = onPostClicked;

        ButterKnife.bind(this, itemView);
        itemView.setOnClickListener(this);
        viewPagerComments.setOnTouchListener(new View.OnTouchListener() {
            float oldX = 0, newX = 0, sens = 5;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        oldX = event.getX();
                        break;

                    case MotionEvent.ACTION_UP:
                        newX = event.getX();
                        if (Math.abs(oldX - newX) < sens) {
                            onClick(itemView);
                            return true;
                        }
                        oldX = 0;
                        newX = 0;
                        break;
                }

                return false;
            }
        });

        this.imageWidth = (int) ImageUtils.convertPixelsToDp(120, context.getResources());
    }

    public void setDataIntoView(final Post post) {
        this.post = post;
        Picasso.with(context).load(post.getUser().getUserImage(User.IMAGE_TYPE.SMALL))
                .transform(new RoundedTransformation(8, 0))
                .fit().centerCrop().placeholder(R.mipmap.icon_user).into(imageViewUserProfile);

        textViewUserName.setText(post.getUser().getName());
        textViewDate.setText(post.getDate(context));
        textViewPostText.setText(post.getText());

        linearLayoutUsers.removeAllViews();

        if (!post.getComments().isEmpty()) {
            viewPagerComments.setVisibility(View.VISIBLE);
            divider.setVisibility(View.VISIBLE);
            divider2.setVisibility(View.VISIBLE);
            linearLayoutUsers.setVisibility(View.VISIBLE);
            CommentPagerAdapter adapter = new CommentPagerAdapter(context, post.getComments());
            viewPagerComments.setAdapter(adapter);

            setUsers(post.getComments());

            viewPagerComments.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
                @Override
                public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

                }

                @Override
                public void onPageSelected(int position) {
                    if (views != null && position <= actualLength) {
                        for (int i = 0; i < actualLength; i++) {
                            View v = views.get(i);
                            if (i == position)
                                ViewCompat.setAlpha(v, 1f);
                            else
                                ViewCompat.setAlpha(v, 0.5f);
                        }
                    }
                }

                @Override
                public void onPageScrollStateChanged(int state) {

                }
            });
        } else {
            viewPagerComments.setVisibility(View.GONE);
            linearLayoutUsers.setVisibility(View.GONE);
            divider.setVisibility(View.GONE);
            divider2.setVisibility(View.GONE);
        }
        viewPagerComments.setClipToPadding(false);

        imageViewUserProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ProfileActivity.launchActivity(context, String.valueOf(post.getUser().getId()));
            }
        });
    }

    private void setUsers(ArrayList<Comment> comments) {
        boolean areThereMore = comments.size() > totalToDisplay;
        actualLength = areThereMore ? totalToDisplay : comments.size();

        views = new ArrayList<>(actualLength);

        for (int i = 0; i < actualLength; i++) {
            linearLayoutUsers.addView(createImage(comments.get(i), i));
        }

        if (areThereMore) {
            TextView textView = createTextView();
            String text;

            int remaining = comments.size() - totalToDisplay;

            if (remaining < 1000) {
                text = "+" + remaining;
            } else {
                text = "+" + (remaining / 1000) + "K";
            }

            textView.setText(text);
            linearLayoutUsers.addView(textView);
        }
    }

    private ImageView createImage(final Comment comment, int position) {
        ImageView imageView = new ImageView(context);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(imageWidth, imageWidth);
        if (position != 0)
            params.leftMargin = 8;
        imageView.setLayoutParams(params);
        Picasso.with(context).load(comment.getUser().getUserImage(User.IMAGE_TYPE.SMALL))
                .transform(new RoundedTransformation(8, 0))
                .fit().centerCrop().placeholder(R.mipmap.icon_user).into(imageView);

        if (position == 0)
            ViewCompat.setAlpha(imageView, 1f);
        else
            ViewCompat.setAlpha(imageView, 0.5f);

        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ProfileActivity.launchActivity(context, String.valueOf(comment.getUser().getId()));
            }
        });

        views.add(imageView);

        return imageView;
    }

    private TextView createTextView() {
        TextView textView = new TextView(context);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.MATCH_PARENT);
        params.leftMargin = 8;
        textView.setLayoutParams(params);
        textView.setTextSize(14);
        textView.setTypeface(Typeface.DEFAULT_BOLD);
        textView.setGravity(Gravity.CENTER);
        textView.setTextColor(Color.RED);
        return textView;
    }

    @Override
    public void onClick(View v) {
        int position = getLayoutPosition();

        if (onPostClicked != null && post != null)
            onPostClicked.onPostClicked(v, position, post);
    }
}
