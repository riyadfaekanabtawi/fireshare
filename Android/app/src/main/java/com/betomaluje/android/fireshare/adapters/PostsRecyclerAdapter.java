package com.betomaluje.android.fireshare.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.models.Post;
import com.betomaluje.android.fireshare.viewholders.PostRowViewHolder;

import java.util.ArrayList;

/**
 * Created by betomaluje on 1/19/16.
 */
public class PostsRecyclerAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private Context context;
    private LayoutInflater inflater;
    private ArrayList<Post> posts;

    public PostsRecyclerAdapter(Context context, ArrayList<Post> posts) {
        this.context = context;
        this.posts = posts;
        this.inflater = LayoutInflater.from(context);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = inflater.inflate(R.layout.post_item_row, parent, false);
        return new PostRowViewHolder(context, view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof PostRowViewHolder) {
            ((PostRowViewHolder) holder).setDataIntoView(posts.get(position));
        }
    }

    @Override
    public int getItemCount() {
        //we have to add the header
        return posts.size();
    }
}
