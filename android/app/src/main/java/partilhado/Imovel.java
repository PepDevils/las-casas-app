package partilhado;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Whitelist;

import java.security.spec.ECField;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class Imovel {

    public int ID;
    public String MLS;
    public String titulo;

    public String preco;

    public String imagemURL;
    public int imagemID;
    private String[] gallery = null;
    public EstadoCasa estado;
    private Double[] location = null;
    private String texto;

    //etiquetas
    public enum EstadoCasa {
        Disponivel,
        Reservado,
        Vendido,
        Arrendar,
        Arrendado
    }

/*
    public Imovel(int ID){

        try {
            String search = "http://lascasas.pt/app/mobile_api.php?func=get_baseinfo&casa=" + ID;
            String jobj = ApiHelper.GetStringFromURL(search);
            JSONObject imovel = new JSONObject(jobj);

            this.ID = imovel.getInt("ID");
            this.MLS = imovel.getString("MLS");

            this.titulo = imovel.getString("post_title");
            this.imagemID = imovel.getInt("frontImageID");
            this.preco = imovel.getString("price");

            String state = imovel.getString("status");
            this.estado = Imovel.EstadoCasa.Disponivel;
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

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
*/


    public Imovel(int id, String MLS, String titulo, String preco, int imagemID, EstadoCasa estado) {
        this.ID = id;
        this.MLS = MLS;
        this.titulo = titulo;
        this.imagemID = imagemID;
        this.estado = estado;
        this.gallery = null;


        char divisor = '.';
        if(preco!=null) {
            char[] _preco = preco.toString().toCharArray();
            char[] _newPreco = new char[_preco.length + (int) ((_preco.length - 1) / 3)];

            int nDePontosQueFaltam = _newPreco.length - _preco.length;
            for (int i = _preco.length - 1; i >= 0; i--) {
                if (_preco.length - 1 - i != 0 && (_preco.length - 1 - i) % 3 == 0)
                    _newPreco[i + nDePontosQueFaltam--] = divisor;

                _newPreco[i + nDePontosQueFaltam] = _preco[i];
            }

            this.preco = new String(_newPreco) + " €";
        }else{
            this.preco=null;
        }
    }

    public Double[] getLocation() {
        try {
            if (location == null){
                location=new Double[2];

                String[] aux = ApiHelper.getLocation(ID);
                location[0]=Double.valueOf(aux[0]);
                location[1]=Double.valueOf(aux[1]);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            location=new Double[2];
        }
        return location;
    }

    public void setLocation(Double latitude, Double longitude) {
        if (location == null) location = new Double[2];
        location[0]=latitude;
        location[1]=longitude;
    }

    public String getImagemURL() {
        if (imagemURL == null)
            return imagemURL = ApiHelper.getImageURL(imagemID);
        else
            return imagemURL;
    }

    public void setImagemURL(String url) {
            imagemURL = url;
    }

    public String[] getGallery() {

        try {
            Integer.decode(gallery[0]);
        } catch (Exception e) {
            gallery = ApiHelper.getImages(this.ID);
        }

        return gallery;
    }

    public String[] getGalleryURLs() {

        try {
            if (gallery[0] == null) throw new Exception("Erro ao obter a galeria do Imóvel.");
        } catch (Exception e) {
            gallery = ApiHelper.getImages(this.ID);
        }

        return gallery;
    }

    public void setGallery(String[] URLs) {
        gallery = URLs;
    }


    public String getTexto() {

        if (texto == null) {

            Document document = Jsoup.parse((ApiHelper.getText(ID)));

            //makes html() preserve linebreaks and spacing
            document.outputSettings(new Document.OutputSettings().prettyPrint(false));
            document.select("br").append("\\n");
            document.select("p").prepend("\\n\\n");
            String s = document.html().replaceAll("\\\\n", "\n");
            s = s.replaceAll("&nbsp;", "");

            this.texto = Jsoup.clean(s, "", Whitelist.none(), new Document.OutputSettings().prettyPrint(false));

        }
        return texto;
    }
}
