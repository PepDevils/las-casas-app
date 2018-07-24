package com.pepdevils.lascasas;

import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStub;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import partilhado.ApiHelper;
import partilhado.AppHelper;
import partilhado.Imovel;

/**
 * Created by Davide Teixeira on 10/02/2016.
 */
public class Activity_Favoritos extends AppCompatActivity {

    private Toolbar toolbar;
    int pagesLoaded = 0;
    static ViewGroup container;
    View inflated;
    ProgressBar pb;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

        DetectaConexao.existeConexao(this);

        setContentView(R.layout.pesquisa);

        pb = (ProgressBar) findViewById(R.id.loadingPanel);
        pb.setVisibility(View.GONE);


        //final float scale = getResources().getDisplayMetrics().density;
        //int width = (int) (getResources().getDisplayMetrics().widthPixels - 42 * scale);
        Imovel[] imoveis = ApiHelper.GetFavourites2();


        try {
            for (int i = 0; i < imoveis.length; i++) {
                try {
                    AddImovel(imoveis[i]);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(Activity_Favoritos.this, "sem imoveis nos favoritos", Toast.LENGTH_LONG).show();
            this.finish();
        }

        DefinirBarraTitulo();


    }

    public void DefinirBarraTitulo() {

        // Intent intent = getIntent();

        ViewStub stub = (ViewStub) findViewById(R.id.barra_titulo);
        stub.setLayoutResource(R.layout.barra_titulo_favoritos);
        stub.inflate();

    }

    public void AddImovel(final Imovel imovel) throws Exception {

        container = (ViewGroup) findViewById(R.id.container);
        inflated = getLayoutInflater().inflate(R.layout.pesquisa_casa, container, false);

        int[] ids = {
                R.id.textTitulo,
                R.id.textID,
                R.id.textPrice,
                R.id.Title
        };

        AppHelper.ConfigureActivity(this, ids);
        AppHelper.SetFont(inflated, ids);

        inflated.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AppHelper.StartActivityCasa(Activity_Favoritos.this, imovel);
                inflated.setAlpha(0.5f);
            }
        });


        ImageView _image1 = (ImageView) inflated.findViewById(R.id.image1);
        ImageView etiqueta = (ImageView) inflated.findViewById(R.id.etiqueta);

        final float scale = getResources().getDisplayMetrics().density;

        int width = (getResources().getDisplayMetrics().widthPixels);

        try {
            _image1.setLayoutParams(new RelativeLayout.LayoutParams(width, width * 2 / 3));
            String url1 = imovel.getGalleryURLs()[0];
            AppHelper.SetImageFromURL(this, _image1, url1);
        } catch (Exception e) {
            e.printStackTrace();
        }

        int smallWidth = (int) (width / 2f);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams((int) (smallWidth - 1 * scale), smallWidth * 2 / 3);
        params.setMargins(1, 1, 1, 1);


        switch (imovel.estado) {
            default:
                etiqueta.setBackgroundResource(R.drawable.etiquetas_disponivel);
                break;
            case Arrendado:
                etiqueta.setBackgroundResource(R.drawable.etiquetas_arrendado);
                break;
            case Arrendar:
                etiqueta.setBackgroundResource(R.drawable.etiquetas_arrendar);
                break;
            case Reservado:
                etiqueta.setBackgroundResource(R.drawable.etiquetas_reservado);
                break;
            case Vendido:
                etiqueta.setBackgroundResource(R.drawable.etiquetas_vendido);
                break;
        }

        TextView titulo = (TextView) inflated.findViewById(R.id.textTitulo);
        TextView ID = (TextView) inflated.findViewById(R.id.textID);
        TextView preco = (TextView) inflated.findViewById(R.id.textPrice);

        titulo.setText(imovel.titulo);
        String textoID = "ID: " + imovel.MLS;
        ID.setText(textoID);
        preco.setText(imovel.preco);

        container.addView(inflated);
    }


    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        inflated.setAlpha(1f);
    }

    @Override
    protected void onResume() {
        super.onResume();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

        DetectaConexao.existeConexao(this);
    }

    @Override
    protected void onRestart() {
        super.onRestart();

        finish();
        startActivity(getIntent());
    }
}


