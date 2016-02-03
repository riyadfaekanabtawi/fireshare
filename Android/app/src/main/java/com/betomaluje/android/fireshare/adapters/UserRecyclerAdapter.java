package com.betomaluje.android.fireshare.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.viewholders.PostRowViewHolder;
import com.betomaluje.android.fireshare.viewholders.UserHeaderRowViewHolder;

import java.util.ArrayList;

/**
 * Created by betomaluje on 2/2/16.
 */
public class UserRecyclerAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final int TYPE_HEADER = 0;
    private final int TYPE_ITEM = 1;

    private Context context;
    private LayoutInflater inflater;
    private ArrayList<Post> posts;
    private User user;

    public UserRecyclerAdapter(Context context, User user) {
        this.context = context;
        this.inflater = LayoutInflater.from(context);
        this.user = user;
        this.posts = user.getPosts();
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        if (viewType == TYPE_HEADER) {
            View view = inflater.inflate(R.layout.user_header_item_row, parent, false);
            return new UserHeaderRowViewHolder(context, view);
        } else {
            View view = inflater.inflate(R.layout.post_item_row, parent, false);
            return new PostRowViewHolder(context, view, null);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof UserHeaderRowViewHolder) {
            ((UserHeaderRowViewHolder) holder).setDataIntoView(user);
        } else if (holder instanceof PostRowViewHolder) {
            ((PostRowViewHolder) holder).setDataIntoView(posts.get(position - 1));
        }
    }

    @Override
    public int getItemViewType(int position) {
        return position == 0 ? TYPE_HEADER : TYPE_ITEM;
    }

    @Override
    public int getItemCount() {
        return posts.size() + 1;
    }
}
