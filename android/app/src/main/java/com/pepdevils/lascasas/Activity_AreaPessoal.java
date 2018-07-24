package com.pepdevils.lascasas;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import partilhado.AppHelper;
import partilhado.LogInHelper;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_AreaPessoal extends AppCompatActivity {

    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */


    Button terminarSessao;
    Button gostou;
    Button sobre;
    Toolbar toolbar;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.area_pessoal);


        int[] ids = {R.id.text_titulo,
                R.id.alterar,
                R.id.favoritos,
                R.id.sobre,
                R.id.gostou,
                R.id.Title,
                R.id.terminarSessao
        };

        AppHelper.ConfigureActivity(this, ids);

        AppHelper.SetFont(((ViewGroup) findViewById(android.R.id.content)).getChildAt(0), ids);
        AppHelper.AddMenu(this);


        Button alterar = (Button) findViewById(R.id.alterar);
        alterar.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent i= new Intent(getApplicationContext(),MudarPass.class);
                startActivity(i);
            }
        });


        Button favoritos = (Button) findViewById(R.id.favoritos);
        favoritos.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent ts = new Intent(getBaseContext(), Activity_Favoritos.class);
                startActivity(ts);
            }
        });


       terminarSessao = (Button) findViewById(R.id.terminarSessao);
        terminarSessao.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent ts = new Intent(getBaseContext(), Activity_TerminarSessao.class);
                startActivity(ts);
            }
        });


        gostou = (Button) findViewById(R.id.gostou);
        gostou.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Uri uri = Uri.parse("https://play.google.com/store/apps/details?id=com.pepdevils.lascasas&hl=pt_BR");
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                startActivity(intent);
            }
        });


        sobre = (Button) findViewById(R.id.sobre);
        sobre.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(Activity_AreaPessoal.this, Activity_SobreNos.class);
                startActivity(i);
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Intent ts = new Intent(getBaseContext(), Activity_TerminarSessao.class);
        startActivity(ts);
    }

    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    @Override
    protected void onResume() {
        if (!LogInHelper.isLogedIn())
            finish();
        super.onResume();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}
