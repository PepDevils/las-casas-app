package partilhado;

import com.bumptech.glide.Glide;
import com.pepdevils.lascasas.Activity_PaginaCasa;
import com.pepdevils.lascasas.MyErro;
import com.pepdevils.lascasas.R;

import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.os.AsyncTask;

import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import java.security.MessageDigest;

import java.net.URL;
import java.text.Normalizer;

import fragments.Fragment_BarraMenu;
import fragments.Fragment_BarraMenu_Inicial;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class AppHelper extends AppCompatActivity {

    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */

    private static TextView title;

    public static void ConfigureActivity(Activity a, int[] viewIDs) {
        AddMenu(a);
        SetFont(((ViewGroup) a.findViewById(android.R.id.content)).getChildAt(0), viewIDs);
    }

    public static void SetFont(View a, int[] viewIDs) {

        try {
            Typeface tf = Typeface.createFromAsset(MyErro.getAppContext().getAssets(), "fonts/CooperHewitt-Semibold.otf");

            for (int id : viewIDs) {
                title = (TextView) a.findViewById(id);
                title.setTypeface(tf);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public static String GetTextFromView(Activity a, int viewID) {
        TextView textView = (TextView) a.findViewById(viewID);
        return textView.getText().toString();
    }

    public static void AddMenu(Activity a) {
        Fragment_BarraMenu menu = new Fragment_BarraMenu();

        FragmentTransaction fragmentTransaction = a.getFragmentManager().beginTransaction();
        fragmentTransaction.add(R.id.frameLayout, menu);

        fragmentTransaction.commit();
    }

    public static void ReplaceMenu(Activity a) {
        Fragment_BarraMenu menu = new Fragment_BarraMenu();
        FragmentTransaction fragmentTransaction = a.getFragmentManager().beginTransaction();
        fragmentTransaction.replace(R.id.frameLayout, menu);
        fragmentTransaction.commit();
    }

    public static void AddMenuInicial(Activity a) {
        Fragment_BarraMenu_Inicial menu = new Fragment_BarraMenu_Inicial();

        FragmentTransaction fragmentTransaction = a.getFragmentManager().beginTransaction();
        fragmentTransaction.add(R.id.frameLayout, menu);

        fragmentTransaction.commit();
    }

    public static void ReplaceMenuInicial(Activity a) {
        Fragment_BarraMenu_Inicial menu = new Fragment_BarraMenu_Inicial();
        FragmentTransaction fragmentTransaction = a.getFragmentManager().beginTransaction();
        fragmentTransaction.replace(R.id.frameLayout, menu);
        fragmentTransaction.commit();
    }



    public static void StartActivityCasa(Context c, Imovel casa) {
        Intent intent = new Intent(c, Activity_PaginaCasa.class);

        intent.putExtra("title", casa.titulo);
        intent.putExtra("ID", casa.ID);
        intent.putExtra("text", casa.getTexto());
        intent.putExtra("MLS", casa.MLS);
        intent.putExtra("price", casa.preco);
        intent.putExtra("latitude", casa.getLocation()[0]);
        intent.putExtra("longitude", casa.getLocation()[1]);

        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        c.startActivity(intent);
    }

    //Recebe a informação em String de uma URL
/*    public static Bitmap GetImageBitmapFromUrl(String url) {
        try {
            return new GetUrlTask().execute(url).get();
        } catch (Exception e) {
            return null;
        }
    }*/


    public static void SetImageFromURL(Context c, ImageView iv, String url) {
        Glide.with(c)
                .load(url)
                .centerCrop()
                .placeholder(R.drawable.placeholder_maps)
                .into(iv);
    }
    public static void SetImageFromURL2(Context c, ImageView iv, String url) {
        Glide.with(c)
                .load(url)
                .centerCrop()
                .placeholder(R.drawable.example_270x220)
                .into(iv);
    }

    public static void SetImageFromURL(Activity c, ImageView iv, String url) {
        Glide.with(c)
                .load(url)
                .centerCrop()
                .placeholder(R.drawable.example_270x220)
                .into(iv);
    }


    private static class GetUrlTask extends AsyncTask<String, Integer, Bitmap> {
        @Override
        protected Bitmap doInBackground(String... params) {
            try {
                URL newUrl = new URL(params[0]);
                return BitmapFactory.decodeStream(newUrl.openConnection().getInputStream());

            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        }
    }

    //Codifica a palavra passe para ser enviada para o servidor
    public static String EncodedPassword(String rawPassword) {
        // Encriptação do tipo SHA-256
        try {
            //Throw error para não usar esta função
            //throw new Exception();
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(rawPassword.getBytes("UTF-8")); // Change this to "UTF-16" if needed
            byte[] digest = md.digest();
            return String.format("%064x", new java.math.BigInteger(1, digest));
        }
        catch (Exception e) {
            return rawPassword;
        }
    }


    //METODO PARA RETIRAR OS ASSENTOS DAS STRINGS
    public static String removerAcentos(String str) {
        return Normalizer.normalize(str, Normalizer.Form.NFD).replaceAll("[^\\p{ASCII}]", "");
    }

/*        public static Bitmap GetImageBitmapFromUrl(String imageURL, String extention) {
        char[] _imageURL = imageURL.toCharArray();
        char[] newVersion = new char[_imageURL.length - 4];

        for (int i = 0; i < newVersion.length; i++)
            newVersion[i] = _imageURL[i];

        String result = new String(newVersion) + extention;
        return GetImageBitmapFromUrl(result);
    }


        public static Bitmap GetImageBitmapFromUrl(String url, int width, int height) {
        return ImageResizer(GetImageBitmapFromUrl(url), width, height);
    }

    public static Bitmap GetImageBitmapFromRaw(byte[] rawImage) {
        Bitmap imageBitmap = null;

        try {
            if (rawImage != null)
                imageBitmap = BitmapFactory.decodeByteArray(rawImage, 0, rawImage.length);
        } catch (Exception e) {
        }

        return imageBitmap;
    }


    private static Bitmap ImageResizer(Bitmap originalImage, float width, float height) {
        try {
            //
            float altura_do_alvo = 0;
            float largura_do_alvo = 0;
            //
            int altura = originalImage.getHeight();
            int largura = originalImage.getWidth();
            //
            if (altura > largura) {
                altura_do_alvo = height;
                float divisor = altura / height;
                largura_do_alvo = largura / divisor;
            } else {
                largura_do_alvo = width;
                float divisor = largura / width;
                altura_do_alvo = altura / divisor;
            }

            return Bitmap.createScaledBitmap(originalImage, (int) largura_do_alvo, (int) altura_do_alvo, false);

        } catch (Exception ex) {
            return originalImage;
        }
    }
*/

}
