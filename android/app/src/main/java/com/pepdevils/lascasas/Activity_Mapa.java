package com.pepdevils.lascasas;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

import partilhado.AppHelper;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_Mapa extends AppCompatActivity {

    private Toolbar toolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.mapa);

        int[] ids = {R.id.Title
        };

        toolbar = (Toolbar) findViewById(R.id.barra_titulo);
        setSupportActionBar(toolbar);

        AppHelper.ConfigureActivity(this, ids);
    }

}
