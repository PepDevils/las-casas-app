package fragments;

import android.content.Intent;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageButton;
import android.view.ViewGroup;

import com.pepdevils.lascasas.Activity_AreaPessoal;
import com.pepdevils.lascasas.Activity_Destaques;
import com.pepdevils.lascasas.Activity_IniciarSessao;
import com.pepdevils.lascasas.Activity_Procura;
import com.pepdevils.lascasas.MapsActivity;
import com.pepdevils.lascasas.MyErro;
import com.pepdevils.lascasas.R;

import partilhado.LogInHelper;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Fragment_BarraMenu extends Fragment {

    static View view;

    public static Intent IntHome = null,
            IntSearch = null,
            IntMap = null,
            IntAccount = null;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        InicialFunctions();

    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        view = inflater.inflate(R.layout.barra_menu, container, false);

        ButtonsFunctions();

        return view;
    }

    public void InicialFunctions() {

        if (IntHome == null)
            IntHome = new Intent(getActivity().getApplicationContext(), Activity_Destaques.class);
        if (IntSearch == null)
            IntSearch = new Intent(getActivity().getApplicationContext(), (Activity_Procura.class));
        if (IntMap == null)
            IntMap = new Intent(getActivity().getApplicationContext(), (MapsActivity.class));

        UpdateAccountButton();

        IntHome.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        IntHome.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);

        IntSearch.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        IntSearch.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);

        IntMap.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        IntMap.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);

    }

    public void ButtonsFunctions(){

        final ImageButton _home = (ImageButton)view.findViewById(R.id.button_home);
        _home.setFocusable(true);
        _home.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                _home.setFocusableInTouchMode(false);
                _home.setFocusable(false);
                startActivity(IntHome);
            }
        });

        final ImageButton _search = (ImageButton)view.findViewById(R.id.button_search);
        _search.setFocusable(true);
        _search.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                _search.setFocusableInTouchMode(false);
                _search.setFocusable(false);
                startActivity(IntSearch);
            }
        });

        final ImageButton _map = (ImageButton)view.findViewById(R.id.button_map);
        _map.setFocusable(true);
        _map.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                _map.setFocusableInTouchMode(false);
                _map.setFocusable(false);
                startActivity(IntMap);
            }
        });

        final ImageButton _account = (ImageButton)view.findViewById(R.id.button_account);
        _account.setFocusable(true);
        _account.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                _account.setFocusableInTouchMode(false);
                _account.setFocusable(false);
                startActivity(IntAccount);
            }
        });

        if(LogInHelper.isLogedIn()){
            _account.setBackgroundResource(R.drawable.button_selector_session);
        } else {
            _account.setBackgroundResource(R.drawable.button_selector_private);
        }

    }

    public static void UpdateAccountButton() {
        IntAccount = LogInHelper.isLogedIn() ?
                new Intent(MyErro.getAppContext(), Activity_AreaPessoal.class):
                new Intent(MyErro.getAppContext(), Activity_IniciarSessao.class);

        IntAccount.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        IntAccount.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);

        if(view!=null) {

            final ImageButton _account = (ImageButton)view.findViewById(R.id.button_account);
            if(LogInHelper.isLogedIn()){
                _account.setBackgroundResource(R.drawable.button_selector_session);
            } else {
                _account.setBackgroundResource(R.drawable.button_selector_private);
            }
        }
    }

    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public void onViewStateRestored(Bundle savedInstanceState) {
        super.onViewStateRestored(savedInstanceState);
    }
}
