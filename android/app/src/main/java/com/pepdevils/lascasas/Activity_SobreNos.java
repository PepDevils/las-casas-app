package com.pepdevils.lascasas;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Toast;

import com.github.clans.fab.FloatingActionButton;
import com.github.clans.fab.FloatingActionMenu;

import partilhado.AppHelper;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_SobreNos extends Activity {

    Toolbar toolbar;
    private FloatingActionMenu fabMenu;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

        setContentView(R.layout.sobre_nos);

        toolbar = (Toolbar) findViewById(R.id.barra_titulo);

        int[] ids = {R.id.textView1,
                R.id.textView2,
                R.id.textView3,
                R.id.textView4,
                R.id.Title
        };

        AppHelper.AddMenu(this);
        AppHelper.SetFont(((ViewGroup) findViewById(android.R.id.content)).getChildAt(0), ids);

        fabMenu = (FloatingActionMenu) findViewById(R.id.fab_menu);
        fabMenu.setClosedOnTouchOutside(true);
        fabMenu.setOnMenuToggleListener(new FloatingActionMenu.OnMenuToggleListener() {
            @Override
            public void onMenuToggle(boolean opened) {
                String s = "Aplicação por:\n  pepdevils  ";
                if (opened)
                    Toast.makeText(getApplicationContext(), s, Toast.LENGTH_LONG).show();
            }
        });

        FloatingActionButton fab1 = (FloatingActionButton) findViewById(R.id.fab1);
        FloatingActionButton fab2 = (FloatingActionButton) findViewById(R.id.fab2);

        fab1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String url = "http://www.pepdevils.pt";
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                startActivity(browserIntent);
            }
        });

        fab2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent i = new Intent(getApplicationContext(), Activity_pepdevils.class);
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
