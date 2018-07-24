package com.pepdevils.lascasas;

import android.content.pm.PackageManager;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;

import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import partilhado.ApiHelper;
import partilhado.AppHelper;
import partilhado.Imovel;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback, GoogleMap.OnMarkerClickListener, GoogleMap.OnInfoWindowClickListener {

    private GoogleMap mMap;

    Toolbar toolbar;

    Imovel[] arrayCasas;

    private Marker myMarker;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        AppHelper.AddMenu(this);
        DetectaConexao.existeConexao(this);
        setContentView(R.layout.activity_maps);
        toolbar = (Toolbar) findViewById(R.id.barra_titulo);
        int[] ids = {
                R.id.Title
        };
        AppHelper.ConfigureActivity(this, ids);

        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

    }


    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;


        if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        } else {
            // Show rationale and request permission.
            Toast.makeText(this, "a carregar... espere um pouco", Toast.LENGTH_LONG).show();

            //mensagem Original
            //Toast.makeText(this, "a requerir permissão --Google Maps--", Toast.LENGTH_SHORT).show();
        }


        //LOACALIZAÇÂO CORRENTE
        try {
            mMap.setMyLocationEnabled(true);
            LocationManager locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
            Criteria criteria = new Criteria();
            String provider = locationManager.getBestProvider(criteria, true);
            Location myLocation = locationManager.getLastKnownLocation(provider);
            googleMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);
            double myLatitude = myLocation.getLatitude();
            double myLongitude = myLocation.getLongitude();
            LatLng mylatLng = new LatLng(myLatitude, myLongitude);
            mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(mylatLng, 15));

/*          Marker marker = mMap.addMarker(new MarkerOptions().position(new LatLng(myLatitude, myLongitude)).title("Você está Aqui !"));
            marker.showInfoWindow();*/
        } catch (Exception e) {
            e.printStackTrace();

            //LOCALIZAÇÃO INICIAL caso GPS off
            double iLatitude = 41.5503200;
            double iLongitude = -8.4200500;
            LatLng ilatLng = new LatLng(iLatitude, iLongitude);
            mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(ilatLng, 12));
        }

        //MARCAR AS CASAS
        try {
            arrayCasas = ApiHelper.GetLatLongs();

            for (int i = 0; i < arrayCasas.length; i++) {

                try {
                    //MARCAÇÃO DAS CASAS SEGUNDO A LOCALIZAÇÃO NA API
                    LatLng x = new LatLng(arrayCasas[i].getLocation()[0], arrayCasas[i].getLocation()[1]);
                    mMap.setOnMarkerClickListener(this);
                    mMap.setOnInfoWindowClickListener(this);
                    myMarker = mMap.addMarker(new MarkerOptions()
                            .position(x)
                            .title(Integer.toString(i))
                            .draggable(false)
                            .icon(BitmapDescriptorFactory.fromResource(R.drawable.gps_marker)));

                } catch (Exception e) {
                    e.printStackTrace();

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        //PARA CUSTOMIZAR O INFO_WINDOW DO MARCADOR
        if (mMap != null) {
            mMap.setInfoWindowAdapter(new GoogleMap.InfoWindowAdapter() {

                //Criar layout que vai aparecer no infowindow do marcador
                View v = getLayoutInflater().inflate(R.layout.marker_info_window, null);

                @Override
                public View getInfoWindow(final Marker marker) {

                    /*//Criar a view, que inflaciona o layout criado para o infowindow
                    v = LayoutInflater.from(MapsActivity.this).inflate(R.layout.marker_info_window, null);*/

                    if (marker != null
                            && marker.isInfoWindowShown()) {
                        marker.hideInfoWindow();
                        marker.showInfoWindow();
                    }

                    return null;
                }


                @Override
                public View getInfoContents(Marker marker) {


                    //Vai buscar os dados das casas a API, neste caso o titulo
                    String title = marker.getTitle().toString();
                    Imovel imovel = arrayCasas[Integer.decode(title)];

                    //Conteudo do layout
                    TextView tvLocalidade = (TextView) v.findViewById(R.id.tv_localidade);
                    ImageView miniCasa = (ImageView) v.findViewById(R.id.imageViewInfoWindow);

                    //Fazer resize da imagem para se adaptar a todos os ecras
                    float width = (getResources().getDisplayMetrics().widthPixels) / 2f;
                    float height = width * (2f / 3f);
                    miniCasa.setLayoutParams(new LinearLayout.LayoutParams((int) width,
                            (int) height));

                    //vai buscar o latitude e lonfitude da posição do marcador
                    LatLng ll = marker.getPosition();

                    //Dados tirados do marcador para preencher o layout
                    tvLocalidade.setText(imovel.titulo);
                    AppHelper.SetImageFromURL(getApplicationContext(), miniCasa, imovel.getImagemURL());


                    return v;
                }
            });

        }
    }


    //QUANDO CLICAR NO MARCADOR IR PARA PAGINA CASA
    @Override
    public boolean onMarkerClick(Marker marker) {
        mMap.moveCamera(CameraUpdateFactory.zoomTo(16));
        marker.showInfoWindow();
        return false;
    }


    //OU QUANDO O POP UP DO MARCADOR É CLICADO
    @Override
    public void onInfoWindowClick(Marker marker) {
        String textIndex = marker.getTitle();
        int index = (Integer.decode(textIndex));
        AppHelper.StartActivityCasa(MapsActivity.this, arrayCasas[index]);

    }

    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        DetectaConexao.existeConexao(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        AppHelper.ReplaceMenu(this);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        DetectaConexao.existeConexao(this);
    }

}
