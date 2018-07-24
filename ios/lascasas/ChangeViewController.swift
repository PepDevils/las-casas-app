//
//  IniciarViewController.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils on 08/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var bt_cancelar: UIButton!
    @IBOutlet weak var bt_mudar: UIButton!
    
    @IBOutlet weak var txtf_antiga_passe: UITextField!
    @IBOutlet weak var txtf_nova_passe: UITextField!
    @IBOutlet weak var txtf_repita_nova_passe: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bt_cancelar.layer.cornerRadius = 4
        bt_mudar.layer.cornerRadius = 4
        txtf_nova_passe.isSecureTextEntry = true
        txtf_nova_passe.delegate = self
        txtf_antiga_passe.isSecureTextEntry = true
        txtf_antiga_passe.delegate = self
        txtf_repita_nova_passe.isSecureTextEntry = true
        txtf_repita_nova_passe.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.ScrollView.contentSize.height = 500
        bt_cancelar.addTarget(self,action:#selector(pressedCancelar),for:.touchUpInside)
        bt_mudar.addTarget(self,action:#selector(pressedMudar),for:.touchUpInside)
        
        self.ScrollView.contentSize.height = bt_cancelar.frame.origin.y + bt_cancelar.frame.size.height + 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pressedCancelar(_ sender:AnyObject){
        self.view.removeFromSuperview()
    }
    
    func pressedMudar(_ sender:AnyObject){
        
        
        let passeAntiga = txtf_antiga_passe.text! as String
        let passeNova = txtf_nova_passe.text! as String
        let passeRepetir = txtf_repita_nova_passe.text! as String
        
        if(!passeAntiga.isEmpty || !passeNova.isEmpty || !passeRepetir.isEmpty){
            if(passeNova == passeRepetir){
                
                let URL = MyGlobalVariables.baseURL + "change_password&email=\(MyGlobalVariables.client_email)" + "&new=\(passeNova)" + "&old=\(passeAntiga)";
                let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                URLSession.shared.dataTask(with: URLRequest(url: url!), completionHandler: {
                    (data, response, error) in
                    let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                    DispatchQueue.main.async(execute: { () -> Void in
                        if(strData == "Utilizador não encontrado. Por favor, reinicie a sua sessão."){
                            self.AlertContrutor("MUDAR PASSWORD",message: "Utilizador não encontrado.", button: "VOLTAR")
                        }else if(strData == "Palavra-passe errada"){
                            self.AlertContrutor("MUDAR PASSWORD",message: "Antiga palavra passe errada", button: "VOLTAR")
                        }else if(strData == "Palavra passe alterada com susesso"){
                            self.AlertContrutor("MUDAR PASSWORD",message: "Palavra passe alterada com susesso", button: "VOLTAR")
                        }else{
                            self.AlertContrutor("MUDAR PASSWORD",message: "Insucesso", button: "VOLTAR")
                        }
                    })
                }).resume()
            
            }else{
                AlertContrutor("MUDAR PASSWORD",message: "As passes não são coincidentes", button: "VOLTAR")
            }
        }else{
            AlertContrutor("MUDAR PASSWORD",message: "Tem campos por preencher", button: "VOLTAR")
        }
        
        
    }
    
    func AlertContrutor(_ title:String, message:String, button:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: button, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension String {
    func Encodesha256() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
}
