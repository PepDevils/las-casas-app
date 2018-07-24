package com.pepdevils.lascasas;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import android.view.View;
import android.view.Window;

import android.widget.Button;

import partilhado.AppHelper;
import partilhado.LogInHelper;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_TerminarSessao extends Activity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        setContentView(R.layout.terminar_sessao);


        int[] ids = {R.id.text_titulo,
                R.id.voltar,
                R.id.dadosPessoais

        };

        AppHelper.ConfigureActivity(this, ids);

        Button voltar = (Button) findViewById(R.id.voltar);
        voltar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(getApplicationContext(), Activity_AreaPessoal.class);
                startActivity(i);
            }
        });

        Button terminarSessao = (Button) findViewById(R.id.dadosPessoais);
        terminarSessao.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LogInHelper.logOut();
                Intent i = new Intent(getApplicationContext(), Activity_IniciarSessao.class);
                i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(i);
            }
        });

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
    }

}

