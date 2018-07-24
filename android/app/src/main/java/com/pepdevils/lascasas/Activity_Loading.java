package com.pepdevils.lascasas;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.appevents.AppEventsLogger;
import com.parse.Parse;
import com.parse.ParseInstallation;


/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_Loading extends FragmentActivity {

    int finalHeight;
    int finalWidth;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppEventsLogger.activateApp(this);

        setContentView(R.layout.loading);
        new SplashScreen(this).execute();

        final ImageView imageInt = (ImageView) findViewById(R.id.icon_int);
        final ImageView imageExt = (ImageView) findViewById(R.id.icon_ext);
        final View carlo = findViewById(R.id.imageView1);


        //TRAZER A IMAGEM DO CARLO PARA A FRENTE
        carlo.bringToFront();

            //DEFENICOES APARTIR DO TAMANHO DA IMAGEM DO CARLO
            ViewTreeObserver vto = carlo.getViewTreeObserver();
            vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
                public boolean onPreDraw() {

                    //INVESTIGAR ?
                    carlo.getViewTreeObserver().removeOnPreDrawListener(this);

                    //TAMANHO DA IMAGEM DO CARLO APOS ESTA SER APLICADA AO TAMANHO DO DISPOSITIVO
                    finalHeight = carlo.getMeasuredHeight();
                    finalWidth = carlo.getMeasuredWidth();

                    //REDEFENIR TAMANHO DOS ICONES E SUA MARGEM EM RELAÇAO A IMAGEM DO CARLO
                    float perIco = (float) 0.65; //percentagem tamanho icone

                    float perL = (float) 0.1;    //percentagem margem esquerda
                    float perT = (float) 0.1;    //percentagem margem superior
                    float perR = (float) 0.2;   //percentagem margem direita
                    float perB = (float) 0.5;    //percentagem margem inferior

                    int sizeIcon = (int) (finalWidth * perIco); //tamanho icone

                    int marginL = (int) (finalWidth * perL);    //margem esquerda
                    int marginT = (int) (finalWidth * perT);   //margem superior
                    int marginR = (int) (finalWidth * perR);    //margem direita
                    int marginB = (int) (finalWidth * perB);   //margem inferior

                    //DEFENIR PARAMETROS DO LAYOUT
                    ViewGroup.MarginLayoutParams marginParams = new ViewGroup.MarginLayoutParams(imageInt.getLayoutParams());
                    marginParams.setMargins(marginL, marginT, marginR, marginB);
                    RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(marginParams);
                    layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
                    layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);

                    //COLOCAR OS PARAMETROS DO LAYOUT NAS IMAGEM DO ICONE
                    //INTERNO
                    imageInt.setLayoutParams(layoutParams);
                    imageInt.getLayoutParams().height = sizeIcon;
                    imageInt.getLayoutParams().width = sizeIcon;
                    imageInt.requestLayout();
                    //EXTERNO
                    imageExt.setLayoutParams(layoutParams);
                    imageExt.getLayoutParams().height = sizeIcon;
                    imageExt.getLayoutParams().width = sizeIcon;
                    imageExt.requestLayout();

                    return true;
                }
            });


        //ANIMAÇAO
        Animation rotation = AnimationUtils.loadAnimation(this, R.anim.icon_rotation);
        rotation.setRepeatCount(Animation.INFINITE);
        imageExt.startAnimation(rotation);


    }

    @Override
    protected void onPause() {
        super.onPause();
        AppEventsLogger.deactivateApp(this);
        this.finish();
    }
}
