 //
//  LogIn_ViewController.swift
//  carlo_monteiro_ios
//
//  Created by pepdevils on 05/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Google


class LogIn_ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var Scroll: UIScrollView!
    var viewBlur = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    let baseURL:String = "http://lascasas.pt/XX/app/mobile_api.php?func="
    var profile_name:String = ""
    var profile_email:String = ""
    var profile_photo:String = ""
    var profile_password:String = ""
    var profile_contacto:String = ""
    
    var txt_name:UITextField = UITextField()
    var txt_email:UITextField = UITextField()
    var bt_esqueceu:UIButton = UIButton()
    var bt_iniciar:UIButton = UIButton()
    var bt_registar:UIButton = UIButton()
    
    //VIEWS Y AXIS
    let txt_name_y:CGFloat = -100
    let txt_email_y:CGFloat = -150
    let bt_esqueceu_y:CGFloat = -65
    let bt_iniciar_y:CGFloat = -20
    let bt_registar_y:CGFloat = 30
    let bt_facebook_y:CGFloat = 100
    let bt_google_y:CGFloat = 150
    
    var width_for_views:CGFloat = 200
    
    let Red_Carlo:UIColor = UIColor(red: 166/255, green: 29/255, blue: 40/255, alpha: 1)
    let popView = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
   
    @IBOutlet weak var LogInView: UIView!
    
    //BUTTON FACEBOOK
//    let LoginButtonFacebook:FBSDKLoginButton = {
//        let buttom = FBSDKLoginButton()
//        buttom.readPermissions = ["public_profile","email","user_friends"]
//        buttom.setTitle("Iniciar Sessao", for: .normal)
//        return buttom
//        
//    }()
    
    //BUTTON GOOGLE
