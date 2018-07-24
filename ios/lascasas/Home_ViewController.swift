//
//  Home_ViewController.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils on 05/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import Foundation
import UIKit


class Home_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let Red_Carlo:UIColor = UIColor(red: 166/255, green: 29/255, blue: 40/255, alpha: 1)
    
    let baseImage = MyGlobalVariables.baseURL + "get_image_resized&image_id="
    let baseURL_ = MyGlobalVariables.baseURL + "get_destaques"
    let numeroDestaques = 5
    //http://lascasas.pt/XX/app/mobile_api.php?func=get_image_resized&image_id=1072&width=777&height=444&crop=yes
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    var ArrayData:NSMutableArray=[]
    var ArrayImage : [UIImage] = []
    //valores para passar
    var idHouse:String!
    var HouseNotFound : Bool = false
    var titleHouse:String!
    var priceHouse:String!
    var idImage: UIImage!
    var idImages: String!
    var ArrayDataSearch: NSMutableArray = []
    var dict_houses: NSMutableDictionary = [:]
    @IBOutlet weak var View1: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        if (MyGlobalVariables.NotifData != "notif")
        {
            let URL = MyGlobalVariables.baseURL + "search_ids2&min=0&max=0&page=0&by_page=1&ID_House=\(MyGlobalVariables.NotifData)"
            
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
                            
                            var post_title = casa!["post_title"] as? String
                            if post_title == nil || post_title == "" {
                                post_title = "Indisponível"
                            }
                            
                            let myDictObj:NSMutableDictionary = [nomeC : ["id": "\(id!)", "frontImageID": "\(frontImageID!)", "iDHouse": "\(iDHouse!)", "status": "\(status!)", "post_title": "\(post_title!)", "price": "\(price!)"]]
                            
                            self.ArrayDataSearch.add(myDictObj.value(forKey: nomeC)!)
                            self.dict_houses.addEntries(from: myDictObj as [NSObject : AnyObject])
                        }
                        
                        for i in 0 ..< self.ArrayDataSearch.count
                        {
                            if MyGlobalVariables.NotifData == (self.ArrayDataSearch[i] as AnyObject).value(forKey: "iDHouse") as! String
                            {
                                let strIDHouse : NSString = MyGlobalVariables.NotifData as NSString
                                let strIDImages : NSString = (self.ArrayDataSearch[i] as AnyObject).value(forKey: "id") as! NSString
                                
                                self.titleHouse = (self.ArrayDataSearch[i] as AnyObject).value(forKey: "post_title") as! String
                                self.priceHouse = (self.ArrayDataSearch[i] as AnyObject).value(forKey: "price") as! String
                                let price:Int = Int(self.priceHouse as String)!
                                let str = price.stringFormatedWithSepator
                                self.priceHouse = str + " €"
                                self.idHouse = strIDHouse as String
                                self.idImages = strIDImages as String
                                self.HouseNotFound = true
                                self.performSegue(withIdentifier: "segueHouse", sender: self)
                                MyGlobalVariables.ComeDestaques = true
                                MyGlobalVariables.NotifData = "notif"
                                break
                            }
                            else
                            {
                                self.HouseNotFound = false
                            }
                        }
                        
                        if self.HouseNotFound == false
                        {
                            self.jsonParsingFromURL()
                            MyGlobalVariables.NotifData = "notif"
                        }
                    }
                    else
                    {
                        
                    }
                })
            })
            task.resume()
        }
        else
        {
            if MyGlobalVariables.DestaquesLoad == false
            {
                jsonParsingFromURL()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loader.startAnimating()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func jsonParsingFromURL () {
        let url = URL(string: "" + baseURL_)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            self.startParsing(data!)
        })
        task.resume()
    }
    
    func startParsing(_ data :Data){
        DispatchQueue.main.async(execute: {
            do
            {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                    
                    for i in 0..<json.count{
                        let nomeC: String = "casa\(i)"
                        
                        let casa = json[nomeC]
                        
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
                            nomeC as String : ["id": "\(id!)", "frontImageID": "\(frontImageID!)", "mls": "\(mls!)", "status": "\(status!)", "title": "\(title!)", "price": "\(price!)", "loc": "\(loc!)"]
                        ]
                        
                        self.ArrayData.add(myDictObj.value(forKey: nomeC)!)
                    }
                    
                    if self.ArrayData.count > 0 {
                        for i in 0..<self.ArrayData.count {
                            self.ArrayImage.append(self.loadImage(self.startParsingImage((self.ArrayData[i] as AnyObject).value(forKey: "frontImageID") as! String)))
                        }
                        
                        let image = UIImageView(image: UIImage(named: "BackDrop_CM"))
                        
                        if UIScreen.main.bounds.width > 500
                        {
                            image.contentMode = .scaleAspectFill
                        }
                        else
                        {
                            image.contentMode = .center
                        }
                        
                        self.tableView.backgroundView = image
                    }
                }
                
            }catch _ as NSError {
                let alertController = UIAlertController(title: "Conexão internet", message: "Não é possível estabelecer conexão.", preferredStyle: .alert)
                let CancelAction = UIAlertAction(title: "Volte a tentar mais tarde", style: .cancel,  handler: { _ in
                    exit(0)
                })
                alertController.addAction(CancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
        self.do_table_refresh();
        
    }
    
    func loadImage(_ imageString: String) -> UIImage{
        
        if imageString != ""
        {
            let url = URL(string: imageString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            if (url == nil)
            {
                let image = UIImage(named: "example_270x220")
                Loader.stopAnimating()
                MyGlobalVariables.DestaquesLoad = true
                return image!
            }
            else
            {
                let data:Data? = try? Data(contentsOf: url!)
                var image = UIImage(named: "example_270x220")
                Loader.stopAnimating()
                MyGlobalVariables.DestaquesLoad = true
                if data != nil
                {
                    image = UIImage(data: data!)
                }
                return image!
            }
        }
        else
        {
            let image = UIImage(named: "example_270x220")
            Loader.stopAnimating()
            MyGlobalVariables.DestaquesLoad = true
            return image!
        }
    }
    
    func startParsingImage(_ codigo: String) -> String
    {
        //let screenHeight = Int(UIScreen.main.bounds.width * 0.5)
        
        if codigo == "Indisponível"
        {
            return ""
        }
        else
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
            guard let myURL = URL(string: baseImage + codigo + "&width=\(width)&height=\(512)&crop=no") else {
                print("Error: \(baseImage) doesn't seem to be a valid URL")
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
        return ArrayData.count
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
        
        //imagem principal
        cell.frontImage.image = ArrayImage[indexPath.row]
        //titulo
        if let strTitle2 : NSString = (self.ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "title") as? NSString {
            cell.lblTitle.text=strTitle2 as String
        }else{
            cell.lblTitle.text="Falhou o carregamento"
        }
        
        if let strTitle6 : NSString = (self.ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "loc") as? NSString {
            cell.Lbl_Location.text = strTitle6 as String
        }else{
            cell.Lbl_Location.text = "Falhou o carregamento"
        }
        
        if cell.Lbl_Background_Title.layer.sublayers?.count != nil
        {
            cell.Lbl_Background_Title.layer.sublayers?.removeAll()
        }
        
        if UIScreen.main.bounds.size.width > 500
        {
             cell.Lbl_Background_Title.bounds.size.width = 800
        }
        print(cell.Lbl_Background_Title.bounds)
        cell.Lbl_Background_Title.layer.insertSublayer(gradient(frame: cell.Lbl_Background_Title.bounds), at: 0)
        cell.Lbl_Background_Title.backgroundColor = UIColor.clear
        
        //dar a cor certa á imagem status
        if let strStatus : NSString = (self.ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "status") as? NSString {
            
            switch strStatus {
                
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
            
        }
        
        //dar o preço á label price
        if let strTitle4 : NSString=(ArrayData[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "price") as? NSString {
            
            //let price = MoneyMaker(strTitle4 as String)
            
            let price:Int = Int(strTitle4 as String)!
            let str = price.stringFormatedWithSepator
            
            let maskPath = UIBezierPath(roundedRect: self.View1.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: 20, height: 20))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            //cell.LblPrice.backgroundColor = .black
            
            cell.Llb_background_Price.layer.mask = maskLayer
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
    
    //GRAVAR AQUI OS DADOS PARA SEREM PASSADOS POR CELULA
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //enviar os dados para o id da casa clicado
        
        let indexPath = self.tableView.indexPathForSelectedRow;
        let strIDHouse : NSString=((ArrayData[(indexPath! as NSIndexPath).row] as AnyObject).value(forKey: "mls") as? NSString)!
        let strIDImages : NSString=((ArrayData[(indexPath! as NSIndexPath).row] as AnyObject).value(forKey: "id") as? NSString)!
        //let strIDImage : NSString=(ArrayData[indexPath!.row] .valueForKey("frontImageID") as? NSString)!
        let currentCell = tableView.cellForRow(at: indexPath!)as! TableViewCellDestaques!;
        
        titleHouse = currentCell?.lblTitle.text
        priceHouse = currentCell?.LblPrice.text
        idHouse = strIDHouse as String
        idImages = strIDImages as String

        self.performSegue(withIdentifier: "segueHouse", sender: self)
        self.tabBarController?.tabBar.items![2].image = nil
        
        self.tabBarController?.tabBar.items![0].imageInsets.left = 10
        self.tabBarController?.tabBar.items![0].imageInsets.right = -10
        self.tabBarController?.tabBar.items![1].imageInsets.left = 30
        self.tabBarController?.tabBar.items![1].imageInsets.right = -30
        self.tabBarController?.tabBar.items![2].isEnabled = false
        self.tabBarController?.tabBar.items![3].imageInsets.left = -30
        self.tabBarController?.tabBar.items![3].imageInsets.right = 30
        self.tabBarController?.tabBar.items![4].imageInsets.left = -10
        self.tabBarController?.tabBar.items![4].imageInsets.right = 10
        MyGlobalVariables.ComeDestaques = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
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

extension String {
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions : [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        } catch {
            self = htmlEncodedString
            return
        }
    }
}

struct Number {
    static let formatterWithSepator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var stringFormatedWithSepator: String {
        return Number.formatterWithSepator.string(from: NSNumber(value: hashValue)) ?? ""
    }
}

extension UIImage {
    var uncompressedPNGData: Data      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: Data { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: Data    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: Data     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:Data   { return UIImageJPEGRepresentation(self, 0.0)!  }
}
