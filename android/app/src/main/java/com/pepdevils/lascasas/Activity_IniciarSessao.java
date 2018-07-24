package com.pepdevils.lascasas;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;
import partilhado.ApiHelper;
import partilhado.AppHelper;
import partilhado.LogInHelper;

/*import android.util.Base64;
import android.util.Log;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
*/


/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_IniciarSessao extends FragmentActivity {

    private LogInHelper logIn = new LogInHelper();
    private Toolbar toolbar;

    Button login;
    Button facebook;
    ImageButton facebookImg;
    Button google;
    ImageButton googleImg;
    Button registo;
    TextView esquecime;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        setContentView(R.layout.iniciar_sessao);

        toolbar = (Toolbar) findViewById(R.id.barra_titulo);

        login = (Button) findViewById(R.id.login);
        facebook = (Button) findViewById(R.id.button_facebook);
        facebookImg = (ImageButton) findViewById(R.id.image_facebook);
        google = (Button) findViewById(R.id.button_google);
        googleImg = (ImageButton) findViewById(R.id.image_google);
        registo = (Button) findViewById(R.id.register);
        esquecime = (TextView) findViewById(R.id.regrets);

        DetectaConexao.existeConexao(this);
        logIn.GooglePrepare(this);
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);

        int[] ids = {R.id.email,
                R.id.password,
                R.id.regrets,
                R.id.login,
                R.id.register,
                R.id.button_facebook,
                R.id.button_google,
                R.id.Title
        };


        AppHelper.ConfigureActivity(this, ids);


        /*
        //ENVIAR A KEYHASH PARA O LOGCAT - INICIO
        //PARA AJUDAR NO PROCESSO DE REGISTO DA API DO FACEBOOK
        // http://stackoverflow.com/questions/23674131/android-facebook-integration-invalid-key-hash
        try {
            PackageInfo info = getPackageManager().getPackageInfo(
                    "com.pepdevils.lascasas",
                    PackageManager.GET_SIGNATURES);
            for (Signature signature : info.signatures) {
                MessageDigest md = MessageDigest.getInstance("SHA");
                md.update(signature.toByteArray());
                Log.d("KeyHash:", Base64.encodeToString(md.digest(), Base64.DEFAULT));
            }
        } catch (PackageManager.NameNotFoundException e) {

        } catch (NoSuchAlgorithmException e) {

        }
        //ENVIAR A KEYHASH PARA O LOGCAT - FIM
        */

        login.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                String mail = AppHelper.GetTextFromView(Activity_IniciarSessao.this, R.id.email);
                String password = AppHelper.GetTextFromView(Activity_IniciarSessao.this, R.id.password);

                LogInHelper.dataLogin(Activity_IniciarSessao.this, mail, password);
            }
        });


        facebook.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                logIn.FacebookLogin(Activity_IniciarSessao.this);
            }
        });


        facebookImg.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                logIn.FacebookLogin(Activity_IniciarSessao.this);
            }
        });


        google.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                logIn.GoogleLogin(Activity_IniciarSessao.this);
            }
        });


        googleImg.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                logIn.GoogleLogin(Activity_IniciarSessao.this);
            }
        });


        registo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(Activity_IniciarSessao.this, registo.class));
            }
        });

        esquecime.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String mail = AppHelper.GetTextFromView(Activity_IniciarSessao.this, R.id.email);

                if (mail.isEmpty())
                    Toast.makeText(Activity_IniciarSessao.this, "O campo de email não pode estar vazio.", Toast.LENGTH_SHORT).show();
                else {
                    String resultado = ApiHelper.PerdeuPalavraPasse(mail);

                    if (resultado.isEmpty())
                        Toast.makeText(Activity_IniciarSessao.this, "Foi-lhe enviado um email com a nova palavra passe.", Toast.LENGTH_LONG).show();
                    else
                        Toast.makeText(Activity_IniciarSessao.this, resultado, Toast.LENGTH_LONG).show();
                }
            }
        });
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
        DetectaConexao.existeConexao(this);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        logIn.OnActivityResult(this, requestCode, resultCode, data);
    }
}