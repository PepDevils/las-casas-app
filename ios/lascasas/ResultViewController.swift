//
//  ResultViewController.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils  on 21/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import Foundation

class ResultViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Lbl_Result: UILabel!
    //http://lascasas.pt/XX/app/mobile_api.php?func=get_image_resized&image_id=1072&width=777&height=444&crop=yes
    var idHouse:String!
    var titleHouse:String!
    var priceHouse:String!
    var idImage: String!
    var idImages: String!
    var dict_segue_from_search : NSDictionary = [:]
    var ArrayData: NSMutableArray = []
    var ArrayImage : [UIImage] = []
    var pagina = 0
    var casasPorPag = 20
    var load = 0
    var AllHouses: Bool = false
    var goHouse : Bool = false
    
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(dict_segue_from_search.count == 0){
            dict_segue_from_search = MyGlobalVariables.AllHouses
            for i in 0..<dict_segue_from_search.count {
                let nomeC: String = "casa \(i)"
                self.ArrayData.add(dict_segue_from_search.value(forKey: nomeC)!)
            }
            Lbl_Result.text = "TODOS OS IMÓVEIS"
        }else{
            for i in 0..<dict_segue_from_search.count {
                let nomeC: String = "casa \(i)"
                self.ArrayData.add(dict_segue_from_search.value(forKey: nomeC)!)
            }
        }
        
        if self.ArrayData.count > 0 {
            for i in 0..<self.ArrayData.count {
                self.ArrayImage.append(self.loadImage(self.startParsingImage((self.ArrayData[i] as AnyObject).value(forKey: "frontImageID") as! String)))
            }
        }
        AllHouses = false
        
        if MyGlobalVariables.AllHousesBool
        {
            AllHouses = true
        }
        
        if MyGlobalVariables.SearchForID
        {
            var style = ToastStyle()
            style.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            style.messageAlignment = .center
            self.view.makeToast("A pesquisa por ID não contempla os restantes parâmetros.", duration: 5.0, position: CGPoint(x: self.view.center.x, y: self.view.center.y + 50), style: style)
            MyGlobalVariables.SearchForID = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if MyGlobalVariables.ComeHouse == true
        {
            let _ = self.navigationController?.popViewController(animated: true)
            MyGlobalVariables.ComeHouse = false
        }
        AllHouses = false
        if MyGlobalVariables.AllHousesBool
        {
            AllHouses = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        AllHouses = false
        if MyGlobalVariables.AllHousesBool
        {
            AllHouses = true
        }
        goHouse = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (!goHouse)
        {
            if tabBarController?.tabBar.items?.count == 5
            {
                tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                tabBarController?.tabBar.items![3].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                tabBarController?.tabBar.items![4].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            }
            else
            {
                tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                tabBarController?.tabBar.items![2].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                tabBarController?.tabBar.items![3].imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                MyGlobalVariables.isFromFavorites = false
            }
        }
        
        if MyGlobalVariables.ComeSearchtoResult == true
        {
            let _ = self.navigationController?.popViewController(animated: true)
            MyGlobalVariables.ComeSearchtoResult = false
            MyGlobalVariables.AllHousesBool = false
            MyGlobalVariables.ComeSearch = false
        }

        AllHouses = false
        MyGlobalVariables.Status = ""
        MyGlobalVariables.tipo = ""
        MyGlobalVariables.Localidade = ""
        MyGlobalVariables.Freguesia = ""
        MyGlobalVariables.PrecoMax = 0
        MyGlobalVariables.PrecoMin = 0
        MyGlobalVariables.Quartos = ""
        MyGlobalVariables.ID = ""
    }
    
    func startParsingImage(_ codigo: String) -> String
    {
        var width = 0
        if Int(UIScreen.main.bounds.width) > 500
        {
            width = 1000
        }
        else
        {
            width = 700
        }
        guard let myURL = URL(string: (MyGlobalVariables.baseURL + "get_image_resized&image_id=" + codigo + "&width=\(width)&height=\(512)&crop=no").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else {
            print("Error: \(MyGlobalVariables.baseImage) doesn't seem to be a valid URL")
            return ""
        }
        do {
            let myHTMLString = try String(contentsOf: myURL)
            print("HTML : \(myHTMLString)")
            return myHTMLString
        } catch let error as NSError {
            print("Error: \(error)")
            return ""
        }
    }
    
    func loadImage(_ imageString: String) -> UIImage{
        let url:URL? = URL(string: imageString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            let data:Data? = try? Data(contentsOf: url!)
            var image = UIImage(named: "example_270x220")
            if data != nil
            {
                image = UIImage(data: data!)
            }
            return image!
        }
        else
        {
            let image = UIImage(named: "example_270x220")
            return image!
        }
    }
    
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            return
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ArrayData.count
    }
    
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.clear.cgColor]
        return layer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCellDestaques! = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCellDestaques
        
        cell.frontImage.image = ArrayImage[indexPath.row]
        
        //titulo
        if let strTitle2 : NSString = (self.ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "post_title") as? NSString {
            cell.lblTitle.text=strTitle2 as String
        }else{
            cell.lblTitle.text="Falhou o carregamento"
        }
        
        if let strTitle6 : NSString = (self.ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "loc") as? NSString {
            cell.Lbl_Location.text = strTitle6 as String
        }else{
            cell.Lbl_Location.text = "Falhou o carregamento"
        }
        
        if cell.Lbl_background_Title.layer.sublayers?.count != nil
        {
            cell.Lbl_background_Title.layer.sublayers?.removeAll()
        }
        
        if UIScreen.main.bounds.size.width > 500
        {
            cell.Lbl_background_Title.bounds.size.width = 800
        }
        cell.Lbl_background_Title.layer.insertSublayer(gradient(frame: cell.Lbl_background_Title.bounds), at: 0)
        cell.Lbl_background_Title.backgroundColor = UIColor.clear
        
        //dar a cor certa á label status
        if let strTitle3 : NSString = (self.ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "status") as? NSString {
            switch strTitle3 {
                
            case "reduced":
                cell.lblStatus.image = UIImage(named:"etiquetas_reservado")
                break
            case "for-sale":
                cell.lblStatus.image = UIImage(named:"etiquetas_disponivel")
                break
            case "sold":
                cell.lblStatus.image = UIImage(named:"etiquetas_vendido")
                break
            case "for-rent":
                cell.lblStatus.image = UIImage(named:"etiquetas_arrendar")
                break
            case "rented":
                cell.lblStatus.image = UIImage(named:"etiquetas_arrendado")
                break
            case "low-price":
                cell.lblStatus.image = UIImage(named: "etiqueta_novo")
            default:
                break
            }
            
            cell.lblStatus.frame.size.width = 50.0
            cell.lblStatus.frame.size.height = 50.0
        }else{
            cell.lblStatus.image = UIImage(named:"etiquetas_disponivel")
        }
        
