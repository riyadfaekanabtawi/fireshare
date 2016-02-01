package com.betomaluje.android.fireshare.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.Shader;

/**
 * Created by betomaluje on 2/1/16.
 */
public class RoundedTransformation implements
        com.squareup.picasso.Transformation {
    private final int radius;
    private final int border; // dp

    // radius is corner radii in dp
    // border is the board in dp
    public RoundedTransformation(final int radius, final int border) {
        this.radius = radius;
        this.border = border;
    }

    @Override
    public Bitmap transform(final Bitmap source) {
        final Paint paint = new Paint();
        paint.setAntiAlias(true);
        paint.setShader(new BitmapShader(source, Shader.TileMode.CLAMP,
                Shader.TileMode.CLAMP));

        Bitmap output = Bitmap.createBitmap(source.getWidth(),
                source.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);
        canvas.drawRoundRect(new RectF(border, border, source.getWidth()
                - border, source.getHeight() - border), radius, radius, paint);

        if (source != output) {
            source.recycle();
        }

        return output;
    }

    @Override
    public String key() {
        return "rounded";
    }
}
