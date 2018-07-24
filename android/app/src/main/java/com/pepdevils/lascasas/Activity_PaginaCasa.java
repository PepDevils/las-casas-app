package com.pepdevils.lascasas;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.Toolbar;
import android.text.InputType;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bluejamesbond.text.DocumentView;
import com.bluejamesbond.text.hyphen.DefaultHyphenator;
import com.bluejamesbond.text.hyphen.IHyphenator;
import com.bluejamesbond.text.style.TextAlignment;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.ArrayList;
import java.util.Arrays;

import custom_banner.Gallery;
import partilhado.ApiHelper;
import partilhado.AppHelper;
import partilhado.Imovel;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_PaginaCasa extends FragmentActivity implements OnMapReadyCallback {

    ImageButton imagButton;

    public int casaID;

    public boolean liked;

    Double latitude;
    Double longitude;

    View botaoCall;
    View botaoVisit;

    Toolbar toolbar;

    String[] smallImageURLs;// = new String[imageIDs.length];


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        setContentView(R.layout.pagina_casa);

        toolbar = (Toolbar) findViewById(R.id.barra_titulo);

        int[] ids = {R.id.textTitulo,
                R.id.textDescription,
                R.id.textID,
                R.id.textPrice,
                R.id.Title
        };

        AppHelper.ConfigureActivity(this, ids);
        InflateInfo();
        MapSetup();

        botaoCall = findViewById(R.id.call);
        botaoCall.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Uri uri = Uri.parse("tel:+351961385433");
                Intent intent = new Intent(Intent.ACTION_DIAL, uri);
                startActivity(intent);
            }
        });


        botaoVisit = findViewById(R.id.visit);
        botaoVisit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Uri gmmIntentUri = Uri.parse("google.navigation:q=" + latitude + "," + longitude);
                Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
                mapIntent.setPackage("com.google.android.apps.maps");
                startActivity(mapIntent);

            }
        });

        imagButton = (ImageButton) findViewById(R.id.imageButton);
        liked = false;
        Imovel[] imoveisFavoritos = ApiHelper.GetFavourites();

        if (imoveisFavoritos != null) {
            for (int i = 0; i < imoveisFavoritos.length; i++) {
                if (imoveisFavoritos[i].ID == casaID) {
                    imagButton.setImageResource(R.drawable.coracao_in_love);
                    liked = true;
                    break;
                }
            }
        }

        View.OnClickListener imgButtonHandler = new View.OnClickListener() {
            public void onClick(View v) {

                if (!liked) {
                    if (ApiHelper.AddFavorite(Activity_PaginaCasa.this, getIntent().getIntExtra("ID", 0))) {
                        imagButton.setImageResource(R.drawable.coracao_in_love);
                        Toast.makeText(getApplicationContext(), "Imóvel adicionado aos favoritos", Toast.LENGTH_SHORT).show();
                        liked = true;
                    }


                } else {
                    if (ApiHelper.RemoveFavorite(Activity_PaginaCasa.this, getIntent().getIntExtra("ID", 0))) {
                        imagButton.setImageResource(R.drawable.coracao);
                        Toast.makeText(getApplicationContext(), "Imóvel retirado dos favoritos", Toast.LENGTH_SHORT).show();
                        liked = false;
                    }
                }
            }
        };
        imagButton.setOnClickListener(imgButtonHandler);
        imagButton.setBackgroundColor(getResources().getColor(R.color.whiteCoracao));

    }


    @Override
    public void onMapReady(GoogleMap googleMap) {
        try {

            latitude = Activity_PaginaCasa.this.getIntent().getDoubleExtra("latitude", 0f);
            longitude = Activity_PaginaCasa.this.getIntent().getDoubleExtra("longitude", 0f);
            LatLng x = new LatLng(latitude, longitude);
            googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(x, 18));
            googleMap.setMapType(GoogleMap.MAP_TYPE_HYBRID);
            googleMap.getUiSettings().setScrollGesturesEnabled(false);

            googleMap.getUiSettings().setAllGesturesEnabled(false);

            googleMap.addMarker(new MarkerOptions()
                    .position(x)
                    .draggable(false)
                    .icon(BitmapDescriptorFactory.fromResource(R.drawable.gps_marker)));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void MapSetup() {
        try {

            SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                    .findFragmentById(R.id.map);
            mapFragment.getMapAsync(this);
        } catch (Exception b) {
            b.printStackTrace();
        }
    }

    private void InflateInfo() {
        String title = getIntent().getStringExtra("title");
        casaID = getIntent().getIntExtra("ID", 0);
        String text = getIntent().getStringExtra("text");

        String ID = getIntent().getStringExtra("MLS");
        String price = getIntent().getStringExtra("price");


        TextView titulo = (TextView) findViewById(R.id.textTitulo);
        titulo.setText(title);
        if (title == null) {
            titulo.setText("Indisponível");
        }

        DocumentView documentView = (DocumentView) findViewById(R.id.textDescription);
        documentView.setText(text);
        if (text == null) {
            documentView.setText("Descrição indisponível de momento");
        }


        TextView id = (TextView) findViewById(R.id.textID);
        id.setText("ID: " + ID);
        if (ID == null) {
            id.setText("ID: Indisponível");
        }

        TextView preco = (TextView) findViewById(R.id.textPrice);
        preco.setText(price);
        if (price == null) {
            preco.setText("preço sob consulta");
        }


        //IMAGENS
        //Load URLs das imagens
/*        int width = getResources().getDisplayMetrics().widthPixels;
        int height = width * 2 / 3;*/
        smallImageURLs = ApiHelper.getGalleryURLs(casaID, null, null);
        try {
            Gallery sib = (Gallery) findViewById(R.id.gallery);
            sib.setSource(Arrays.asList(smallImageURLs));
            sib.startScroll();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

        //Des_animar toda a view com opacity a 50% e por a 100%
        botaoCall.setAlpha(1);
        botaoVisit.setAlpha(1);
    }

    @Override
    protected void onResume() {
        super.onResume();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

        //Iniciar sem selecionar os EditText
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
    }
}