package com.pepdevils.lascasas;

import android.app.Activity;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import partilhado.ApiHelper;
import partilhado.AppHelper;

/**
 * Created by pepdevils on 12/02/16.
 */
public class MudarPass extends Activity {

    Button cancelar;
    Button mudar;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        setContentView(R.layout.layout_mudar_pass);
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
        int[] ids = {R.id.pass_antiga,
                R.id.passord_nova,
                R.id.passord_nova_repetir,
                R.id.cancelar,
                R.id.mudar

        };


        AppHelper.SetFont(((ViewGroup) findViewById(android.R.id.content)).getChildAt(0), ids);
        DisplayMetrics dm = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(dm);
        int width = dm.widthPixels;
        final int height = dm.heightPixels;
        getWindow().setLayout((int) (width * .8), (int) (height * 0.6));
        cancelar = (Button) findViewById(R.id.cancelar);
        cancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MudarPass.this.onBackPressed();
            }
        });
        mudar = (Button) findViewById(R.id.mudar);
        mudar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MudarPass();
            }
        });

    }

    private void MudarPass() {

        EditText passHold = (EditText) findViewById(R.id.pass_antiga_text);
        String passHoldText = passHold.getText().toString();

        EditText passNew = (EditText) findViewById(R.id.password_nova_text);
        String passNewText = passNew.getText().toString();

        EditText passNewRepite = (EditText) findViewById(R.id.passord_nova_repetir_text);
        String passNewRepiteText = passNewRepite.getText().toString();

        if (!passNewText.equals(passNewRepiteText)) {
            Toast.makeText(this, "As palavras passe inseridas não são iguais", Toast.LENGTH_LONG).show();
            passNew.setText("");
            passNewRepite.setText("");

        } else if (passNewText.isEmpty() || passNewRepiteText.isEmpty()) {
            Toast.makeText(this, "Por favor, preencha os campos em falta", Toast.LENGTH_LONG).show();
        } else {
            String resultado = ApiHelper.AlterarPassword(passHoldText, passNewText);
            Toast.makeText(this, resultado, Toast.LENGTH_LONG).show();
            this.onBackPressed();
        }

    }


    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);

    }

    @Override
    protected void onResume() {
        super.onResume();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
    }
}
