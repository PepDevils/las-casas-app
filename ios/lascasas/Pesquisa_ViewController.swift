 //
//  Pesquisa_ViewController.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils on 05/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import Foundation
import UIKit

 class Pesquisa_ViewController : UIViewController, KSTokenViewDelegate {
    
    var viewBlur = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var tab_Pos : CGFloat!

    @IBOutlet weak var token: KSTokenView!
    //let names : Array<String> = []
    
    func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((Array<AnyObject>) -> Void)?) {
        var string = string
        if string.characters.count == 10
        {
            string.characters.removeLast()
        }
        var data: Array<String> = []
        for value: String in ArrayId {
            if value.lowercased().range(of: string.lowercased()) != nil {
                data.append(value)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    func tokenView(_ tokenView: KSTokenView, didAddToken token2: KSToken) {
        view.endEditing(true)
        MyGlobalVariables.IDSelect = true
    }
    func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
        MyGlobalVariables.IDSelect = false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                
                if UIScreen.main.bounds.width > 500
                {
                    if token.editable {
                        
                    }
                    else
                    {
                        self.view.frame.origin.y -= keyboardSize.height
                        tab_Pos = self.tabBarController?.tabBar.frame.origin.y
                        self.tabBarController?.tabBar.frame.origin.y -= keyboardSize.height
                    }
                }
                else
                {
                    self.view.frame.origin.y -= keyboardSize.height
                    tab_Pos = self.tabBarController?.tabBar.frame.origin.y
                    self.tabBarController?.tabBar.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
                self.tabBarController?.tabBar.frame.origin.y = tab_Pos
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PopulateArraySituacao()
        PopulateArrayImovel()
        PopulateArrayQuartos()
        PopulateArrayLocalidade()
        PopulateArrayPrecos()
        PopulateArrayId()
        
        MyGlobalVariables.viewHouse = false
        Bt_situacao.layer.cornerRadius = 4
        Bt_situacao.layer.borderWidth = 1
        Bt_situacao.layer.borderColor = Red_Carlo.cgColor
        
        Bt_Imóvel.layer.cornerRadius = 4
        Bt_Imóvel.layer.borderWidth = 1
        Bt_Imóvel.layer.borderColor = Red_Carlo.cgColor
        
        Bt_quartos.layer.cornerRadius = 4
        Bt_quartos.layer.borderWidth = 1
        Bt_quartos.layer.borderColor = Red_Carlo.cgColor
        
        Bt_Localidade.layer.cornerRadius = 4
        Bt_Localidade.layer.borderWidth = 1
        Bt_Localidade.layer.borderColor = Red_Carlo.cgColor
        
        Bt_Freguesia.layer.cornerRadius = 4
        Bt_Freguesia.layer.borderWidth = 1
        Bt_Freguesia.layer.borderColor = Red_Carlo.cgColor
        
        Bt_PrecoMin.layer.cornerRadius = 4
        Bt_PrecoMin.layer.borderWidth = 1
        Bt_PrecoMin.layer.borderColor = Red_Carlo.cgColor
        
        Bt_PrecoMax.layer.cornerRadius = 4
        Bt_PrecoMax.layer.borderWidth = 1
        Bt_PrecoMax.layer.borderColor = Red_Carlo.cgColor
        
        bt_Pesquisar.layer.cornerRadius = 4
        
        Bt_Limpar.layer.cornerRadius = 4
        token.layer.cornerRadius = 4
        token.layer.borderWidth = 1
        token.layer.borderColor = Red_Carlo.cgColor
        token.delegate = self
        token.font = UIFont.systemFont(ofSize: 13)
        token.promptText = " "
        token.placeholder = "Qualquer"
        token.descriptionText = "ID"
        token.maxTokenLimit = 1
        token.style = .squared
        token.activityIndicatorColor = Red_Carlo
        token.searchResultSize = CGSize(width: token.frame.width, height: 200)
        //token.shouldAddTokenFromTextInput = false
        NotificationCenter.default.addObserver(self, selector: #selector(Pesquisa_ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Pesquisa_ViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        ScrollView.contentSize.height = Bt_Limpar.frame.size.height + Bt_Limpar.frame.origin.y + 8//700
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ScrollView.contentSize.height = Bt_Limpar.frame.size.height + Bt_Limpar.frame.origin.y + 8//700
        ArrayDataSearch.removeAllObjects()
        dict_houses.removeAllObjects()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewBlur.removeFromSuperview()
        activityIndicator.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //SEARCH
    
    let Red_Carlo:UIColor = UIColor(red: 166/255, green: 29/255, blue: 40/255, alpha: 1)
    
    var ArraySituacao = [String]()
    var ArraySituacaoNormal = [String]()
    
    @IBOutlet weak var ScrollView: UIScrollView!
    var ArrayImovel = [String]()
    var ArrayImovelSlug = [String]()
    var ArrayQuartos = [String]()
    var ArrayId = [String]()
    var ArrayLocalidade = [String]()
    var ArrayLocalidadeSlug = [String]()
    var ArrayFreguesia = [String]()
    var ArrayFreguesiaSlug = [String]()
    var array_price_min=[String]()
    var array_price_max=[String]()
    
    var ArrayDataSearch: NSMutableArray = []
    var dict_houses: NSMutableDictionary = [:]
    @IBOutlet weak var Bt_situacao: UIButton!
    @IBOutlet weak var Bt_Imóvel: UIButton!
    @IBOutlet weak var Bt_quartos: UIButton!
    @IBOutlet weak var Bt_Localidade: UIButton!
    @IBOutlet weak var Bt_Freguesia: UIButton!
    @IBOutlet weak var Bt_PrecoMin: UIButton!
    @IBOutlet weak var Bt_PrecoMax: UIButton!
    @IBOutlet weak var bt_Pesquisar: UIButton!
    @IBOutlet weak var Bt_Limpar: UIButton!

    func PopulateArrayId ()
    {
        let URL = MyGlobalVariables.baseURL + "get_all_houses_mls";
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest(url : url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.main.async(execute: {
                print(data!)
                let res = String(data: data!, encoding: String.Encoding.utf8)
                self.ArrayId = (res?.components(separatedBy: ","))!
                self.ArrayId.insert("Qualquer", at: 0)
                self.ArrayId.removeLast()
            })
        })
        task.resume()
    }
    
    @IBAction func Bt_Limpar_Todos(_ sender: Any) {
        
        if Bt_situacao.title(for: .normal) != "Qualquer" || Bt_Imóvel.title(for: .normal) != "Qualquer" || Bt_quartos.title(for: .normal) != "Qualquer" || Bt_Localidade.title(for: .normal) != "Qualquer" || Bt_Freguesia.title(for: .normal) != "Qualquer" || Bt_PrecoMin.title(for: .normal) != "0" || Bt_PrecoMax.title(for: .normal) != "0" || token.tokens()?.count != 0
        {
            Bt_situacao.setTitle("Qualquer", for: .normal)
            Bt_Imóvel.setTitle("Qualquer", for: .normal)
            Bt_quartos.setTitle("Qualquer", for: .normal)
            Bt_Localidade.setTitle("Qualquer", for: .normal)
            Bt_Freguesia.setTitle("Qualquer", for: .normal)
            Bt_PrecoMin.setTitle("0", for: .normal)
            Bt_PrecoMax.setTitle("0", for: .normal)
            token.deleteAllTokens()
            MyGlobalVariables.IDSelect = false
            self.view.endEditing(true)
            var style = ToastStyle()
            style.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            style.messageAlignment = .center
            self.view.makeToast("Todos os campos foram limpos.", duration: 3.0, position: CGPoint(x: self.view.center.x, y: self.view.center.y + 150), style: style)
        }
    }
    
    @IBAction func bt_Situacao(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "SITUAÇÃO", message: "",preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.popoverPresentationController?.sourceView = ScrollView
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        let array_actions:NSMutableArray = []
        for i in 0..<ArraySituacaoNormal.count{
            array_actions.add(UIAlertAction(title: ArraySituacaoNormal[i], style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.Bt_situacao.setTitle(self.ArraySituacaoNormal[i], for: UIControlState())
            }))
        }
        
        for i in 0..<array_actions.count {
            let aux = array_actions[i]
            alertController.addAction(aux as! UIAlertAction)
            
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bt_Imovel(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "TIPO DE IMÓVEL", message: "",preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.popoverPresentationController?.sourceView = ScrollView
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        let array_actions:NSMutableArray = []
        for i in 0..<ArrayImovel.count{
            array_actions.add(UIAlertAction(title: ArrayImovel[i], style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.Bt_Imóvel.setTitle(self.ArrayImovel[i], for: UIControlState())
            }))
        }
        
        for i in 0..<array_actions.count {
            let aux = array_actions[i]
            alertController.addAction(aux as! UIAlertAction)
            
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bt_Quartos(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Nº DE QUARTOS", message: "",preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.popoverPresentationController?.sourceView = ScrollView
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        let array_actions:NSMutableArray = []
        for i in 0..<ArrayQuartos.count{
            array_actions.add(UIAlertAction(title: ArrayQuartos[i], style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.Bt_quartos.setTitle(self.ArrayQuartos[i], for: UIControlState())
            }))
        }
        
        for i in 0..<array_actions.count {
            let aux = array_actions[i]
            alertController.addAction(aux as! UIAlertAction)
            
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bt_Localidade(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "LOCALIDADE", message: "",preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.popoverPresentationController?.sourceView = ScrollView
        alertController.popoverPresentationController?.sourceRect = sender.frame
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        
        let array_actions:NSMutableArray = []
        for i in 0..<ArrayLocalidade.count{
            array_actions.add(UIAlertAction(title: ArrayLocalidade[i], style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.Bt_Localidade.setTitle(self.ArrayLocalidade[i], for: UIControlState())
                self.ArrayFreguesia.removeAll()
                self.Bt_Freguesia.setTitle("Qualquer", for: UIControlState())
            }))
        }
        
        for i in 0..<array_actions.count {
            let aux = array_actions[i]
            alertController.addAction(aux as! UIAlertAction)
            
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bt_Freguesia(_ sender: AnyObject) {
        ArrayFreguesia.removeAll()
        ArrayFreguesiaSlug.removeAll()
        PopulateArrayFreguesia(Bt_Localidade.currentTitle!, sender: sender)
    }
    
    @IBAction func bt_PrecoMin(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "PREÇO MÍNIMO (€)", message: "",preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.popoverPresentationController?.sourceView = ScrollView
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        let array_actions:NSMutableArray = []
        for i in 0..<array_price_min.count{
            array_actions.add(UIAlertAction(title: array_price_min[i], style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.Bt_PrecoMin.setTitle(self.array_price_min[i], for: UIControlState())
            }))
        }
        
        for i in 0..<array_actions.count {
            let aux = array_actions[i]
            alertController.addAction(aux as! UIAlertAction)
            
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bt_PrecoMax(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "PREÇO MÁXIMO (€)", message: "",preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.popoverPresentationController?.sourceView = ScrollView
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        let array_actions:NSMutableArray = []
        for i in 0..<array_price_max.count{
            array_actions.add(UIAlertAction(title: array_price_max[i], style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.Bt_PrecoMax.setTitle(self.array_price_max[i], for: UIControlState())
            }))
        }
        
        for i in 0..<array_actions.count {
            let aux = array_actions[i]
            alertController.addAction(aux as! UIAlertAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bt_Pesquisar(_ sender: AnyObject) {
        
        print(token.text)
        viewBlur = UIView.init(frame: UIScreen.main.bounds)
        viewBlur.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.white
        
        activityIndicator.center = viewBlur.center
        if view.frame.origin.y != 0{
            self.view.endEditing(true)
        }
        viewBlur.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.addSubview(viewBlur)
        
        let pagesIncrement = 0
        let itemsPerPage = 10
        
        let conselho = toSlug(text: Bt_Localidade.currentTitle!)
        var freguesia = toSlug(text: Bt_Freguesia.currentTitle!)
        let tipo = toSlug(text: Bt_Imóvel.currentTitle!)
        var situacao = Bt_situacao.currentTitle!
        var preco_min = Bt_PrecoMin.currentTitle!
        var preco_max = Bt_PrecoMax.currentTitle!
        var quartos = Bt_quartos.currentTitle!
        
        if quartos == "1"
        {
            quartos = "0"
        }
        
        preco_max = preco_max.replacingOccurrences(of: ".", with: "")
        preco_min = preco_min.replacingOccurrences(of: ".", with: "")
        
        let precoMin : Int = Int(preco_min)!
        let precoMax : Int = Int(preco_max)!
        
        if(precoMin > precoMax){
            let alertController = UIAlertController(title: "Pesquisa", message: "Verifique os preços mínimos e máximos", preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            MyGlobalVariables.PrecoMin = precoMin
            MyGlobalVariables.PrecoMax = precoMax
            for i in 0..<ArraySituacao.count
            {
                if situacao == ArraySituacaoNormal[i]
                {
                    situacao = ArraySituacao[i]
                }
            }
            if(token.text != "")
            {
                if(situacao != "qualquer" || tipo != "Qualquer" || quartos != "Qualquer" || conselho != "Qualquer" || freguesia != "Qualquer" || MyGlobalVariables.PrecoMax != 0 || MyGlobalVariables.PrecoMin != 0)
                {
                    MyGlobalVariables.SearchForID = true
                }
                
                MyGlobalVariables.PrecoMin = 0
                MyGlobalVariables.PrecoMax = 0
            }
            else
            {
                
                if token.tokens()?.first?.title == ""
                {
                    MyGlobalVariables.PrecoMax = precoMax
                    MyGlobalVariables.PrecoMin = precoMin
                }
                else
                {
                    if token.tokens()?.first?.title != nil
                    {
                        token.text = (token.tokens()?.first?.title)!
                    }
                }
                
            }
            
            var URL = MyGlobalVariables.baseURL + "search_ids2&min=\(MyGlobalVariables.PrecoMin)&max=\(MyGlobalVariables.PrecoMax)&page=\(pagesIncrement)&by_page=\(itemsPerPage)"
            
            if(token.text != "")
            {
                MyGlobalVariables.ID = token.text
                URL += "&ID_House=\(token.text)"
            }
            else
            {
                if(situacao != "qualquer"){
                    MyGlobalVariables.Status = situacao
                    URL += "&aquisition=\(situacao)"
                }
                if(tipo != "Qualquer"){
                    MyGlobalVariables.tipo = tipo
                    URL += "&type=\(tipo)"
                }
                if(quartos != "Qualquer"){
                    MyGlobalVariables.Quartos = quartos
                    URL += "&bedrooms=\(quartos)"
                }
                if(conselho != "Qualquer"){
                    MyGlobalVariables.Localidade = conselho
                    URL += "&localidade=\(conselho)"
                }
                if(freguesia != "Qualquer"){
                    MyGlobalVariables.Freguesia = freguesia
                    URL += "&freguesia=\(freguesia)"
                }
            }
            
            let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            var request = URLRequest(url : url!)
            let session = URLSession.shared
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] /*{*/
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
                            
                            var iDHouse = casa!["MLS"] as? String
                            if iDHouse == nil || iDHouse == "" {
                                iDHouse = "Indisponível"
                            }
                            
                            var price = casa!["price"] as? String
                            if price == nil || price == "" {
                                price = "Indisponível"
                            }
                            
                            var status = casa!["status"]! as? String
                            if status == nil || status == "" {
                                status = "Indisponível"
                            }
                            
                            var loc = casa!["loc"]! as? String
                            if loc == nil || loc == "" {
                                loc = "Indisponível"
                            }
                            
                            var post_title = casa!["post_title"] as? String
                            if post_title == nil || post_title == "" {
                                post_title = "Indisponível"
                            }
                            
                            let myDictObj:NSMutableDictionary = [nomeC : ["id": "\(id!)", "frontImageID": "\(frontImageID!)", "iDHouse": "\(iDHouse!)", "status": "\(status!)", "post_title": "\(post_title!)", "price": "\(price!)", "loc": "\(loc!)"]]
                            
                            self.ArrayDataSearch.add(myDictObj)
                            self.dict_houses.addEntries(from: myDictObj as [NSObject : AnyObject])
                        }
                        if self.dict_houses.count != 0
                        {
                            MyGlobalVariables.ComeSearchtoResult = true
                            MyGlobalVariables.ComeSearch = true
                            MyGlobalVariables.ComeHouse = false
                            self.performSegue(withIdentifier: "segueResult", sender: self)
                        }
                    } else{
                        
                        var newURL = URL.components(separatedBy: "&freguesia=")[0]
                        
                        if(freguesia != "Qualquer"){
                            
                            for i in 0..<self.ArrayFreguesia.count
                            {
                                if self.ArrayFreguesia[i] == freguesia
                                {
                                    freguesia = self.toSlug(text: freguesia)
                                }
                            }
                            MyGlobalVariables.Freguesia = freguesia
                            newURL += "&freguesia=\(freguesia)"
                        }
                        
                        
                        let newurl = Foundation.URL(string: "" + newURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                        var request = URLRequest(url : newurl!)
                        let session = URLSession.shared
                        request.httpMethod = "GET"
                        
                        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                            
                            DispatchQueue.main.async(execute: {
                                
                                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] //{
                                
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
                                        
                                        var iDHouse = casa!["MLS"] as? String
                                        if iDHouse == nil || iDHouse == "" {
                                            iDHouse = "Indisponível"
                                        }
                                        
                                        var price = casa!["price"] as? String
                                        if price == nil || price == "" {
                                            price = "Indisponível"
                                        }
                                        
                                        var status = casa!["status"]! as? String
                                        if status == nil || status == "" {
                                            status = "Indisponível"
                                        }
                                        
                                        var loc = casa!["loc"]! as? String
                                        if loc == nil || loc == "" {
                                            loc = "Indisponível"
                                        }
                                        
                                        var post_title = casa!["post_title"] as? String
                                        if post_title == nil || post_title == "" {
                                            post_title = "Indisponível"
                                        }
                                        
                                        let myDictObj:NSMutableDictionary = [nomeC : ["id": "\(id!)", "frontImageID": "\(frontImageID!)", "iDHouse": "\(iDHouse!)", "status": "\(status!)", "post_title": "\(post_title!)", "price": "\(price!)", "loc": "\(loc!)"]]
                                        
                                        self.ArrayDataSearch.add(myDictObj)
                                        self.dict_houses.addEntries(from: myDictObj as [NSObject : AnyObject])
                                    }
                                    if self.dict_houses.count != 0
                                    {
                                        MyGlobalVariables.ComeSearchtoResult = true
                                        MyGlobalVariables.ComeSearch = true
                                        MyGlobalVariables.ComeHouse = false
                                        self.performSegue(withIdentifier: "segueResult", sender: self)
                                    }
                                } else{
                                    self.viewBlur.removeFromSuperview()
                                    self.activityIndicator.removeFromSuperview()
                                    let alertController = UIAlertController(title: "Pesquisa", message: "A pesquisa não retornou imóveis", preferredStyle: .alert)
                                    let CancelAction = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
                                    alertController.addAction(CancelAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                
                            })
                        })
                        task.resume()
                    }
                })
            })
            task.resume()
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueResult"
        {
            let navBar = segue.destination as! ResultViewController
            navBar.dict_segue_from_search = self.dict_houses
        }
    }
    func PopulateArraySituacao ()
    {
        let URL = MyGlobalVariables.baseURL + "get_items_state";
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest(url : url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.main.async(execute: {
                let res = String(data: data!, encoding: String.Encoding.utf8)
                self.ArraySituacao = (res?.components(separatedBy: ","))!
                self.ArraySituacao.insert("qualquer", at: 0)
                let index = self.ArraySituacao.index(of: "")
                self.ArraySituacao.remove(at: index!)
                self.ArraySituacaoNormal = self.ArraySituacao
                for i in 0..<self.ArraySituacaoNormal.count {
                    
                    switch (self.ArraySituacao[i]) {
                    case "qualquer":
                        self.ArraySituacaoNormal[i] = "Qualquer";
                        break;
                    case "sold":
                        self.ArraySituacaoNormal[i] = "Vendido";
                        break;
                    case "reduced":
                        self.ArraySituacaoNormal[i] = "Reservado";
                        break;
                    case "for-sale":
                        self.ArraySituacaoNormal[i] = "Disponível";
                        break;
                    case "low-price":
                        self.ArraySituacaoNormal[i] = "Novo Preço";
                        break;
                    case "for-rent":
                        self.ArraySituacaoNormal[i] = "Arrendar";
                        break;
                    default:
                        self.ArraySituacaoNormal[i] = self.ArraySituacaoNormal[i];
                        break;
                    }
                }
            })
        })
        task.resume()
    }
    
    func PopulateArrayImovel ()
    {
        let URL = MyGlobalVariables.baseURL + "get_items_type";
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest(url : url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.main.async(execute: {
                do
                {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                        let dict : NSDictionary = json as NSDictionary
                        //let aux_dict = Array(dict.allValues)
                        self.ArrayImovel.append("Qualquer")
                        self.ArrayImovelSlug.append("qualquer")
                        var array : [String] = []
                        var arraySlug : [String] = []
                        let auxDict : NSMutableArray = []
                        for i in 0..<dict.count{
                            auxDict.addObjects(from: Array(arrayLiteral: dict.value(forKey: "item\(i)")!))
                            let aux = auxDict[i]
                            let auxName = (aux as AnyObject).value(forKey: "name")!
                            let auxSlug = (aux as AnyObject).value(forKey: "slug")!
                            
                            arraySlug.append(auxSlug as! String)
                            arraySlug = arraySlug.sorted {$0 < $1}
                            
                            array.append(auxName as! String)
                            array = array.sorted {$0 < $1}
                        }
                        self.ArrayImovel.append(contentsOf: array)
                        self.ArrayImovelSlug.append(contentsOf: arraySlug)
                    }
                } catch _ as NSError {
                    let alertController = UIAlertController(title: "Conexão internet", message: "Não é possível estabelecer conexão.", preferredStyle: .alert)
                    let CancelAction = UIAlertAction(title: "Volte a tentar mais tarde", style: .cancel,  handler: { _ in
                        exit(0)
                    })
                    alertController.addAction(CancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        })
        task.resume()
        
    }
    
    func PopulateArrayQuartos ()
    {
        let URL = MyGlobalVariables.baseURL + "get_items_bedrooms";
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest(url : url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.main.async(execute: {
                print(data!)
                let res = String(data: data!, encoding: String.Encoding.utf8)
                self.ArrayQuartos = (res?.components(separatedBy: ","))!
                self.ArrayQuartos.insert("Qualquer", at: 0)
                self.ArrayQuartos.removeLast()
            })
        })
        task.resume()
    }
    
    func PopulateArrayLocalidade ()
    {
        let URL = MyGlobalVariables.baseURL + "get_items_localidade"
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest(url : url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.main.async(execute: {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                        var array : [String] = []
                        var arraySlug : [String] = []
                        let dict_aux : NSDictionary = json as NSDictionary
                        let array_aux : NSMutableArray = []
                        self.ArrayLocalidade.append("Qualquer")
                        self.ArrayLocalidadeSlug.append("qualquer")
                        for i in 0..<dict_aux.count{
                            array_aux.addObjects(from: Array(arrayLiteral: dict_aux.value(forKey: "item\(i)")!))
                            let aux = array_aux[i]
                            let auxName = (aux as AnyObject).value(forKey: "name")!
                            let auxSlug = (aux as AnyObject).value(forKey: "slug")!
                            arraySlug.append(auxSlug as! String)
                            arraySlug = arraySlug.sorted {$0 < $1}
                            array.append(auxName as! String)
                            array = array.sorted {$0 < $1}
                        }
                        self.ArrayLocalidade.append(contentsOf: array)
                        self.ArrayLocalidadeSlug.append(contentsOf: arraySlug)
                    }
                } catch _ as NSError {
                    let alertController = UIAlertController(title: "Conexão internet", message: "Não é possível estabelecer conexão.", preferredStyle: .alert)
                    let CancelAction = UIAlertAction(title: "Volte a tentar mais tarde", style: .cancel,  handler: { _ in
                        exit(0)
                    })
                    alertController.addAction(CancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        })
        
        task.resume()
        
    }
    
    func PopulateArrayFreguesia (_ concelho:String , sender:AnyObject)
    {
        var conselho = "qualquer"
        if(concelho == "Qualquer"){
            self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
        }else{
            
            for i in 0..<ArrayLocalidade.count
            {
                if concelho == ArrayLocalidade[i]
                {
                    conselho = ArrayLocalidadeSlug[i]
                }
                
            }
            if conselho == "qualquer"
            {
                self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
            }
            else
            {
                let URL = MyGlobalVariables.baseURL + "get_items_freguesia&localidade=\(conselho)";
                let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                var request = URLRequest(url : url!)
                let session = URLSession.shared
                request.httpMethod = "GET"
                
                let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                                
                                if json == nil
                                {
                                    self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
                                }
                                else
                                {
                                    var array : [String] = []
                                    var arraySlug : [String] = []
                                    let dict : NSDictionary = json as NSDictionary
                                    
                                    if(dict.count == 0){
                                        self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
                                    }
                                    else{
                                        let array_aux :NSMutableArray = []
                                        
                                        self.ArrayFreguesia.append("Qualquer")
                                        self.ArrayFreguesiaSlug.append("qualquer")
                                        for i in 0..<dict.count{
                                            array_aux.addObjects(from: Array(arrayLiteral: dict.value(forKey: "item\(i)")!))
                                            let aux = array_aux[i]
                                            var auxSlug = (aux as AnyObject).value(forKey: "slug")!
                                            var auxName = (aux as AnyObject).value(forKey: "name")!
                                            
                                            if((auxName as! NSObject).isEqual(0)){
                                                auxName = "null"
                                                break
                                            }
                                            
                                            if((auxSlug as! NSObject).isEqual(0)){
                                                auxSlug = "null"
                                                break
                                            }
                                            
                                            array.append(auxName as! String)
                                            array = array.sorted {$0 < $1}
                                            
                                            arraySlug.append(auxSlug as! String)
                                            arraySlug = arraySlug.sorted {$0 < $1}
                                        }
                                        self.ArrayFreguesia.append(contentsOf: array)
                                        self.ArrayFreguesiaSlug.append(contentsOf: arraySlug)
                                        
                                        if( self.ArrayFreguesia.count == 0){
                                            self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
                                            
                                        }else{
                                            
                                            let alertController = UIAlertController(title: "FREGUESIAS", message: "Freguesias de \(self.Bt_Localidade.currentTitle!)",preferredStyle: UIAlertControllerStyle.actionSheet)
                                            alertController.popoverPresentationController?.sourceView = self.ScrollView
                                            alertController.popoverPresentationController?.sourceRect = sender.frame
                                            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {
                                                (alertAction: UIAlertAction!) in
                                                alertController.dismiss(animated: true, completion: nil)
                                            }))
                                            
                                            let array_actions:NSMutableArray = []
                                            for i in 0..<self.ArrayFreguesia.count{
                                                array_actions.add(UIAlertAction(title: self.ArrayFreguesia[i], style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                                                    self.Bt_Freguesia.setTitle(self.ArrayFreguesia[i], for: UIControlState())
                                                }))
                                            }
                                            
                                            for i in 0..<array_actions.count {
                                                let aux = array_actions[i]
                                                alertController.addAction(aux as! UIAlertAction)
                                            }
                                            
                                            self.present(alertController, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }catch _ as NSError {
                            
                            let URL = MyGlobalVariables.baseURL + "get_items_freguesia&localidade=\(concelho)";
                            let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                            var request = URLRequest(url : url!)
                            let session = URLSession.shared
                            request.httpMethod = "GET"
                            
                            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                                
                                DispatchQueue.main.async(execute: {
                                    do {
                                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                                            
                                            if json == nil
                                            {
                                                self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
                                            }
                                            else
                                            {
                                                var array : [String] = []
                                                var arraySlug : [String] = []
                                                let dict : NSDictionary = json as NSDictionary
                                                
                                                if(dict.count == 0){
                                                    self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
                                                }
                                                else{
                                                    let array_aux :NSMutableArray = []
                                                    
                                                    self.ArrayFreguesia.append("Qualquer")
                                                    self.ArrayFreguesiaSlug.append("qualquer")
                                                    for i in 0..<dict.count{
                                                        array_aux.addObjects(from: Array(arrayLiteral: dict.value(forKey: "item\(i)")!))
                                                        let aux = array_aux[i]
                                                        var auxSlug = (aux as AnyObject).value(forKey: "slug")!
                                                        var auxName = (aux as AnyObject).value(forKey: "name")!
                                                        
                                                        if((auxName as! NSObject).isEqual(0)){
                                                            auxName = "null"
                                                            break
                                                        }
                                                        
                                                        if((auxSlug as! NSObject).isEqual(0)){
                                                            auxSlug = "null"
                                                            break
                                                        }
                                                        
                                                        array.append(auxName as! String)
                                                        array = array.sorted {$0 < $1}
                                                        
                                                        arraySlug.append(auxSlug as! String)
                                                        arraySlug = arraySlug.sorted {$0 < $1}
                                                    }
                                                    self.ArrayFreguesia.append(contentsOf: array)
                                                    self.ArrayFreguesiaSlug.append(contentsOf: arraySlug)
                                                    
                                                    if( self.ArrayFreguesia.count == 0){
                                                        self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
                                                        
                                                    }else{
                                                        
                                                        let alertController = UIAlertController(title: "FREGUESIAS", message: "Freguesias de \(self.Bt_Localidade.currentTitle!)",preferredStyle: UIAlertControllerStyle.actionSheet)
                                                        alertController.popoverPresentationController?.sourceView = self.ScrollView
                                                        alertController.popoverPresentationController?.sourceRect = sender.frame
                                                        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {
                                                            (alertAction: UIAlertAction!) in
                                                            alertController.dismiss(animated: true, completion: nil)
                                                        }))
                                                        
                                                        let array_actions:NSMutableArray = []
                                                        for i in 0..<self.ArrayFreguesia.count{
                                                            array_actions.add(UIAlertAction(title: self.ArrayFreguesia[i], style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                                                                self.Bt_Freguesia.setTitle(self.ArrayFreguesia[i], for: UIControlState())
                                                            }))
                                                        }
                                                        
                                                        for i in 0..<array_actions.count {
                                                            let aux = array_actions[i]
                                                            alertController.addAction(aux as! UIAlertAction)
                                                        }
                                                        
                                                        self.present(alertController, animated: true, completion: nil)
                                                    }
                                                }
                                            }
                                        }
                                    }catch _ as NSError {
                                        self.Bt_Freguesia.setTitle("Sem freguesia", for: UIControlState())
                                    }
                                })
                            })
                            task.resume()
                        }
                    })
                })
                task.resume()
            }
        }
    }
    
    func PopulateArrayPrecos ()
    {
        self.array_price_min = ["0","25.000","50.000","75.000","100.000","125.000","150.000","175.000","200.000","250.000","300.000","350.000","400.000","450.000","500.000","600.000","700.000","800.000","900.000","1.000.000"]
        
        self.array_price_max = ["0","25.000","50.000","75.000","100.000","125.000","150.000","175.000","200.000","250.000","300.000","350.000","400.000","450.000","500.000","600.000","700.000","800.000","900.000","1.000.000"]
    }
    
    func toSlug(text:String) -> String {
        
        var stext = text.replacingOccurrences(of: "ğ", with: "g", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ü", with: "u", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "é", with: "e", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "è", with: "e", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ş", with: "s", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ç", with: "c", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ö", with: "o", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ó", with: "o", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ò", with: "o", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ô", with: "o", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "õ", with: "o", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ı", with: "i", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "í", with: "i", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ì", with: "i", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "â", with: "a", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ã", with: "a", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "á", with: "a", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "à", with: "a", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "û", with: "u", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ú", with: "u", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ù", with: "u", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "ê", with: "e", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "î", with: "i", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "Ğ", with: "g", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "Ü", with: "u", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "Ş", with: "s", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "Ç", with: "c", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "Ö", with: "o", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "İ", with: "i", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.replacingOccurrences(of: "î", with: "i", options: NSString.CompareOptions.literal, range: nil)
        stext = stext.trimmingCharacters(in: CharacterSet.whitespaces)
        return stext
    }
}
