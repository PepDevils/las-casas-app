package com.pepdevils.lascasas;


import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.github.clans.fab.FloatingActionButton;

import partilhado.ApiHelper;
import partilhado.AppHelper;
import partilhado.Imovel;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_Destaques extends AppCompatActivity {

    static ViewGroup container;
    Imovel[] casasDestaque;
    int width;
    View inflated;
    final View v = null;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        DetectaConexao.existeConexao(this);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        setContentView(R.layout.destaques);
        FAB();
        AppHelper.AddMenuInicial(this);
        Imovel[] imoveis = GetMore();

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
            DetectaConexao.existeConexao(this);
        }
    }


    private void FAB() {

        FloatingActionButton fab1 = (FloatingActionButton) findViewById(R.id.fab1);
        fab1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //PESQUISA RAPIDA
                Intent pesquisa = new Intent(getApplicationContext(), Activity_PesquisaResultado.class);
                pesquisa.putExtra("toolbar", "todos");
                pesquisa.putExtra("tipo", "Qualquer");
                pesquisa.putExtra("imovel", "Qualquer");
                pesquisa.putExtra("quartos", "Qualquer");
                pesquisa.putExtra("localidade", "Qualquer");
                pesquisa.putExtra("freguesia", "Qualquer");
                pesquisa.putExtra("min", "Qualquer");
                pesquisa.putExtra("max", "Qualquer");
                startActivity(pesquisa);
            }
        });

    }


    public void AddImovel(final Imovel imovel) throws Exception {

        if (imovel == null)
            throw new Exception("O Imovel é nulo - provavelmente, a pesquisa não retornou imóveis suficientes.");

        container = (ViewGroup) findViewById(R.id.container);
        inflated = getLayoutInflater().inflate(R.layout.destaque_vazio, container, false);

        int[] ids = {
                R.id.title,
                R.id.price,
                R.id.etiqueta
        };

        AppHelper.SetFont(inflated, ids);
        AppHelper.ConfigureActivity(this, ids);

        ImageView _image1 = (ImageView) inflated.findViewById(R.id.imageView);
        ImageView etiqueta = (ImageView) inflated.findViewById(R.id.etiqueta);

        int width = (getResources().getDisplayMetrics().widthPixels);

        try {
            //imagem Central
            _image1.setLayoutParams(new RelativeLayout.LayoutParams(width, width * 2 / 3));
            String url1 = ApiHelper.getImageURL(imovel.imagemID);
            AppHelper.SetImageFromURL(this, _image1, url1);

        } catch (Exception e) {
            e.printStackTrace();
        }

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

        TextView titulo = (TextView) inflated.findViewById(R.id.title);
        TextView preco = (TextView) inflated.findViewById(R.id.price);
        titulo.setText(imovel.titulo);
        preco.setText(imovel.preco);

        container.addView(inflated);

        inflated.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {

                try {
                    AppHelper.StartActivityCasa(getApplicationContext(), imovel);
                } catch (Exception e) {
                    e.printStackTrace();
                    Toast.makeText(MyErro.getAppContext(), "Imóvel Indisponível, tente mais tarde", Toast.LENGTH_LONG).show();
                }

                new CountDownTimer(80, 40) {
                    public void onTick(long millisUntilFinished) {
                        v.setAlpha(0.5f);
                    }

                    public void onFinish() {
                        v.setAlpha(1f);
                    }
                }.start();

            }
        });


    }

    //carrega os primeiros 5 imoveis
    private Imovel[] GetMore() {

        try {
            casasDestaque = ApiHelper.getDestaques(getResources().getDisplayMetrics().widthPixels);
            final float scale = getResources().getDisplayMetrics().density;
            width = (int) (getResources().getDisplayMetrics().widthPixels - 42 * scale);

        } catch (Exception e) {
            e.printStackTrace();

        }
        return casasDestaque;
    }


    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    @Override
    protected void onResume() {
        super.onResume();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        DetectaConexao.existeConexao(this);
        AppHelper.ReplaceMenuInicial(this);

    }
}