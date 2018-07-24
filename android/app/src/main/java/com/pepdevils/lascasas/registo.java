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
 * Created by Pedro Fonseca on 02/02/2016.
 */
public class registo extends Activity {

    Button cancelar;
    Button registar;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        setContentView(R.layout.layout_registo);

        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
        int[] ids={R.id.email,
                R.id.passordText,
                R.id.passordTextRepite,
                R.id.cancelar,
                R.id.registar

        };

        AppHelper.SetFont(((ViewGroup) findViewById(android.R.id.content)).getChildAt(0), ids);
        DisplayMetrics dm = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(dm);
        int width = dm.widthPixels;
        final int height = dm.heightPixels;

        getWindow().setLayout((int) (width * .8), (int) (height * 0.6));

        cancelar = (Button)findViewById(R.id.cancelar);
        cancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                registo.this.onBackPressed();
            }
        });
        registar = (Button)findViewById(R.id.registar);
        registar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Register();
            }
        });
    }

    private void Register() {
        EditText email = (EditText)findViewById(R.id.emailText);
        String emailText = email.getText().toString();

        EditText pass1 = (EditText)findViewById(R.id.password);
        String password = pass1.getText().toString();

        EditText pass2 = (EditText)findViewById(R.id.passwordRepite);
        if (!password.equals(pass2.getText().toString())) {
            Toast.makeText(this, "As palavras passe inseridas não são iguais", Toast.LENGTH_LONG).show();
            pass1.setText("");
            pass2.setText("");
        }
        else if  (emailText.isEmpty() || password.isEmpty()) {
            Toast.makeText(this, "Por favor, preencha os campos em falta    ", Toast.LENGTH_LONG).show();
        }
        else {

            boolean flag = ApiHelper.RegisterUser(emailText, password);
            if(flag){
                Toast.makeText(this, "Registado com sucesso", Toast.LENGTH_LONG).show();
                this.onBackPressed();
            }else{
                Toast.makeText(this, "Não foi possivel registar", Toast.LENGTH_LONG).show();
            }

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