//        if let strTitle4 : NSString=(self.ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "iDHouse") as? NSString {
//            cell.lblId.text = "ID: " + (strTitle4 as String)
//        }
//        else {
//            cell.lblId.text = "Falhou o carregamento"
//        }
        
        //dar o preço á label price
        if let strTitle5 : NSString=(self.ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "price") as? NSString {
            let price:Int = Int(strTitle5 as String)!
            let str = price.stringFormatedWithSepator
            
            cell.LblPrice.text = str as String
            cell.LblPrice.text?.append(" " as Character)
            cell.LblPrice.text?.append("€" as Character)
        }else{
            cell.LblPrice.text="Falhou o carregamento"
        }
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        self.tableView.rowHeight = width * (11/16)
        
        return cell as TableViewCellDestaques
    }
    func jsonParsingFromURL()
    {
        var URL = MyGlobalVariables.baseURL + "search_ids2&min=\(MyGlobalVariables.PrecoMin)&max=\(MyGlobalVariables.PrecoMax)&page=\(pagina)&by_page=10"
        
        if (MyGlobalVariables.ID != "")
        {
            URL += "&ID_House=\(MyGlobalVariables.ID)"
        }
        else
        {
            if(MyGlobalVariables.Status != ""){
                URL += "&aquisition=\(MyGlobalVariables.Status)"
            }
            if(MyGlobalVariables.tipo != ""){
                URL += "&type=\(MyGlobalVariables.tipo)"
            }
            if(MyGlobalVariables.Quartos != ""){
                URL += "&bedrooms=\(MyGlobalVariables.Quartos)"
            }
            if(MyGlobalVariables.Localidade != ""){
                URL += "&localidade=\(MyGlobalVariables.Localidade)"
            }
            if(MyGlobalVariables.Freguesia != ""){
                URL += "&freguesia=\(MyGlobalVariables.Freguesia)"
            }
        }
        
        let url = Foundation.URL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        var request = URLRequest(url : url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.main.async(execute: {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {

                        if json != nil
                        {
                            for i in 0..<json.count{
                                
                                let nomeC: String = "casa \(i)"
                                
                                let casa = json[nomeC]
                                
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
                                
                                self.ArrayData.add(myDictObj.value(forKey: nomeC)!)
                            }
                            if self.ArrayData.count > 0 {
                                for i in self.load..<self.ArrayData.count {
                                    self.ArrayImage.append(self.loadImage(self.startParsingImage((self.ArrayData[i] as AnyObject).value(forKey: "frontImageID") as! String)))
                                }
                                self.Loader.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                            }
                            
                            if self.ArrayData.count < 10 {
                                self.AllHouses = true
                            }
                        } else{
                            self.Loader.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            self.AllHouses = true
                        }
                    }
                    else
                    {
                        self.AllHouses = true
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
            self.do_table_refresh()
        })
        task.resume()
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = ArrayData.count - 1
        if indexPath.row == lastElement && MyGlobalVariables.ComeFavourites == false {
            if AllHouses == false {
                load += 10
                pagina += 1
                self.view.isUserInteractionEnabled = false
                Loader.startAnimating()
                jsonParsingFromURL()
            }
            else
            {
                Loader.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = self.tableView.indexPathForSelectedRow;
        let strIDHouse : NSString=((ArrayData[(indexPath! as NSIndexPath).row] as AnyObject).value(forKey: "iDHouse") as? NSString)!
        let strIDImages : NSString=((ArrayData[(indexPath! as NSIndexPath).row] as AnyObject).value(forKey: "id") as? NSString)!
        let strIDImage : NSString=((ArrayData[(indexPath! as NSIndexPath).row] as AnyObject).value(forKey: "frontImageID") as? NSString)!
        let currentCell = tableView.cellForRow(at: indexPath!) as! TableViewCellDestaques!
        
        titleHouse = currentCell?.lblTitle.text
        priceHouse = currentCell?.LblPrice.text
        idHouse = strIDHouse as String
        idImages = strIDImages as String
        idImage = strIDImage as String
        MyGlobalVariables.ComeSearchtoResult = false
        if AllHouses
        {
            MyGlobalVariables.AllHousesBool = true
        }
        self.performSegue(withIdentifier: "segueHouse", sender: self)
        goHouse = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHouse"
        {
            let ViewController = segue.destination as! HouseViewController
            ViewController.titleHouse = self.titleHouse
            ViewController.priceHouse = self.priceHouse
            ViewController.idHouse = self.idHouse
            ViewController.idImages = self.idImages
            
        }
    }
}
