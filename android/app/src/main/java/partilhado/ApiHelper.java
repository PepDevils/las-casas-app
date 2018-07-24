package partilhado;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Toast;

import com.pepdevils.lascasas.Activity_AreaPessoal;
import com.pepdevils.lascasas.Activity_Favoritos;
import com.pepdevils.lascasas.Activity_PesquisaResultado;
import com.pepdevils.lascasas.MyErro;
import com.pepdevils.lascasas.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;

import fragments.Fragment_BarraMenu;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class ApiHelper {

    public static String baseURL = "http://lascasas.pt/app/mobile_api.php?func=";

    //Recebe a informação em String de uma URL
    public static String GetStringFromURL(String url) {
        try {
            return new GetUrlTask().execute(url).get();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static class GetUrlTask extends AsyncTask<String, Integer, String> {
        @Override
        protected String doInBackground(String... params) {
            return GetURLString(params);
        }
    }

    private static String GetURLString(String... params) {
        URL newUrl;
        BufferedReader in;
        String inputLine = "";

        try {

            //REtirar os espaços de strings
            String strURLespaços = params[0].replaceAll(" ", "%20");

            //Retirar assentos de strings
            String strURlassentos = AppHelper.removerAcentos(strURLespaços);

            newUrl = new URL(strURlassentos);
            InputStream a = newUrl.openStream();
            InputStreamReader aux = new InputStreamReader(a);
            in = new BufferedReader(aux);
            String textoLido = "";
            while ((textoLido = in.readLine()) != null) {
                inputLine += textoLido;
            }
            in.close();

        } catch (Exception e) {
            String aux = e.getMessage();
            return null;
        }

        return inputLine;
    }

    public static boolean RegisterUser(String email, String password) {
        password = AppHelper.EncodedPassword(password);
        String URL = baseURL + "register_user&email=" + email + "&password=" + password /*+ "&phone=" + getPhoneNumber()*/;
        String result = GetStringFromURL(URL);

        return (result.equals("Got it!"));
    }


    public static String PerdeuPalavraPasse(String email) {
        final String APIkey = "qwerty";
        final String APIlink = "http://lascasas.pt/app/inscricao/mail/smartprocess.php?email=" + email + "&key=" + APIkey;

        GetStringFromURL(APIlink);

        String result = "Verifique o seu email, tem uma password nova";

        return result;
    }

    //LogIn atravéz da api interna
    public static String LogIn(String email, String encryptedPassword) {
        String result;

        if (encryptedPassword != "" && email != "") {
            encryptedPassword = AppHelper.EncodedPassword(encryptedPassword);
            String URL = baseURL + "get_user_data&email=" + email + "&password=" + encryptedPassword ;
            result = GetStringFromURL(URL);
        } else
            result = "Os campos não podem estar vazios";

        return result;
    }

    //LogIn com redes sociais
    public static String LogIn(Activity c, String email) {
        LogInHelper.email = email;

        String result = "";

        String URL = baseURL + "get_user_data&email=" + email + "&phone=" + getPhoneNumber();
        result = GetStringFromURL(URL);

        if (LogInHelper.isLogedIn()) {
            Fragment_BarraMenu.UpdateAccountButton();
            result = "Got it!";
            c.startActivity(Fragment_BarraMenu.IntAccount);
            c.finish();
        }

        return result;
    }

    public static String getPhoneNumber() {
        TelephonyManager tMgr = (TelephonyManager) MyErro.getAppContext().getSystemService(Context.TELEPHONY_SERVICE);
        String mPhoneNumber = tMgr.getLine1Number();
        return mPhoneNumber;
    }

    public static boolean AddFavorite(Context c, int casaID) {
        if (LogInHelper.isLogedIn()) {
            String URL = baseURL + "set_user_favorite&user_mail=" + LogInHelper.email + "&casa=" + casaID;
            String result = GetStringFromURL(URL);

            return (result.equals("Got it!"));
        } else {
            Toast.makeText(c, "Precisa de ter sessão iniciada para efetuar esta operação", Toast.LENGTH_LONG).show();
            return false;
        }
    }

    public static boolean RemoveFavorite(Context c, int casaID) {
        if (LogInHelper.isLogedIn()) {
            String URL = baseURL + "remove_user_favorite&user_mail=" + LogInHelper.email + "&casa=" + casaID;
            String result = GetStringFromURL(URL);

            return (result.equals("Got it!"));
        } else {
            Toast.makeText(c, "Precisa de ter sessão iniciada para efetuar esta operação", Toast.LENGTH_LONG).show();
            return false;
        }
    }

    public static Imovel[] GetFavourites() {
        Imovel[] imoveis = null;

        if (LogInHelper.isLogedIn()) {
            String url = baseURL + "get_user_favorites&user_mail=" + LogInHelper.email;

            String entireString = GetStringFromURL(url);
            String[] stringIDs = entireString.split(",");

            if (!stringIDs[0].equals("")) {

                imoveis = new Imovel[stringIDs.length];

                for (int i = 0; i < imoveis.length && i < stringIDs.length; i++) {
                    try {
                        String search = baseURL + "get_baseinfo&casa=" + stringIDs[i];
                        String jobj = GetStringFromURL(search);
                        JSONObject destaquesJson = new JSONObject(jobj);
                        imoveis[i] = MakeImovelFromJson(destaquesJson);
                    } catch (Exception e) {
                        e.printStackTrace();
                        Toast.makeText(MyErro.getAppContext(), "Sem Pesquisa", Toast.LENGTH_LONG).show();
                    }
                }
            }
        }
        return imoveis;
    }

    public static Imovel[] GetFavourites2() {
        Imovel[] imoveis = null;
        JSONObject imoveisJson;

        if (LogInHelper.isLogedIn()) {
            try {
                String url = baseURL + "get_user_favorites2&user_mail=" + LogInHelper.email;

                String result = GetStringFromURL(url);

                imoveisJson = new JSONObject(result);
                imoveis = new Imovel[imoveisJson.length()];

                for (int i = 0; i < imoveisJson.length(); i++) {
                    JSONObject JsonImovel = imoveisJson.getJSONObject("casa " + i);

                    // DADOS DO IMOVEL
                    int ID = JsonImovel.getInt("ID");
                    String MLS = JsonImovel.getString("MLS");
                    String titulo = JsonImovel.getString("post_title");
                    String preco = JsonImovel.getString("price");
                    int frontImageID = JsonImovel.getInt("frontImageID");
                    String[] imageURLs = JsonImovel.getString("gallery_urls").split(",");
                    String state = JsonImovel.getString("status");

                    Imovel.EstadoCasa estado;
                    switch (state) {
                        default:
                            estado = Imovel.EstadoCasa.Disponivel;
                            break;
                        case "reduced":
                            estado = Imovel.EstadoCasa.Reservado;
                            break;
                        case "sold":
                            estado = Imovel.EstadoCasa.Vendido;
                            break;
                        case "for-rent":
                            estado = Imovel.EstadoCasa.Arrendar;
                            break;
                        case "rented":
                            estado = Imovel.EstadoCasa.Arrendado;
                            break;
                    }

                    imoveis[i] = new Imovel(ID, MLS, titulo, preco, frontImageID, estado);
                    imoveis[i].setImagemURL(imageURLs[0]);
                    imoveis[i].setGallery(imageURLs);
                }
            } catch (Exception e) {
                e.printStackTrace();
                // Toast.makeText(MyErro.getAppContext(), "esta pesquisa não retornou imoveis \n por favor faça uma nova pesquisa", Toast.LENGTH_LONG).show();
            }
        }
        return imoveis;
    }


    public static String AlterarPassword(String oldPassword, String newPassword) {
        if (LogInHelper.isLogedIn()) {

            newPassword = AppHelper.EncodedPassword(newPassword);
            String url = baseURL + "change_password&email=" + LogInHelper.email + "&new=" + newPassword;

            if (!oldPassword.equals("")) {
                oldPassword = AppHelper.EncodedPassword(oldPassword);
                url += "&old=" + oldPassword;

            }

            String response = GetStringFromURL(url);
            return response;

        } else return "Inicie a sessão para poder alterar a palavra passe";
    }


    private static JSONObject tiposDeImoveis;

    public static String[] GetTiposDeImoveis() throws Exception {
        if (tiposDeImoveis == null) {
            String getTiposDeImoveisURL = baseURL + "get_items_type";
            String aux = GetStringFromURL(getTiposDeImoveisURL);
            tiposDeImoveis = new JSONObject(aux);
        }

        String[] tiposArray = new String[tiposDeImoveis.length()];

        for (int i = 0; i < tiposDeImoveis.length(); i++)
            tiposArray[i] = tiposDeImoveis.getJSONObject("item" + i).getString("name");

        return tiposArray;
    }


    private static Imovel[] positions;

    // Faz download das coordenadas de todas as casas
    public static Imovel[] GetLatLongs() throws Exception {
        if (positions == null) {

            String getLatLongsURL = baseURL + "get_all_locations";
            String aux = GetStringFromURL(getLatLongsURL);
            JSONObject result = new JSONObject(aux);
            positions = new Imovel[result.length()];
            JSONObject casa;

            for (int i = 0; i < result.length(); i++) {

                casa = result.getJSONObject("casa" + i);

                try {
                    int id;
                    String MLS;
                    String title;
                    String preco;
                    int idimage;
                    Imovel.EstadoCasa estado;
                    Double latitude, longitude;

                    try {
                        id = casa.getInt("ID");
                        title = casa.getString("post_title");
                        idimage = casa.getInt("frontImageID");
                        estado = Imovel.EstadoCasa.Disponivel;
                        preco = casa.getString("prince");
                        MLS = casa.getString("mls");

                        positions[i] = new Imovel(
                                id,
                                MLS,
                                title,
                                preco,
                                idimage,
                                estado);

                        latitude = casa.getDouble("lat");
                        longitude = casa.getDouble("long");

                        positions[i].setLocation(latitude, longitude);

                    } catch (Exception e) {
                        e.printStackTrace();
                        positions[i].setLocation(null, null);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return positions;
    }

    private static String[] status;

    public static String[] GetStatus() {
        if (status != null)
            return status;
        else {
            String getStatusURL = baseURL + "get_items_state";
            String entireString = GetStringFromURL(getStatusURL);
            String[] splittedString = entireString.split(",");
            status = splittedString;

            for (int i = 0; i < splittedString.length; i++) {

                switch (splittedString[i]) {
                    case "reduced":
                        status[i] = "Reservado";
                        break;
                    case "sold":
                        status[i] = "Vendido";
                        break;
                    case "for-sale":
                        status[i] = "Disponível";
                        break;
                    case "for-rent":
                        status[i] = "Arrendar";
                        break;
                    case "rented":
                        status[i] = "Arrendado";
                        break;
                    default:
                        status[i] = splittedString[i];
                        break;
                }
            }
            return status;
        }
    }

    private static String[] quartos;

    public static String[] GetQuartos() {
        if (quartos != null)
            return quartos;
        else {
            String getBedroomsURL = baseURL + "get_items_bedrooms";
            String entireString = GetStringFromURL(getBedroomsURL);
            String[] splittedString = entireString.split(",");
            quartos = splittedString;
            return splittedString;
        }
    }

    private static JSONObject localidades;

    public static String[] GetLocalidade() throws Exception {
        if (localidades == null) {
            String getLocalidadeURL = baseURL + "get_items_localidade";
            localidades = new JSONObject(GetStringFromURL(getLocalidadeURL));
        }

        String[] tiposArray = new String[localidades.length()];
        for (int i = 0; i < localidades.length(); i++)
            tiposArray[i] = localidades.getJSONObject("item" + i).getString("name");

        return tiposArray;
    }

    private static JSONObject freguesias;

    public static String[] GetFreguesia(String localidade) throws Exception {
        String localidadeSlug = "";
        for (int i = 0; i < localidades.length(); i++) {
            if (localidades.getJSONObject("item" + i).getString("name") == localidade)
                localidadeSlug = localidades.getJSONObject("item" + i).getString("slug");
        }

        if (localidadeSlug == "") return new String[0];
        String getFreguesiaURL = baseURL + "get_items_freguesia&localidade=" + localidadeSlug;
        freguesias = new JSONObject(GetStringFromURL(getFreguesiaURL));

        String[] tiposArray = new String[freguesias.length()];

        for (int i = 0; i < freguesias.length(); i++)
            tiposArray[i] = freguesias.getJSONObject("item" + i).getString("name");

        return tiposArray;
    }

    private static int itemsPerPage = 5;

    //Para a pesquisa
    public static Imovel[] getSearch(String aquisition, String type, String bedrooms, String localidade, String freguesia,
                                     String precoMin, String precoMax, int page, int width, int height) throws Exception {
        Imovel[] imoveis = new Imovel[0];
        JSONObject imoveisJson;

        String aquisitionTrad;

        switch (aquisition) {
            case "Reservado":
                aquisitionTrad = "reduced";
                break;
            case "Vendido":
                aquisitionTrad = "sold";
                break;
            case "Disponível":
                aquisitionTrad = "for-sale";
                break;
            case "Arrendar":
                aquisitionTrad = "for-rent";
                break;
            case "Arrendado":
                aquisitionTrad = "rented";
                break;
            default:
                aquisitionTrad = aquisition;
                break;
        }

        try {
            imoveis = new Imovel[itemsPerPage];
            String getSearchURL = baseURL + "search_ids2" + "&min=" + precoMin + "&max=" + precoMax + "&page=" + page + "&by_page=" + itemsPerPage;

            if (!aquisition.equals(MyErro.getAppContext().getResources().getString(R.string.qualquer)))
                getSearchURL += "&aquisition=" + aquisitionTrad;
            if (!type.equals(MyErro.getAppContext().getResources().getString(R.string.qualquer)))
                getSearchURL += "&type=" + type;
            if (!bedrooms.equals(MyErro.getAppContext().getResources().getString(R.string.qualquer)))
                getSearchURL += "&bedrooms=" + bedrooms;
            if (!localidade.equals(MyErro.getAppContext().getResources().getString(R.string.qualquer)))
                getSearchURL += "&localidade=" + localidade;
            if (!freguesia.equals(MyErro.getAppContext().getResources().getString(R.string.qualquer)))
                getSearchURL += "&freguesia=" + freguesia;

            String result = GetStringFromURL(getSearchURL);

            imoveisJson = new JSONObject(result);
            imoveis = new Imovel[imoveisJson.length()];

            for (int i = 0; i < imoveisJson.length(); i++) {
                JSONObject JsonImovel = imoveisJson.getJSONObject("casa " + i);

                // DADOS DO IMOVEL
                int ID = JsonImovel.getInt("ID");
                String MLS = JsonImovel.getString("MLS");
                String titulo = JsonImovel.getString("post_title");
                String preco = JsonImovel.getString("price");
                int frontImageID = JsonImovel.getInt("frontImageID");
                String[] imageURLs = JsonImovel.getString("gallery_urls").split(",");
                String state = JsonImovel.getString("status");

                Imovel.EstadoCasa estado;
                switch (state) {
                    default:
                        estado = Imovel.EstadoCasa.Disponivel;
                        break;
                    case "reduced":
                        estado = Imovel.EstadoCasa.Reservado;
                        break;
                    case "sold":
                        estado = Imovel.EstadoCasa.Vendido;
                        break;
                    case "for-rent":
                        estado = Imovel.EstadoCasa.Arrendar;
                        break;
                    case "rented":
                        estado = Imovel.EstadoCasa.Arrendado;
                        break;
                }

                imoveis[i] = new Imovel(ID, MLS, titulo, preco, frontImageID, estado);
                imoveis[i].setImagemURL(imageURLs[0]);
                imoveis[i].setGallery(imageURLs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return imoveis;
    }

    public static Imovel[] getDestaques(int screenWidth) throws Exception {
        String getDestaquesURL = baseURL + "get_destaques";
        JSONObject destaquesJson = new JSONObject(GetStringFromURL(getDestaquesURL));
        Imovel[] destaques = new Imovel[destaquesJson.length()];

        for (int i = 0; i < destaques.length; i++) {
            try {
                int id = destaquesJson.getJSONObject("casa" + i).getInt("ID");
                String title = destaquesJson.getJSONObject("casa" + i).getString("post_title");
                int imageID = destaquesJson.getJSONObject("casa" + i).getInt("frontImageID");
                String price = destaquesJson.getJSONObject("casa" + i).getString("price");
                String state = destaquesJson.getJSONObject("casa" + i).getString("status");
                String mls = destaquesJson.getJSONObject("casa" + i).getString("MLS");

                Imovel.EstadoCasa estado = Imovel.EstadoCasa.Disponivel;

                switch (state) {
                    case "for-sale":
                        estado = Imovel.EstadoCasa.Disponivel;
                        break;
                    case "reduced":
                        estado = Imovel.EstadoCasa.Reservado;
                        break;
                    case "sold":
                        estado = Imovel.EstadoCasa.Vendido;
                        break;
                    case "for-rent":
                        estado = Imovel.EstadoCasa.Arrendar;
                        break;
                    case "rented":
                        estado = Imovel.EstadoCasa.Arrendado;
                        break;
                }

                String imageURL = GetStringFromURL(baseURL + "get_image&image_id=" + imageID + "&width=" + screenWidth + "&height=" + screenWidth * 0.5625f);

                // 2/3

                // 9/16 - 0.5625f

                destaques[i] = new Imovel(id, mls, title, price, imageID, estado);

                destaques[i].imagemURL = imageURL;

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return destaques;
    }

    public static String getText(int ID) {
        return GetStringFromURL(baseURL + "get_text&casa=" + ID);
    }

    public static String[] getLocation(int ID) {
        return GetStringFromURL(baseURL + "get_location&casa=" + ID).split(",");
    }

    public static String[]  getImages(int ID) {
        return GetStringFromURL(baseURL + "get_images&casa=" + ID).split(",");
    }

    public static String getImageURL(int imageID) {
        return GetStringFromURL(baseURL + "get_image&image_id=" + imageID);
    }

    public static String getImageURL(int imageID, int width, int height) {
        if (width != 0 && height != 0)
            return GetStringFromURL(baseURL + "get_image&image_id=" + imageID + "&width=" + width + "&height=" + height);
        else {
            return "";
        }
    }

    public static String[] getGalleryURLs(int casaID, Integer width, Integer height) {
        if (width == null || height == null || (width != 0 && height != 0)) {
            // Construção do url do pedido
            String aux = baseURL + "get_gallery_urls&casa=" + casaID;
            if (width != null && width < 0 && height != null && height < 0)
                aux += "&width=" + width + "&height=" + height;

            // Pedido e divisão dos URLs retornados
            String URLs = GetStringFromURL(aux);
            return URLs.split(",");
        } else {
            return new String[0];
        }
    }

    public static Imovel MakeImovelFromJson(JSONObject imovel) throws Exception {
        int id = imovel.getInt("ID");
        String MLS = imovel.getString("MLS");
        String title = imovel.getString("post_title");
        int image = imovel.getInt("frontImageID");
        String state = imovel.getString("status");
        String price = imovel.getString("price");

        Imovel.EstadoCasa estado = Imovel.EstadoCasa.Disponivel;

        switch (state) {
            case "for-sale":
                estado = Imovel.EstadoCasa.Disponivel;
                break;
            case "reduced":
                estado = Imovel.EstadoCasa.Reservado;
                break;
            case "sold":
                estado = Imovel.EstadoCasa.Vendido;
                break;
            case "for-rent":
                estado = Imovel.EstadoCasa.Arrendar;
                break;
            case "rented":
                estado = Imovel.EstadoCasa.Arrendado;
                break;
        }

        return new Imovel(id, MLS, title, price, image, estado);
    }


}
