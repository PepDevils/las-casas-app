package com.pepdevils.lascasas;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * Created by pepdevils on 23/02/16.
 */
public class Activity_pepdevils extends Activity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        setContentView(R.layout.pepdevils);

        final View svView = findViewById(R.id.sv);
        final TextView bottom = (TextView) findViewById(R.id.bottom);
        final TextView phone1 = (TextView) findViewById(R.id.phone1);
        final TextView phone2 = (TextView) findViewById(R.id.phone2);
        final TextView phone3 = (TextView) findViewById(R.id.phone3);
        final TextView morada = (TextView) findViewById(R.id.morada);
        final TextView mail1 = (TextView) findViewById(R.id.mail1);
        final TextView mail2 = (TextView) findViewById(R.id.mail2);
        final ImageView top = (ImageView) findViewById(R.id.top);
        final ImageView cat1 = (ImageView) findViewById(R.id.cat1);
        final ImageView cat2 = (ImageView) findViewById(R.id.cat2);

        cat1.setVisibility(View.INVISIBLE);
        cat2.setVisibility(View.INVISIBLE);

        phone1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {

                new CountDownTimer(120, 60) {
                    public void onTick(long millisUntilFinished) {
                        v.setBackgroundColor(getResources().getColor(R.color.x_green));
                    }

                    public void onFinish() {
                        v.setBackgroundColor(getResources().getColor(R.color.whiteCoracao));
                        Uri uri = Uri.parse("tel:+351 253 331 170");
                        Intent intent = new Intent(Intent.ACTION_DIAL, uri);
                        startActivity(intent);
                    }
                }.start();


            }
        });
        phone2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                new CountDownTimer(120, 60) {
                    public void onTick(long millisUntilFinished) {
                        v.setBackgroundColor(getResources().getColor(R.color.x_lime));
                    }

                    public void onFinish() {
                        v.setBackgroundColor(getResources().getColor(R.color.whiteCoracao));

                        Uri uri = Uri.parse("tel:+351 918 887 384");
                        Intent intent = new Intent(Intent.ACTION_DIAL, uri);
                        startActivity(intent);

                    }
                }.start();

            }
        });
        phone3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {

                new CountDownTimer(120, 60) {
                    public void onTick(long millisUntilFinished) {
                        v.setBackgroundColor(getResources().getColor(R.color.x_orange));
                    }

                    public void onFinish() {
                        v.setBackgroundColor(getResources().getColor(R.color.whiteCoracao));
                        Uri uri = Uri.parse("tel:+351 918 887 370");
                        Intent intent = new Intent(Intent.ACTION_DIAL, uri);
                        startActivity(intent);

                    }
                }.start();

            }
        });
        morada.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                double latitude = 41.541157;
                double longitude = -8.433007;
                Uri gmmIntentUri = Uri.parse("google.navigation:q=" + latitude + "," + longitude);
                final Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
                mapIntent.setPackage("com.google.android.apps.maps");

                new CountDownTimer(120, 60) {
                    public void onTick(long millisUntilFinished) {
                        v.setBackgroundColor(getResources().getColor(R.color.x_pink));
                    }

                    public void onFinish() {
                        v.setBackgroundColor(getResources().getColor(R.color.whiteCoracao));
                        startActivity(mapIntent);
                    }
                }.start();


            }
        });

        mail1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                Uri uri = Uri.parse("mailto: geral@pepdevils.pt");
                Intent intent = new Intent(Intent.ACTION_SEND, uri);
                intent.setType("message/rfc822");
                intent.putExtra(Intent.EXTRA_EMAIL, new String[]{"geral@pepdevils.pt"});
                final Intent mailer = Intent.createChooser(intent, "Escolha como enviar o email:");

                new CountDownTimer(120, 60) {
                    public void onTick(long millisUntilFinished) {
                        v.setBackgroundColor(getResources().getColor(R.color.x_blue));
                    }

                    public void onFinish() {
                        v.setBackgroundColor(getResources().getColor(R.color.whiteCoracao));

                        startActivity(mailer);

                    }
                }.start();


            }
        });


        mail2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                Uri uri = Uri.parse("mailto: geral@pepdevils.pt");
                Intent intent = new Intent(Intent.ACTION_SEND, uri);
                intent.setType("message/rfc822");
                intent.putExtra(Intent.EXTRA_EMAIL, new String[]{"pepdevils@me.com"});
                final Intent mailer = Intent.createChooser(intent, "Escolha como enviar o email:");
                new CountDownTimer(120, 60) {
                    public void onTick(long millisUntilFinished) {
                        v.setBackgroundColor(getResources().getColor(R.color.x_burgundy));
                    }

                    public void onFinish() {
                        v.setBackgroundColor(getResources().getColor(R.color.whiteCoracao));
                        startActivity(mailer);
                    }
                }.start();

            }
        });

        top.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (cat1.getVisibility() == View.INVISIBLE || cat2.getVisibility() == View.INVISIBLE) {
                    cat1.setVisibility(View.VISIBLE);
                    cat2.setVisibility(View.VISIBLE);

                } else {
                    cat1.setVisibility(View.INVISIBLE);
                    cat2.setVisibility(View.INVISIBLE);
                }

                DisplayMetrics metrics = new DisplayMetrics();
                getWindowManager().getDefaultDisplay().getMetrics(metrics);
                float alturaEquip = metrics.heightPixels;
                float alturaAnim = alturaEquip + 300.0f;

                TranslateAnimation anim1 = new TranslateAnimation(0.0f, 0f, alturaAnim, -alturaAnim);
                anim1.setInterpolator(new LinearInterpolator());
                anim1.setRepeatCount(Animation.INFINITE);
                anim1.setRepeatMode(3);
                anim1.setDuration(5000);

                TranslateAnimation anim2 = new TranslateAnimation(0.0f, 0f, alturaAnim, -alturaAnim);
                anim2.setInterpolator(new LinearInterpolator());
                anim2.setRepeatCount(Animation.INFINITE);
                anim2.setRepeatMode(3);
                anim2.setDuration(5010);


                if (cat1.getVisibility() == View.VISIBLE || cat2.getVisibility() == View.VISIBLE) {
                    cat1.startAnimation(anim1);
                    cat2.startAnimation(anim2);


                } else {
                    cat1.setAnimation(null);
                    cat2.setAnimation(null);
                }
            }
        });

        Animation a = new AlphaAnimation(0.00f, 1.00f);
        a.setDuration(2000);
        a.setAnimationListener(new Animation.AnimationListener() {
            public void onAnimationStart(Animation animation) {
                // TODO Auto-generated method stub
                svView.setVisibility(View.GONE);
                top.setVisibility(View.GONE);
                bottom.setVisibility(View.GONE);
                phone1.setVisibility(View.GONE);
                phone2.setVisibility(View.GONE);
                phone3.setVisibility(View.GONE);
                mail1.setVisibility(View.GONE);
                mail2.setVisibility(View.GONE);
                morada.setVisibility(View.GONE);
            }

            public void onAnimationRepeat(Animation animation) {
                // TODO Auto-generated method stub
            }

            public void onAnimationEnd(Animation animation) {
                svView.setVisibility(View.VISIBLE);
                top.setVisibility(View.VISIBLE);
                bottom.setVisibility(View.VISIBLE);
                phone1.setVisibility(View.VISIBLE);
                phone2.setVisibility(View.VISIBLE);
                phone3.setVisibility(View.VISIBLE);
                mail1.setVisibility(View.VISIBLE);
                mail2.setVisibility(View.VISIBLE);
                morada.setVisibility(View.VISIBLE);
            }
        });
        svView.startAnimation(a);
        top.startAnimation(a);
        bottom.startAnimation(a);
        phone1.startAnimation(a);
        phone2.startAnimation(a);
        phone3.startAnimation(a);
        mail1.startAnimation(a);
        mail2.startAnimation(a);
        morada.startAnimation(a);
    }


    @Override
    protected void onResume() {
        super.onResume();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

    }
}
