package com.pepdevils.lascasas;


import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;

import partilhado.ApiHelper;
import partilhado.AppHelper;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Activity_Procura extends AppCompatActivity {

    private Toolbar toolbar;
    Button searchButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        setContentView(R.layout.procura);
        DetectaConexao.existeConexao(this);

        toolbar = (Toolbar) findViewById(R.id.barra_titulo);

        int[] ids = { R.id.text_titulo,
                R.id.text_tipo,
                R.id.text_imovel,
                R.id.text_quartos,
                R.id.text_localidade,
                R.id.text_freguesia,
                R.id.text_min,
                R.id.text_max,
                R.id.botao_encontrar,
                R.id.Title
        };

        toolbar = (Toolbar) findViewById(R.id.barra_titulo);
        setSupportActionBar(toolbar);

        AppHelper.ConfigureActivity(this, ids);
        PopulateSpinners();


        searchButton = (Button)findViewById (R.id.botao_encontrar);
        searchButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Search();
            }
        });
    }

    private void Search() {

        Spinner tipo = (Spinner)findViewById (R.id.spinner_tipo);
        Spinner imovel = (Spinner)findViewById (R.id.spinner_imovel);
        Spinner quartos = (Spinner)findViewById (R.id.spinner_quartos);
        Spinner localidade = (Spinner)findViewById (R.id.spinner_localidade);
        Spinner freguesia = (Spinner)findViewById (R.id.spinner_freguesia);
        Spinner min = (Spinner)findViewById (R.id.spinner_min);
        Spinner max = (Spinner)findViewById (R.id.spinner_max);

        Intent pesquisa = new Intent(this, Activity_PesquisaResultado.class);

        pesquisa.putExtra("tipo", (String) tipo.getSelectedItem());
        pesquisa.putExtra("imovel", (String) imovel.getSelectedItem());
        pesquisa.putExtra("quartos", (String) quartos.getSelectedItem());
        pesquisa.putExtra("localidade", (String) localidade.getSelectedItem());
        pesquisa.putExtra("freguesia", (String) freguesia.getSelectedItem());
        pesquisa.putExtra("min", (String) min.getSelectedItem());
        pesquisa.putExtra("max", (String) max.getSelectedItem());
        pesquisa.putExtra("toolbar", "pesquisa");

        startActivity(pesquisa);

    }

    public void PopulateSpinners() {
        final Spinner localidade = (Spinner)findViewById(R.id.spinner_localidade);

        localidade.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                try {
                    PopulateSpinner(R.id.spinner_freguesia, ApiHelper.GetFreguesia((String) localidade.getSelectedItem()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        try {
            PopulateSpinner (R.id.spinner_tipo, ApiHelper.GetStatus());
            PopulateSpinner (R.id.spinner_imovel, ApiHelper.GetTiposDeImoveis());
            PopulateSpinner (R.id.spinner_quartos, ApiHelper.GetQuartos());
            PopulateSpinner (R.id.spinner_localidade, ApiHelper.GetLocalidade());
            PopulateSpinner(R.id.spinner_freguesia, ApiHelper.GetFreguesia((String) localidade.getSelectedItem()));
        }catch (Exception e){
            e.printStackTrace();
        }


        List<String> items = new ArrayList<String>();
        items.add("0");
        items.add("25000");
        items.add("50000");
        items.add("75000");
        items.add("100000");
        items.add("125000");
        items.add("150000");
        items.add("175000");
        items.add("200000");
        items.add("250000");
        items.add("300000");
        items.add("350000");
        items.add("400000");
        items.add("450000");
        items.add("500000");
        items.add("600000");
        items.add("700000");
        items.add("800000");
        items.add("900000");
        items.add("1000000");

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.my_spinner_item, items);

        Spinner spinnerMin = (Spinner)findViewById(R.id.spinner_min);
        spinnerMin.setAdapter(adapter);
        Spinner spinnerMax = (Spinner)findViewById(R.id.spinner_max);
        spinnerMax.setAdapter(adapter);
    }

    private void PopulateSpinner(int spinnerID, String[] items) {

        try {

            String[] _items = new String[items.length + 1];
            _items[0] = getResources().getString(R.string.qualquer);

            for (int i = 0; i < items.length; i++)
                _items [i + 1] = items [i];

            Spinner spinner = (Spinner)findViewById(spinnerID);
            ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.my_spinner_item, _items);
            adapter.setDropDownViewResource(R.layout.support_simple_spinner_dropdown_item);
            spinner.setAdapter(adapter);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

    }

    @Override
    protected void onResume() {
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
        AppHelper.ReplaceMenu(this);
        DetectaConexao.existeConexao(this);
        super.onResume();
    }
}

