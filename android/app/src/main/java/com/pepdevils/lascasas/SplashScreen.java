package com.pepdevils.lascasas;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;

/**
 * Created by Pedro Fonseca on 19/01/2016.
 */
public class SplashScreen extends AsyncTask<Object, Integer, Object> {

    private Activity activity;
    Intent i;

    public SplashScreen(Activity activity) {
        this.activity = activity;
    }

    public void processamentoPrincipal() {

        try {
                Thread.sleep(5400);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }


    @Override
    protected void onPostExecute(Object o) {
        super.onPostExecute(o);

        i = new Intent(activity, Activity_Destaques.class);
        i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        activity.startActivity(i);
    }

    @Override
    protected Object doInBackground(Object... arg0) {

        processamentoPrincipal();

        return null;
    }

}
