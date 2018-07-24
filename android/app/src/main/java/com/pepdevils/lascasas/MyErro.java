package com.pepdevils.lascasas;

import android.app.Application;
import android.content.Context;
import android.support.multidex.MultiDex;

import com.parse.Parse;
import com.parse.ParseInstallation;


/**
 * Created by Pedro Fonseca on 26/01/2016.
 */
public class MyErro extends Application {

    private static Context context;

    //Par corrigir ERRO
        /*http://stackoverflow.com/questions/33196015/error-on-some-devices-couldnt-find-class-com-google-android-gms-measurement*/
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
        MyErro.context = getBaseContext();
    }

    public static Context getAppContext() {
        return MyErro.context;
    }


    @Override
    public void onCreate() {
        super.onCreate();

        //API Parse Notification
        Parse.initialize(this, "f8LRbMJSAkpMs0of5idKenTogvijhSouD6wiIYSM", "oSB4d6UPwmy56f5sYzyqe9zwsPQ9ddDJ02RGZpfP");
        ParseInstallation.getCurrentInstallation().saveInBackground();
    }
}
