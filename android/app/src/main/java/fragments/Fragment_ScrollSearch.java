package fragments;

/*import android.animation.Animator;
import android.animation.ObjectAnimator;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.animation.DecelerateInterpolator;
import android.widget.EdgeEffect;
import android.widget.ProgressBar;*/

import android.app.Activity;
import android.content.Context;

import android.util.AttributeSet;
import android.view.View;

import android.widget.ScrollView;
import android.widget.Toast;


import com.pepdevils.lascasas.Activity_PesquisaResultado;


/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Fragment_ScrollSearch extends ScrollView {

/*    EdgeEffect mEdgeGlowTop;
    EdgeEffect mEdgeGlowBottom;*/

  /*  public static ProgressBar pb;*/

/*
    public Fragment_ScrollSearch(Context context, AttributeSet attrs, int defStyleAttr, int i) {
        super(context);
    }*/

    public Fragment_ScrollSearch(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public Fragment_ScrollSearch(Context context, AttributeSet attrs) {
        super(context, attrs);
    }


    boolean trigger = false;
    public boolean isSearching = true;


    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {


        // Vai buscar uma view child(item que pertence ao scroll), para determinarmos a posição final
        View view = getChildAt(getChildCount() - 1);

        // Calcula o scrolldiff
        int diff = (view.getBottom() - (getHeight() + getScrollY()));

        // quando diff é zero então o scroll chegou ao fim
        if (diff <= 1 && !trigger) {
            trigger = true;


            if (isSearching) {
                ((Activity) getContext()).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        //Toast.makeText(getContext(), "A procurar imoveis...", Toast.LENGTH_LONG).show();
                    }
                });

                //Add searches
                try {

                    isSearching = ((Activity_PesquisaResultado) getContext()).ExecuteGetImoveisAsync();

                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                Toast.makeText(getContext(), "Não foram encontrados mais imóveis", Toast.LENGTH_LONG).show();
            }

        } else if (diff == 0) {
            //Toast.makeText(getContext(), "Sem mais imoveis...", Toast.LENGTH_SHORT).show();
        } else if (diff > 1) {
            trigger = false;
        }

        super.onScrollChanged(l, t, oldl, oldt);
    }

}
