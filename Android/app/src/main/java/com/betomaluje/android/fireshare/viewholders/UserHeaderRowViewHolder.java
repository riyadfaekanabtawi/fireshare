package com.betomaluje.android.fireshare.viewholders;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.betomaluje.android.fireshare.R;
import com.betomaluje.android.fireshare.models.User;
import com.betomaluje.android.fireshare.utils.RoundedTransformation;
import com.squareup.picasso.Picasso;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by betomaluje on 2/2/16.
 */
public class UserHeaderRowViewHolder extends RecyclerView.ViewHolder {

    @Bind(R.id.imageView_userProfile)
    ImageView imageViewUserProfile;

    @Bind(R.id.textView_userName)
    TextView textViewUserName;

    @Bind(R.id.textView_userQuantity)
    TextView textViewUserQuantity;

    private Context context;

    public UserHeaderRowViewHolder(Context context, View itemView) {
        super(itemView);
        this.context = context;

        ButterKnife.bind(this, itemView);

    }

    public void setDataIntoView(User user) {
        Picasso.with(context).load(user.getUserImage(User.IMAGE_TYPE.SMALL))
                .transform(new RoundedTransformation(8, 0))
                .fit().centerCrop().placeholder(R.mipmap.icon_user).into(imageViewUserProfile);

        textViewUserName.setText(user.getName());
        textViewUserQuantity.setText(user.getPosts().size() + " frases");
    }

}
