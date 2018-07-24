//
//  RegisterViewController.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils on 07/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let baseURL = "http://lascasas.pt/XX/app/mobile_api.php?func="
    
    var profile_email: String = ""
    var profile_name: String = ""
    var profile_password: String = ""
    var profile_user: String = ""
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textSenha: UITextField!
    @IBOutlet weak var textSenhaRepetir: UITextField!
    @IBOutlet weak var textUser: UITextField!
    
    @IBOutlet weak var bt_registar: UIButton!
    @IBOutlet weak var bt_cancelar: UIButton!

    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBAction func pressedCANCELAR(_ sender: AnyObject) {
        self.view.removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func pressedREGISTAR(_ sender: AnyObject) {
        
        if (self.textEmail.text!.isEqual("") || self.textSenha.text!.isEqual("") || self.textSenhaRepetir.text!.isEqual("") || self.textUser.text!.isEqual("")){
            
            let alertController = UIAlertController(title: "Registo", message: "Tem de inserir obrigatoriamente o nome de utilizador, o email e a senha", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Voltar", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            if(self.isValidEmail(self.textEmail.text!)){
                if(self.textSenha.text!.isEqual(self.textSenhaRepetir.text!)){
                    
                    let email = self.textEmail.text
                    let senha = self.textSenha.text
                    let user = self.textUser.text
                    self.RegisterUser(email!, senha:senha!, user: user!)
                    
                }else{
                    
                    let alertController = UIAlertController(title: "Registo", message: "Senhas têm de ser coincidentes", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Voltar", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }else{
                
                let alertController = UIAlertController(title: "Registo", message: "Insira um email válido", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Voltar", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func RegisterUser( _ email:String, senha:String, user:String){
        let  URL:String = self.baseURL + "register_user&email=\(email)&password=\(senha)&user=\(user)";
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        URLSession.shared.dataTask(with: URLRequest(url: url!), completionHandler: { (data, response, error) in
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
            DispatchQueue.main.async(execute: { () -> Void in
                
                if(((strData == "Utilizador já existente" ) )){
                    
                    let alertController = UIAlertController(title: "Registo", message: "Email já existe na base de dados", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Voltar", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
  
                }else if(((strData == "Got it!") )){
                    
                    self.profile_email = email
                    self.profile_password = senha
                    self.profile_user = user
                    self.textEmail.text = ""
                    self.textSenha.text = ""
                    self.textSenhaRepetir.text = ""
                    self.textUser.text = ""
                    MyGlobalVariables.client_name = self.profile_name
                    MyGlobalVariables.client_email = self.profile_email
                    MyGlobalVariables.client_password = self.profile_password
                    MyGlobalVariables.client_user = self.profile_user
                    MyGlobalVariables.isLoginIn = true
                    MyGlobalVariables.logByApi = true
                    self.tabBarController?.tabBar.items?[3].selectedImage = UIImage(named: "button_session")
                    self.tabBarController?.tabBar.items?[3].image = UIImage(named: "button_session")
                    let alertController = UIAlertController(title: "Registo", message: "Registado com sucesso", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Voltar", style: .cancel) { (action) in
                        self.view.removeFromSuperview()
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }else{
                    let alertController = UIAlertController(title: "Registo", message: "Não foi possível efetuar o registo, email não existe", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Voltar", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bt_registar.layer.cornerRadius = 4
        bt_cancelar.layer.cornerRadius = 4
        textSenha.isSecureTextEntry = true
        textSenha.delegate = self
        textEmail.delegate = self
        textSenhaRepetir.isSecureTextEntry = true
        textSenhaRepetir.delegate = self
        self.ScrollView.contentSize.height = 400
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func OpenTabAndPersonalArea(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabMenuController") as! UITabBarController
        tabBarController.selectedIndex = 4
        self.present(tabBarController, animated: true, completion: nil)
    }

}

