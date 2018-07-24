package custom_banner;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;


import com.bumptech.glide.Glide;
import com.pepdevils.lascasas.R;
import com.flyco.banner.widget.Banner.BaseIndicaorBanner;

import partilhado.AppHelper;


/**
 * Created by Davide Teixeira on 22/01/16.
 */
public class Gallery extends BaseIndicaorBanner<String, Gallery> {
    private ColorDrawable colorDrawable;

    public Gallery(Context context) {
        this(context, null, 0);
    }

    public Gallery(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public Gallery(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        colorDrawable = new ColorDrawable(Color.parseColor("#555555"));
    }

    @Override
    public void onTitleSlect(TextView tv, int position) {
        final String item = list.get(position);
        tv.setText(item);
    }

    @Override
    public View onCreateItemView(int position) {
        View inflated = View.inflate(context, R.layout.image_slider, null);
        ImageView iv = (ImageView)inflated.findViewById(R.id.image);

        //Vai à lista (populada pelo DataProvider) e obtém o item com a informação para popular o objeto
        final String item = list.get(position);

        int itemWidth = dm.widthPixels;
        int itemHeight = (int) (itemWidth * 2/3f);

        iv.setLayoutParams(new LinearLayout.LayoutParams(itemWidth, itemHeight));

        if (!TextUtils.isEmpty(item)) {
            AppHelper.SetImageFromURL2(context, iv, item);
        } else {
            iv.setImageDrawable(colorDrawable);
        }

        return inflated;
    }
}