//    let GoogleLoginButton: GIDSignInButton = {
//        let buttom = GIDSignInButton()
//        return buttom
//    }()
    
    override func viewWillAppear(_ animated: Bool) {
        Scroll.contentSize.height = 500
        MyGlobalVariables.isLoginInAppear = true
        if(MyGlobalVariables.isLoginIn){
            LogInView.isHidden = true
            PersonalAreaView.isHidden = false
        }
        else
        {
            LogInView.isHidden = false
            PersonalAreaView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        popView.view.removeFromSuperview()
        popView_init.view.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewBlur.removeFromSuperview()
        activityIndicator.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        LogIn()
        bt_AlterarPasse.layer.cornerRadius = 4
        bt_Favoritos.layer.cornerRadius = 4
        bt_Like.layer.cornerRadius = 4
        bt_TerminarSessao.layer.cornerRadius = 4
        bt_AboutUs.layer.cornerRadius = 4
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        popView.dismiss(animated: true, completion: nil)
        popView_init.dismiss(animated: true, completion: nil)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        InjectViews()
        
    }
    
    //FACEBOOK
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        MyGlobalVariables.isLoginIn = false
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

//        // let facebook_token = FBSDKAccessToken.currentAccessToken()
//        print( "ERROR: \(error)")
//        if let facebook_token = FBSDKAccessToken.current(){
//            print("print (\(facebook_token))")
//            let string = result.declinedPermissions
//            let string1 = facebook_token.declinedPermissions
//            print("AccessToken Result: \(string) - AccessToken FacebookToken: \(string1)")
//            fetchProfile()
//        }
    }
    let LoginButtonFacebook : UIButton = UIButton(type: .custom)
    let GoogleLoginButton : UIButton = UIButton(type: .custom)
    
    func LogIn () {
        MyGlobalVariables.isLoginInAppear = true
        ButtonStyler(bt_AlterarPasse, isRed: false)
        ButtonStyler(bt_Favoritos, isRed: true)
        ButtonStyler(bt_AboutUs, isRed: false)
        ButtonStyler(bt_Like, isRed: false)
        ButtonStyler(bt_TerminarSessao, isRed: false)
        self.ImageFavoritos.transform = CGAffineTransform(rotationAngle: (-90.0 * CGFloat(M_PI)) / 180.0)
        bt_AlterarPasse.addTarget(self,action:#selector(AlterarPasse),for:.touchUpInside)
        bt_Favoritos.addTarget(self,action:#selector(EntrarFavoritos),for:.touchUpInside)
        bt_AboutUs.addTarget(self,action:#selector(EntrarSobreNos),for:.touchUpInside)
        bt_Like.addTarget(self,action:#selector(AbrirGostouDaApp),for:.touchUpInside)
        bt_TerminarSessao.addTarget(self,action:#selector(TerminarSessao),for:.touchUpInside)
        
        //if(!MyGlobalVariables.isLoginIn){
        LogInView.isHidden = false
        PersonalAreaView.isHidden = true
        
        LoginButtonFacebook.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        LoginButtonFacebook.layer.cornerRadius = 4
        LoginButtonFacebook.frame = CGRect(x: 0, y: 50, width: 300, height: 40)
        LoginButtonFacebook.center = self.view.center
        LoginButtonFacebook.center.y = self.view.center.y + 50
        LoginButtonFacebook.setTitle("iniciar SESSÃO COM O FACEBOOK".uppercased(), for: .normal)
        LoginButtonFacebook.titleLabel?.font = UIFont(name: "CooperHewitt-Semibold", size: 15)
        LoginButtonFacebook.contentVerticalAlignment = .fill
        LoginButtonFacebook.setImage(UIImage(named: "social_facebook"), for: .normal)
        LoginButtonFacebook.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        LoginButtonFacebook.addTarget(self, action: #selector(LogIn_ViewController.loginButtonClicked), for: .touchUpInside)
        self.Scroll.addSubview(LoginButtonFacebook)
//        LoginButtonFacebook.center = view.center
//        LoginButtonFacebook.delegate = self
        
        
        //GOOGLE PLUS
        var google_error: NSError?
        GGLContext.sharedInstance().configureWithError(&google_error)
        
        if google_error != nil{
            MyGlobalVariables.isLoginIn = false
            MyGlobalVariables.logByApi = false
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        GoogleLoginButton.backgroundColor = UIColor(red: 211/255, green: 72/255, blue: 54/255, alpha: 1)
        GoogleLoginButton.layer.cornerRadius = 4
        GoogleLoginButton.frame = CGRect(x: 0, y: 50, width: 300, height: 40)
        GoogleLoginButton.center = self.view.center
        GoogleLoginButton.center.y = self.view.center.y + 50
        GoogleLoginButton.setTitle("iniciar sessão com o google+".uppercased(), for: .normal)
        GoogleLoginButton.titleLabel?.font = UIFont(name: "CooperHewitt-Semibold", size: 15)
        GoogleLoginButton.contentVerticalAlignment = .fill
        GoogleLoginButton.setImage(UIImage(named: "social_google"), for: .normal)
        GoogleLoginButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -10, bottom: 5, right: 0)
        GoogleLoginButton.addTarget(self, action: #selector(LogIn_ViewController.loginButtonClickedGoogle), for: .touchUpInside)
        self.Scroll.addSubview(GoogleLoginButton)
        
//        self.Scroll.addSubview(GoogleLoginButton)
//        
//        GoogleLoginButton.style = GIDSignInButtonStyle.wide
//        GoogleLoginButton.center = view.center
        
        //TEXTFIELD NAME
        txt_name.placeholder = "Password"
        txt_name.font = UIFont.systemFont(ofSize: 15)
        txt_name.borderStyle = UITextBorderStyle.roundedRect
        txt_name.autocorrectionType = UITextAutocorrectionType.no
        txt_name.isSecureTextEntry = true
        txt_name.keyboardType = UIKeyboardType.default
        txt_name.clearButtonMode = UITextFieldViewMode.whileEditing;
        txt_name.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        txt_name.delegate = self
        self.Scroll.addSubview(txt_name)
        
        //TEXTFIELD EMAIL
        txt_email.placeholder = "Email/Username"
        txt_email.font = UIFont.systemFont(ofSize: 15)
        txt_email.borderStyle = UITextBorderStyle.roundedRect
        txt_email.autocorrectionType = UITextAutocorrectionType.no
        txt_email.autocapitalizationType = UITextAutocapitalizationType.none
        txt_email.keyboardType = UIKeyboardType.default
        txt_email.clearButtonMode = UITextFieldViewMode.whileEditing;
        txt_email.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        txt_email.delegate = self
        self.Scroll.addSubview(txt_email)
        
        //BUTTON ESQUECEU A PALAVRA PASSE?
        bt_esqueceu.setTitle("esqueceu-se da palavra passe?", for: UIControlState())
        bt_esqueceu.titleLabel?.font = UIFont(name: "CooperHewitt-Semibold", size: 12)
        bt_esqueceu.setTitleColor(Red_Carlo, for: UIControlState())
        self.Scroll.addSubview(bt_esqueceu)
        bt_esqueceu.addTarget(self, action: #selector(LogIn_ViewController.pressedEsqueceuPalavraPass(_:)), for: .touchUpInside)
        
        //BUTTON INICIAR SESSÃO
        bt_iniciar.setTitle("INICIAR SESSÃO", for: UIControlState())
        bt_iniciar.setTitleColor(UIColor.white, for: UIControlState())
        bt_iniciar.titleLabel?.font = UIFont(name: "CooperHewitt-Semibold", size: 15)
        bt_iniciar.layer.cornerRadius = 4
        bt_iniciar.contentVerticalAlignment = .fill
        bt_iniciar.backgroundColor = Red_Carlo
        self.Scroll.addSubview(bt_iniciar)
        bt_iniciar.addTarget(self, action: #selector(LogIn_ViewController.pressedIniciarSessão(_:)), for: .touchUpInside)
        
        //BUTTON REGISTE-SE
        bt_registar.setTitle("REGISTE-SE", for: UIControlState())
        bt_registar.setTitleColor(UIColor.white, for: UIControlState())
        bt_registar.titleLabel?.font = UIFont(name: "CooperHewitt-Semibold", size: 15)
        bt_registar.layer.cornerRadius = 4
        bt_registar.contentVerticalAlignment = .fill
        bt_registar.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        self.Scroll.addSubview(bt_registar)
        bt_registar.addTarget(self, action: #selector(LogIn_ViewController.pressedRegistar(_:)), for: .touchUpInside)
        
        InjectViews()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func loginButtonClicked()
    {
        let buttom = FBSDKLoginManager()
        buttom.logIn(withReadPermissions: ["public_profile","email","user_friends"], from: self, handler: { (result, error) -> Void in
            
            if error == nil
            {
                self.fetchProfile()
            }
        })
    }
    
    func loginButtonClickedGoogle()
    {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func fetchProfile(){
     
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        DispatchQueue.main.async(execute: { () -> Void in
            FBSDKGraphRequest(graphPath: "me", parameters: parameters, httpMethod: "GET").start { (connection, result, error) in
                MyGlobalVariables.isLoginIn = true
                MyGlobalVariables.logByApi = false
                if error != nil {
                    MyGlobalVariables.isLoginIn = false
                    return
                }
                
                let result1 = result as? NSDictionary
                let First = result1?["first_name"] as? String
                let Last = result1?["last_name"] as? String
                let Email = result1?["email"] as? String
                
                if let first_name = First, let last_name = Last{
                    self.profile_name = "\(first_name) \(last_name)"
                }
                
                if let email = Email {
                    self.profile_email = email
                }
                
                if let picture = result1?["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url =  data["url"] as? String{
                    self.profile_photo = url
                }
                
                MyGlobalVariables.client_name = self.profile_name
                MyGlobalVariables.client_email = self.profile_email
                MyGlobalVariables.client_password = self.profile_password
                
                self.LogInView.isHidden = true
                self.PersonalAreaView.isHidden = false
                self.RegisterUser(MyGlobalVariables.client_email, senha: "null", user: MyGlobalVariables.client_name)
                self.tabBarController?.tabBar.items?[3].selectedImage = UIImage(named: "button_session")
                self.tabBarController?.tabBar.items?[3].image = UIImage(named: "button_session")
            }
        })
    }
    
    override func viewWillLayoutSubviews() {
        if MyGlobalVariables.isLoginIn {
            LogInView.isHidden = true
            PersonalAreaView.isHidden = false
            self.tabBarController?.tabBar.items?[3].selectedImage = UIImage(named: "button_session")
            self.tabBarController?.tabBar.items?[3].image = UIImage(named: "button_session")
        }
        else
        {
            LogInView.isHidden = false
            PersonalAreaView.isHidden = true
        }
    }
    
    override func setNeedsFocusUpdate() {
        if MyGlobalVariables.isLoginIn {
            LogInView.isHidden = true
            PersonalAreaView.isHidden = false
        }
        else
        {
            LogInView.isHidden = false
            PersonalAreaView.isHidden = true
        }
    }
    
    //GOOGLE PLUS
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            
            MyGlobalVariables.isLoginIn = true
            
            let userId = user.userID                  
            let idToken = user.authentication.idToken
            
            print(userId!)
            print(idToken!)
            
            
            if let email = user.profile.email  {
                self.profile_email = email
            }
            
            if let name =  user.profile.name  {
                self.profile_name = name
            }
            
            if let picture = user.profile.imageURL(withDimension: 150) {
                self.profile_photo = picture.absoluteString as String
            }
            
            MyGlobalVariables.logByApi = false
            MyGlobalVariables.client_name = self.profile_name
            MyGlobalVariables.client_email = self.profile_email
            MyGlobalVariables.client_password = self.profile_password
            
            self.LogInView.isHidden = true
            self.PersonalAreaView.isHidden = false
            self.tabBarController?.tabBar.items?[3].selectedImage = UIImage(named: "button_session")
            self.tabBarController?.tabBar.items?[3].image = UIImage(named: "button_session")
            self.RegisterUser(MyGlobalVariables.client_email, senha: "null", user: MyGlobalVariables.client_name)
            
        } else {
            MyGlobalVariables.isLoginIn = false
            return
        }
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
        MyGlobalVariables.isLoginIn = false
    }
    
    func AjustView_UITextField(_ uiTextField: UITextField, width:CGFloat, height:CGFloat, y_axis:CGFloat){
    
        uiTextField.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: uiTextField, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        
        let heightConstraint = NSLayoutConstraint(item: uiTextField, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        
        let xConstraint = NSLayoutConstraint(item: uiTextField, attribute: .centerX, relatedBy: .equal, toItem: self.Scroll, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: uiTextField, attribute: .centerY, relatedBy: .equal, toItem: self.Scroll, attribute: .centerY, multiplier: 1, constant: y_axis)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
    
    
    }
    
    func AjustView_UIButton(_ uiButton: UIButton, width:CGFloat, height:CGFloat, y_axis:CGFloat,x_axis:CGFloat){
        
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: uiButton, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        
        let heightConstraint = NSLayoutConstraint(item: uiButton, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        
        let xConstraint = NSLayoutConstraint(item: uiButton, attribute: .centerX, relatedBy: .equal, toItem: self.Scroll, attribute: .centerX, multiplier: 1, constant: x_axis)
        
        let yConstraint = NSLayoutConstraint(item: uiButton, attribute: .centerY, relatedBy: .equal, toItem: self.Scroll, attribute: .centerY, multiplier: 1, constant: y_axis)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
    }
    
    func InjectViews(){
        
        //LARGURA DO ECRÃ
        let bounds = UIScreen.main.bounds
        let width_device = bounds.size.width
        width_for_views = width_device - 8;
        
        //FACEBOOK
        LoginButtonFacebook.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: LoginButtonFacebook, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width_for_views)
        
        let heightConstraint = NSLayoutConstraint(item: LoginButtonFacebook, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        
        let xConstraint = NSLayoutConstraint(item: LoginButtonFacebook, attribute: .centerX, relatedBy: .equal, toItem: self.Scroll, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: LoginButtonFacebook, attribute: .centerY, relatedBy: .equal, toItem: self.Scroll, attribute: .centerY, multiplier: 1, constant: bt_facebook_y)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
        
        //GOOGLE
        GoogleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraintGL = NSLayoutConstraint(item: GoogleLoginButton, attribute: .width, relatedBy: .equal,
                                                   toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width_for_views)
        
        let heightConstraintGL = NSLayoutConstraint(item: GoogleLoginButton, attribute: .height, relatedBy: .equal,
                                                    toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        
        let xConstraintGL = NSLayoutConstraint(item: GoogleLoginButton, attribute: .centerX, relatedBy: .equal, toItem: self.Scroll, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraintGL = NSLayoutConstraint(item: GoogleLoginButton, attribute: .centerY, relatedBy: .equal, toItem: self.Scroll, attribute: .centerY, multiplier: 1, constant: bt_google_y)
        NSLayoutConstraint.activate([widthConstraintGL, heightConstraintGL, xConstraintGL, yConstraintGL])
        
        //TEXTFIELD NAME
        AjustView_UITextField(txt_name, width: width_for_views, height: 40, y_axis: txt_name_y)
        
        //TEXTFIELD EMAIL
        AjustView_UITextField(txt_email, width: width_for_views, height: 40, y_axis: txt_email_y)
        
        //BUTTON ESQUECEU A PALAVRA PASSE?
        AjustView_UIButton(bt_esqueceu, width: width_for_views, height: 10, y_axis: bt_esqueceu_y, x_axis: 0)
        bt_esqueceu.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        //BUTTON INICIAR SESSÃO
        AjustView_UIButton(bt_iniciar, width: width_for_views, height: 40, y_axis: bt_iniciar_y, x_axis: 0)
        
        //BUTTON REGISTE-SE
        AjustView_UIButton(bt_registar, width: width_for_views, height: 40, y_axis: bt_registar_y, x_axis: 0)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
       return .none
    }
    
    func pressedEsqueceuPalavraPass(_ sender: UIButton!) {
        
        if(self.txt_email.text!.isEmpty || !isValidEmail(self.txt_email.text!)){
            
            let alertController = UIAlertController(title: "MUDAR PASSWORD", message: "Tem de inserir um email válido.", preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "MUDAR PASSWORD", message: "Tem a certeza que pretende mudar a sua password", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Sim", style: .default) { (action) in
                
                let email = self.txt_email.text! as String
                
                let APIlink = "http://lascasas.pt/XX/app/mobile_api.php?func=reset_password&email=" + email
                
                let url = URL(string: "" + APIlink)
                
                URLSession.shared.dataTask(with: URLRequest(url: url!), completionHandler: {
                    (data, response, error) in
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if(strData.contains("Got it!")){
                            self.AlertContrutor("MUDAR PASSWORD", message: "Password mudada com sucesso, verifique o seu email.", button: "Voltar")
                        }
                        else if(strData.contains("Utilizador não encontrado")){
                            self.AlertContrutor("MUDAR PASSWORD", message: "Utilizador não existe.", button: "Voltar")
                        }
                        else if(strData.contains("Email não válido")){
                            self.AlertContrutor("MUDAR PASSWORD", message: "O email inserido não é válido.", button: "Voltar")
                        }
                        else if(strData.contains("Ocorreu um erro de conecção")){
                            self.AlertContrutor("MUDAR PASSWORD", message: "Ocorreu um erro de conexão.", button: "Voltar")
                        }
                    })
                    }).resume()
                
            }
            alertController.addAction(OKAction)
            let CancelAction = UIAlertAction(title: "Não", style: .cancel, handler: nil)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func pressedIniciarSessão(_ sender: UIButton!) {
        if(self.txt_name.text!.isEmpty || self.txt_email.text!.isEmpty){
            let alertController = UIAlertController(title: "INICIAR SESSÃO", message: "Os campos não estão completos", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Voltar", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            let pass = self.txt_name.text! as String
            let email = self.txt_email.text! as String
            self.getClientData(email,pass: pass )
        }
        view.endEditing(true)
    }
    
    func getClientData(_ email:String, pass:String){
        
        //let senha = pass.Encodesha256()
        
        let URL:String = self.baseURL + "get_user_data&emailOrName=\(email)&password=\(pass)";
        
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
    
        URLSession.shared.dataTask(with: URLRequest(url: url!), completionHandler: {
            (data, response, error) in
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            
            DispatchQueue.main.async(execute: { () -> Void in
                if(strData == "Palavra-passe errada"){
                    let alertController = UIAlertController(title: "INICIAR SESSÃO", message: "Password errada, ou email associado a Facebook ou Google+", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Voltar", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }else if strData == "Utilizador não encontrado" {
                    let alertController = UIAlertController(title: "INICIAR SESSÃO", message: "Email/Nome de utilizador não existe na base de dados", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Voltar", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    print("O utilizador foi reconhecido")
                    
                    let dict = (try! JSONSerialization.jsonObject(with: data!, options: [])) as? [String: AnyObject]
                    
                    if let email = dict!["user_email"] as? String
                    {
                        self.profile_email = email
                    }
                    else
                    {
                        self.profile_email = "nil"
                    }
                    
                    if let name = dict!["display_name"] as? String
                    {
                        self.profile_name = name
                    }
                    else
                    {
                        self.profile_name = "nil"
                    }
                    
                    if let pass = dict!["user_pass"] as? String
                    {
                        self.profile_password = pass
                    }
                    else
                    {
                        self.profile_password = "nil"
                    }
                    
                    MyGlobalVariables.isLoginIn = true
                    MyGlobalVariables.logByApi = true
                    MyGlobalVariables.client_name = self.profile_name
                    MyGlobalVariables.client_email = self.profile_email
                    MyGlobalVariables.client_password = self.profile_password
                    self.tabBarController?.tabBar.items?[3].selectedImage = UIImage(named: "button_session")
                    self.tabBarController?.tabBar.items?[3].image = UIImage(named: "button_session")
                    self.LogInView.isHidden = true
                    self.PersonalAreaView.isHidden = false
                }
            })
        }).resume()
    }

    func pressedRegistar(_ sender: UIButton!) {
        view.endEditing(true)
        popView.modalPresentationStyle = UIModalPresentationStyle.popover
        popView.preferredContentSize = CGSize(width: self.view.frame.width-50, height: self.view.frame.height-50)
        popView.view.frame.size.width = self.view.frame.width - 50
        popView.view.frame.size.height = self.view.frame.height - 120
        popView.view.frame.origin.x = self.view.frame.width/2 - popView.view.frame.width/2
        popView.view.frame.origin.y = self.view.frame.height/2 - popView.view.frame.height/2
        popView.view.layer.borderColor = UIColor.darkGray.cgColor
        popView.view.layer.borderWidth = 2
        popView.view.layer.cornerRadius = 10
        let popoverPresentationController = popView.popoverPresentationController
        popoverPresentationController?.sourceView = self.view
        popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        popoverPresentationController?.delegate = self
        self.view.addSubview(popView.view)
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func RegisterUser( _ email:String, senha:String, user: String){
        //let senha = senha.Encodesha256()
        let URL:String = self.baseURL + "register_user&email=\(email)&password=\(senha)&user=\(user)";
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        URLSession.shared.dataTask(with: URLRequest(url: url!), completionHandler: { (data, response, error) in
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            DispatchQueue.main.async(execute: { () -> Void in
                
                if(((strData == "Utilizador já existente" ) )){
   
                }else if(((strData == "Got it!") )){
                    
                    self.profile_email = email
                    self.profile_password = senha
                    self.profile_name = user
                    MyGlobalVariables.client_name = self.profile_name
                    MyGlobalVariables.client_email = self.profile_email
                    MyGlobalVariables.client_password = self.profile_password
                    MyGlobalVariables.isLoginIn = true
                    MyGlobalVariables.logByApi = true
                }
            })
        }).resume()
    }
    
    func AlertContrutor(_ title:String, message:String, button:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: button, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    //AREA PESSOAL
    //AREA PESSOAL
    //AREA PESSOAL
    //AREA PESSOAL
    //AREA PESSOAL
    
    
    let popView_init = ChangeViewController(nibName: "ChangeViewController", bundle: nil)
    var ArrayData:NSMutableArray=[]
    var dict_houses: NSMutableDictionary = [:]
    
    @IBOutlet weak var PersonalAreaView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var bt_AlterarPasse: UIButton!
    @IBOutlet weak var bt_Favoritos: UIButton!
    @IBOutlet weak var bt_Like: UIButton!
    @IBOutlet weak var bt_TerminarSessao: UIButton!
    @IBOutlet weak var bt_AboutUs: UIButton!
    @IBOutlet weak var ImageFavoritos: UIImageView!
    
    func ButtonStyler(_ uibt: UIButton, isRed:Bool){
        
        if (isRed){
            uibt.backgroundColor = UIColor.clear
            uibt.layer.cornerRadius = 0
            uibt.layer.borderWidth = 2
            uibt.layer.borderColor = Red_Carlo.cgColor
        }else{
            uibt.backgroundColor = UIColor.clear
            uibt.layer.cornerRadius = 0
            uibt.layer.borderWidth = 2
            uibt.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    func AlterarPasse(_ sender: AnyObject){
        print("AlterarPasse")
        
        if(MyGlobalVariables.logByApi){
            //CODIGO PARA POR NA ZONA PESSOAL
            self.view.endEditing(true)
            popView_init.modalPresentationStyle = UIModalPresentationStyle.popover
            popView_init.preferredContentSize = CGSize(width: self.view.frame.size.width-50, height: self.view.frame.size.height-50)
            popView_init.view.frame.size.width = self.view.frame.width - 50
            popView_init.view.frame.size.height = self.view.frame.height - 120
            popView_init.view.frame.origin.x = self.view.frame.width/2 - popView_init.view.frame.width/2
            popView_init.view.frame.origin.y = self.view.frame.height/2 - popView_init.view.frame.height/2
            popView_init.view.layer.borderColor = UIColor.darkGray.cgColor
            popView_init.view.layer.borderWidth = 2
            popView_init.view.layer.cornerRadius = 11
            let popoverPresentationController = popView_init.popoverPresentationController
            popoverPresentationController?.sourceView = self.view
            popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
            popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            popoverPresentationController?.delegate = self
            self.view.addSubview(popView_init.view)
        }else{
            let alertController = UIAlertController(title: "ALTERAR PASSE", message: "Só se o log in não for efectuado por Facebook ou Google", preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func EntrarFavoritos(_ sender: AnyObject){
        GetFavourites(email: MyGlobalVariables.client_email)
        MyGlobalVariables.isFromFavorites = true
        MyGlobalVariables.ComeSearchtoResult = true
    }
    
    func EntrarSobreNos(_ sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let uiViewController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "SobreNosController") as! UINavigationController
        self.present(uiViewController, animated: true, completion: nil)
    }
    
    func AbrirGostouDaApp(_ sender: AnyObject){
        let URL = MyGlobalVariables.baseURL + "link_to_app_store";
        let url = Foundation.URL(string: "" + URL)
        var request = URLRequest(url : url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                let res = String(data: data!, encoding: String.Encoding.utf8)
                if (res!.isEqual("")) {
                    
                }else{
                    let u_r_l = Foundation.URL(string: "" + res!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                    let request_ = URLRequest(url: u_r_l)
                    UIApplication.shared.openURL(request_.url!)
                }
            })
        })
        task.resume()
    }
    
    func TerminarSessao(_ sender: AnyObject){
        
        if(MyGlobalVariables.isLoginIn){
            
            let alertController = UIAlertController(title: "JÁ VAI EMBORA?", message: "", preferredStyle: .alert)
            
            let CancelAction = UIAlertAction(title: "VOLTAR", style: .destructive,  handler: { _ in
                
            })
            
            let OkAction = UIAlertAction(title: "ENCERRAR SESSÃO", style: .cancel, handler: { _ in
                if(!MyGlobalVariables.logByApi){
                    FBSDKLoginManager().logOut()
                    GIDSignIn.sharedInstance().signOut()
                }
                self.tabBarController?.tabBar.items?[3].selectedImage = UIImage(named: "button_private")
                self.tabBarController?.tabBar.items?[3].image = UIImage(named: "button_private")
                self.txt_name.text = ""
                self.txt_email.text = ""
                MyGlobalVariables.isLoginIn = false
                MyGlobalVariables.logByApi = false
                self.PersonalAreaView.isHidden = true
                self.LogInView.isHidden = false
            })
            alertController.addAction(CancelAction)
            alertController.addAction(OkAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func GetFavourites(email : String){
        viewBlur = UIView.init(frame: UIScreen.main.bounds)
        viewBlur.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.white
        
        activityIndicator.center = viewBlur.center
        
        viewBlur.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.addSubview(viewBlur)
        let URL = MyGlobalVariables.baseURL + "get_user_favorites2&user_mail=" + email
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest(url : url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: [])) as? [String: AnyObject]
                
                
                if json != nil
                {
                    for i in 0..<json!.count{
                        let nomeC: String = "casa \(i)"
                        let casa = json![nomeC]
                        
                        var id = casa!["ID"] as? String
                        if id == nil || id == "" {
                            id = "Indisponível"
                        }
                        
                        var frontImageID = casa!["frontImageID"] as? String
                        if frontImageID == nil || frontImageID == "" {
                            frontImageID = "Indisponível"
                        }
                        
                        var mls = casa!["MLS"] as? String
                        if mls == nil || mls == "" {
                            mls = "Indisponível"
                        }
                        
                        var status = casa!["status"] as? String
                        if status == nil || status == "" {
                            status = "Indisponível"
                        }
                        
                        var title = casa!["post_title"] as? String
                        if title == nil || title == "" {
                            title = "Indisponível"
                        }
                        
                        var loc = casa!["loc"]! as? String
                        if loc == nil || loc == "" {
                            loc = "Indisponível"
                        }
                        
                        var price = casa!["price"] as? String
                        if price == nil || price == "" {
                            price = "Indisponível"
                        }
                        
                        let myDictObj:NSDictionary = [
                            nomeC as String : ["id": "\(id!)", "frontImageID": "\(frontImageID!)", "iDHouse": "\(mls!)", "status": "\(status!)", "post_title": "\(title!)", "price": "\(price!)", "loc": "\(loc!)"]
                        ]
                        
                        self.ArrayData.add(myDictObj.value(forKey: nomeC)!)
                        self.dict_houses.addEntries(from: myDictObj as [NSObject : AnyObject])
                    }
                    
                    if self.dict_houses.count != 0
                    {
                        self.performSegue(withIdentifier: "segue_Result", sender: self)
                        MyGlobalVariables.ComeFavourites = true
                    }
                } else{
                    self.viewBlur.removeFromSuperview()
                    self.activityIndicator.removeFromSuperview()
                    let alertController = UIAlertController(title: "Favoritos", message: "Ainda não adicionou imóveis aos seus favoritos", preferredStyle: .alert)
                    let CancelAction = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
                    alertController.addAction(CancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        })
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_Result" {
            let destination = segue.destination as! ResultViewController
            destination.dict_segue_from_search = self.dict_houses
            self.dict_houses = [:]
        }
    }
}
