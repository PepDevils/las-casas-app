package custom_banner;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.pepdevils.lascasas.MyErro;
import com.pepdevils.lascasas.R;
import com.flyco.banner.widget.Banner.BaseIndicaorBanner;

import partilhado.ApiHelper;
import partilhado.AppHelper;
import partilhado.Imovel;

public class Banner extends BaseIndicaorBanner<Imovel, Banner> {
    private ColorDrawable colorDrawable;

    public Banner(Context context) {
        this(context, null, 0);
    }

    public Banner(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public Banner(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        colorDrawable = new ColorDrawable(Color.parseColor("#555555"));
    }

    @Override
    public void onTitleSlect(TextView tv, int position) {
        final Imovel item = list.get(position);
        tv.setText(item.titulo);
    }

    @Override
    public View onCreateItemView(int position) {

        int[] ids = {
                R.id.title,
                R.id.price
        };

        View inflated = View.inflate(context, R.layout.destaque_vazio, null);
        ImageView iv = (ImageView)inflated.findViewById(R.id.imageView);
        TextView title = (TextView)inflated.findViewById(R.id.title);
        TextView price = (TextView)inflated.findViewById(R.id.price);
        ImageView etiqueta = (ImageView) inflated.findViewById(R.id.etiqueta);

        AppHelper.SetFont(inflated, ids);

        //Vai à lista (popilada pelo DataProvider) e obtém o item com a informação para popular o objeto
        final Imovel item = list.get(position);
        int itemWidth = dm.widthPixels;
        int itemHeight = (int) (itemWidth * 2/3f);
        iv.setScaleType(ImageView.ScaleType.CENTER_CROP);

        iv.setLayoutParams(new RelativeLayout.LayoutParams(itemWidth, itemHeight));
        title.setText(item.titulo);
        price.setText(item.preco);

        String imgUrl = ApiHelper.getImageURL(item.imagemID, itemWidth, itemHeight);

        if (!TextUtils.isEmpty(imgUrl)) {
            AppHelper.SetImageFromURL(context, iv, imgUrl);
        } else {
            iv.setImageDrawable(colorDrawable);
        }


        switch (item.estado) {
            case Disponivel:
                etiqueta.setImageResource(R.drawable.etiquetas_disponivel);
                break;
            case Reservado:
                etiqueta.setImageResource(R.drawable.etiquetas_reservado);
                break;
            case Vendido:
                etiqueta.setImageResource(R.drawable.etiquetas_vendido);
                break;
            case Arrendar:
                etiqueta.setImageResource(R.drawable.etiquetas_arrendar);
                break;
            case Arrendado:
                etiqueta.setImageResource(R.drawable.etiquetas_arrendado);
                break;
        }

        return inflated;
    }
}