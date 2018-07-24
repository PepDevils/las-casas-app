package partilhado;


import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.widget.Toast;

import com.pepdevils.lascasas.Activity_AreaPessoal;
import com.pepdevils.lascasas.Activity_IniciarSessao;
import com.pepdevils.lascasas.MyErro;
import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.Profile;
import com.facebook.ProfileTracker;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.google.android.gms.auth.api.Auth;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInResult;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.facebook.FacebookSdk;

import org.json.JSONObject;

import java.util.Arrays;

import fragments.Fragment_BarraMenu;

/**
 * Created by Pedro Fonseca on 13/01/2016.
 */
public class LogInHelper implements GoogleApiClient.OnConnectionFailedListener {

    static GoogleApiClient mGoogleApiClient;
    static CallbackManager callbackManager;
    static AccessTokenTracker accessTokenTracker;
    static AccessToken accessToken;
    static ProfileTracker profileTracker;
    static final int GOOGLE_SIGN_IN = 0;

    public static String email = null;
    public static String id = null;
    public static String fullName = null;

    public static boolean isLogedIn() {
        return (email != null);
    }

    public static void logOut() {
        //client.Logout();
        email = null;
        fullName = null;

        Fragment_BarraMenu.UpdateAccountButton();
        //MyErro.getAppContext().startActivity(Fragment_BarraMenu.IntAccount);

        if (accessTokenTracker != null)
            accessTokenTracker.stopTracking();

        try {
            Auth.GoogleSignInApi.revokeAccess(mGoogleApiClient);
            Auth.GoogleSignInApi.signOut(mGoogleApiClient);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static boolean dataLogin(Activity c, String mail, String passe) {
        if (mail.isEmpty() || passe.isEmpty()) {
            Toast.makeText(MyErro.getAppContext(), "Por favor, preencha os campos que faltam", Toast.LENGTH_SHORT).show();
            return false;
        }
        else {
            String result = ApiHelper.LogIn(mail, passe);

            try {
                JSONObject user = new JSONObject(result);
                id = user.getString("ID");
                email = user.getString("email");
                fullName = user.getString("name");

                Fragment_BarraMenu.UpdateAccountButton();
                c.startActivity(Fragment_BarraMenu.IntAccount);
                c.finish();

                return true;

            } catch (Exception e) {
               // e.printStackTrace();
                Toast.makeText(MyErro.getAppContext(), result, Toast.LENGTH_LONG).show();
                logOut();
                return false;
            }
        }
    }

    public void GooglePrepare(FragmentActivity c) {
        GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestEmail()
                .build();

        // Build a GoogleApiClient with access to GoogleSignIn.API and the options above.
        mGoogleApiClient = new GoogleApiClient.Builder(c)
                .enableAutoManage(c, this)
                .addApi(Auth.GOOGLE_SIGN_IN_API, gso)
                .build();

        logOut();
    }

    public void GoogleLogin(FragmentActivity c) {
        // Configure sign-in to request the user's ID, email address, and basic profile. ID and
        // basic profile are included in DEFAULT_SIGN_IN.
        try {
            Intent signInIntent = Auth.GoogleSignInApi.getSignInIntent(mGoogleApiClient);
            c.startActivityForResult(signInIntent, GOOGLE_SIGN_IN);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

        if (isLogedIn())
            ApiHelper.LogIn(c, email);
    }

    public static void OnActivityResult(Activity a, int requestCode, int resultCode, Intent data) {
        // GOOGLE+
        if (requestCode == GOOGLE_SIGN_IN) {
            GoogleSignInResult result = Auth.GoogleSignInApi.getSignInResultFromIntent(data);
            try {
                GoogleSignInAccount acct = result.getSignInAccount();
                // Get account information
                fullName = acct.getDisplayName();

                ApiHelper.LogIn(a, acct.getEmail());
            }
            catch (Exception e) {
                logOut();
                e.printStackTrace();
            }
        }
        else {
            try {
                //FACEBOOK
                callbackManager.onActivityResult(requestCode, resultCode, data);
            } catch (Exception e) { }
        }

        if (isLogedIn()) {
            ApiHelper.LogIn(a, email);
        }
    }

    // public static async

    public Activity a;
    public void FacebookLogin(Activity a) {
        FacebookSdk.sdkInitialize(a);
        this.a = a;

        callbackManager = CallbackManager.Factory.create();

        LoginManager.getInstance().registerCallback(callbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                        GraphRequest request = GraphRequest.newMeRequest(loginResult.getAccessToken(), new GraphRequest.GraphJSONObjectCallback() {

                            @Override
                            public void onCompleted(JSONObject object, GraphResponse response) {
                                // Get facebook data from login
                                try {
                                    //email = object.getString("email");
                                    fullName = object.getString("first_name") + " " + object.getString("first_name");
                                    ApiHelper.LogIn(LogInHelper.this.a, object.getString("email"));
                                }
                                catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        });

                        profileTracker = new ProfileTracker() {
                            @Override
                            protected void onCurrentProfileChanged(
                                    Profile oldProfile,
                                    Profile currentProfile) {

                                fullName = currentProfile.getName();

                            }
                        };

                        Bundle parameters = new Bundle();
                        parameters.putString("fields", "id, first_name, last_name, email,gender, birthday, location"); // Parámetros que pedimos a facebook
                        request.setParameters(parameters);
                        request.executeAsync();
                    }

                    @Override
                    public void onCancel() { }

                    @Override
                    public void onError(FacebookException exception) { }
                });

        accessTokenTracker = new AccessTokenTracker() {
            @Override
            protected void onCurrentAccessTokenChanged(
                    AccessToken oldAccessToken,
                    AccessToken currentAccessToken) {
                // Set the access token using
                // currentAccessToken when it's loaded or set.
            }
        };

        // If the access token is available already assign it.
        accessToken = AccessToken.getCurrentAccessToken();

        LoginManager.getInstance().logInWithReadPermissions(a, Arrays.asList("public_profile", "email"));

        if (isLogedIn())
            ApiHelper.LogIn(a, email);
    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        logOut();
    }
}
