package com.pepdevils.lascasas;


import android.animation.Animator;
import android.animation.ObjectAnimator;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStub;
import android.view.animation.DecelerateInterpolator;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.common.api.GoogleApiClient;
import partilhado.ApiHelper;
import partilhado.AppHelper;
import partilhado.Imovel;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_PesquisaResultado extends AppCompatActivity {


    private Toast t = null;
    int width;
    int pagesLoaded = 0;
    static ViewGroup container;
    static View inflated;
    public static ProgressBar pb;

    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    private GoogleApiClient client;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pesquisa);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

        DefinirBarraTitulo();

        pb = (ProgressBar) findViewById(R.id.loadingPanel);
        pb.setVisibility(View.GONE);

        Imovel[] imoveis = GetMore();

        if (imoveis[0] == null) {
            Toast t= Toast.makeText(getApplicationContext(), "Esta pesquisa não retornou imoveis \n por favor, faça uma nova pesquisa", Toast.LENGTH_LONG);
            t.show();
            this.finish();

        } else

            for (int i = 0; i < imoveis.length; i++) {
                try {
                    AddImovel(imoveis[i]);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        client = new GoogleApiClient.Builder(this).addApi(AppIndex.API).build();

        DetectaConexao.existeConexao(this);
    }


    public void DefinirBarraTitulo() {

        Intent intent = getIntent();
        String id_toolbar = intent.getStringExtra("toolbar");
        ViewStub stub = (ViewStub) findViewById(R.id.barra_titulo);

        if(id_toolbar.equals("todos")){
            stub.setLayoutResource(R.layout.barra_titulo_todos);
            stub.inflate();

        }else if(id_toolbar.equals("pesquisa")){
            stub.setLayoutResource(R.layout.barra_titulo);
            stub.inflate();
        }
    }

    public void AddImovel(final Imovel imovel) throws Exception {

        if (imovel == null)
            throw new Exception("O Imovel é nulo - provavelmente, a pesquisa não retornou imóveis suficientes.");

        container = (ViewGroup) findViewById(R.id.container);
        inflated = getLayoutInflater().inflate(R.layout.pesquisa_casa, container, false);
        inflated.setAlpha(1f);

        int[] ids = {
                R.id.textTitulo,
                R.id.textID,
                R.id.textPrice,
                R.id.Title
        };

        AppHelper.SetFont(inflated, ids);
        AppHelper.ConfigureActivity(this, ids);

        inflated.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {

                try {
                    AppHelper.StartActivityCasa(Activity_PesquisaResultado.this, imovel);
                } catch (Exception e) {
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


        ImageView _image1 = (ImageView) inflated.findViewById(R.id.image1);
        ImageView etiqueta = (ImageView) inflated.findViewById(R.id.etiqueta);

        final float scale = getResources().getDisplayMetrics().density;
        int width =(getResources().getDisplayMetrics().widthPixels);


        try {
            _image1.setLayoutParams(new RelativeLayout.LayoutParams(width, width * 2 / 3));
            String url1 = imovel.getGalleryURLs()[0];
            AppHelper.SetImageFromURL(this, _image1, url1);
        } catch (Exception e) {
            e.printStackTrace();
        }


        int smallWidth = (int) (width / 2f);
        LinearLayout.LayoutParams params=new LinearLayout.LayoutParams((int) (smallWidth - 1 * scale), smallWidth * 2 / 3);
        params.setMargins(1,1,1,1);

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
        if(titulo == null){
            titulo.setText("Indisponível");
        }

        String textoID = "ID: " + imovel.MLS;
        ID.setText(textoID);

        preco.setText(imovel.preco);

        container.addView(inflated);
    }

    private Imovel[] GetMore() {

        RereshAnimator();

        Imovel[] imoveis = new Imovel[5];
        final float scale = getResources().getDisplayMetrics().density;
        width = (int) (getResources().getDisplayMetrics().widthPixels - 42 * scale);

        try {
            imoveis = ApiHelper.getSearch(
                    getIntent().getStringExtra("tipo"),
                    getIntent().getStringExtra("imovel"),
                    getIntent().getStringExtra("quartos"),
                    getIntent().getStringExtra("localidade"),
                    getIntent().getStringExtra("freguesia"),
                    getIntent().getStringExtra("min"),
                    getIntent().getStringExtra("max"),
                    pagesLoaded,
                    width,
                    (int) (width * 2f / 3f));
            pagesLoaded++;

        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(getApplicationContext(), "Sem pesquisa",Toast.LENGTH_LONG);
        }
        return imoveis;
    }

    public boolean ExecuteGetImoveisAsync() {


        RereshAnimator();

        Imovel[] imoveis = new Imovel[5];
        Boolean areMore = true;

        try {
            imoveis = ApiHelper.getSearch(getIntent().getStringExtra("tipo"),
                    getIntent().getStringExtra("imovel"),
                    getIntent().getStringExtra("quartos"),
                    getIntent().getStringExtra("localidade"),
                    getIntent().getStringExtra("freguesia"),
                    getIntent().getStringExtra("min"),
                    getIntent().getStringExtra("max"),
                    pagesLoaded++,
                    width,
                    (int) (width * 2f / 3f));
        } catch (Exception e) {
            e.printStackTrace();
            areMore = false;
        }


        for (int i = 0; i < imoveis.length; i++) {
            try {
                AddImovel(imoveis[i]);
            } catch (Exception e) {
                e.printStackTrace();
                areMore = false;
            }
        }

        if (imoveis.length <= 0) {
            areMore = false;
            Log.d("Search", "A pesquisa não retornou Imoveis!");
        }

        if (imoveis.length < 5) {
            areMore = false;
            Log.d("Search", "A pesquisa acabou!");
        }



        return areMore;
    }


    private void RereshAnimator(){

        ObjectAnimator animation = ObjectAnimator.ofInt(pb, "progress", 0, 100);
        animation.setDuration(2500);
        animation.setInterpolator(new DecelerateInterpolator());
        animation.addListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animator) {
                pb.setVisibility(View.VISIBLE);}

            @Override
            public void onAnimationEnd(Animator animator) {
                //do something when the countdown is complete
                pb.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationCancel(Animator animator) { }

            @Override
            public void onAnimationRepeat(Animator animator) { }
        });
        animation.start();

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
        if (t != null)
            t.cancel();
        t = null;
    }
}


