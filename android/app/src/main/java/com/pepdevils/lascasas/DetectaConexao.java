package com.pepdevils.lascasas;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.widget.Toast;

import partilhado.ApiHelper;

/**
 * Created by Pedro Fonseca on 03/02/2016.
 */
public class DetectaConexao {

    public static boolean existeConexao(Activity a) {
        ConnectivityManager connectivity = (ConnectivityManager) MyErro.getAppContext().getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivity != null) {
            NetworkInfo netInfo = connectivity.getActiveNetworkInfo();
            if (netInfo == null) {
                FecharAplicação(a);
                return false;
            }

            int netType = netInfo.getType();
            if (netType != ConnectivityManager.TYPE_WIFI &&
                    netType != ConnectivityManager.TYPE_MOBILE) {
                FecharAplicação(a);
                return !netInfo.isConnected();

            } else {
                try {
                    String response = ApiHelper.GetStringFromURL(ApiHelper.baseURL);
                    if (response == "") {
                        FecharAplicação(a);
                        return !netInfo.isConnected();
                    } else
                        return netInfo.isConnected();
                } catch (Exception e) {
                    FecharAplicação(a);
                    return !netInfo.isConnected();
                }
            }
        } else {
            FecharAplicação(a);
            return false;
        }
    }

    public static boolean FecharAplicação(Activity a) {
        Toast.makeText(MyErro.getAppContext(), "Precisa de conexão á internet para usar a aplicação", Toast.LENGTH_LONG).show();
        Intent i = new Intent(Intent.ACTION_MAIN);
        i.addCategory(Intent.CATEGORY_HOME);
        i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        a.startActivity(i);
        return false;
    }

}
