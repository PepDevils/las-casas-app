//
//  UITabBarController.swift
//  carlo_monteiro_ios
//
//  Created by pepdevils on 05/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import Foundation
import UIKit

class MenuUITabBarController: UITabBarController{
    
    var viewBlur = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var ArrayDataSearch: NSMutableArray = []
    var dict_houses: NSMutableDictionary = [:]
    var array_price_max = ["0","25.000","50.000","75.000","100.000","125.000","150.000","175.000","200.000","250.000","300.000","350.000","400.000","450.000","500.000","600.000","700.000","800.000","900.000","1.000.000"]
    var ArraySituacao = [String]()
    var ArraySituacaoNormal = [String]()
    func UpdateButtoms(){
        //mudar o icon se tiver log in
        if(MyGlobalVariables.isLoginIn){
            let item = self.tabBar.items![3]
            item.image = UIImage(named:"button_session")
        }else{
            let item = self.tabBar.items![3]
            item.image = UIImage(named:"button_private")
        }   
    }

    override open var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PesquisaTodas()
        
        // Cor dos items
        let appTintColor:UIColor = UIColor.white
        self.tabBar.tintColor = appTintColor
     
        //UpdateButtoms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(self.tabBar.selectedItem! == self.tabBar.items![0]){
            var array_items: Array = self.customizableViewControllers!
            if(array_items.count<5){
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let nav1 = UINavigationController()
                let controller = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                nav1.viewControllers = [controller]
                let item1 = UITabBarItem(title: "", image: UIImage(named: MyGlobalVariables.VerTodos), selectedImage: UIImage(named: MyGlobalVariables.VerTodos))
                item1.imageInsets.top = -20
                item1.imageInsets.bottom = 20
                nav1.tabBarItem = item1
                nav1.isNavigationBarHidden = true
                array_items.insert(nav1, at: 2)
                self.setViewControllers(array_items, animated: false)
            }
        }
        
        if(self.tabBar.selectedItem! == self.tabBar.items![3]){
            UpdateButtoms()
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        GameOfIcons(item: item)
    }
    
    func GameOfIcons(item: UITabBarItem){
        
        let index_pretened = 2
        var array_items:Array = (self.customizableViewControllers)!
        let nav1 = UINavigationController()
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        nav1.viewControllers = [controller]
        let item1 = UITabBarItem(title: "", image: UIImage(named: MyGlobalVariables.VerTodos), selectedImage: UIImage(named: MyGlobalVariables.VerTodos))
        item1.imageInsets.top = -20
        item1.imageInsets.bottom = 20
        nav1.tabBarItem = item1
        nav1.isNavigationBarHidden = true
        if item == (self.tabBar.items![0]){
            if(array_items.count < 5){
                array_items.insert(nav1, at: 2)
                let array_items:Array = array_items;
                self.setViewControllers(array_items, animated: false)
            }
            else
            {
                
                self.tabBar.items![0].imageInsets.left = 0
                self.tabBar.items![0].imageInsets.right = 0
                self.tabBar.items![1].imageInsets.left = 0
                self.tabBar.items![1].imageInsets.right = 0
                self.tabBar.items![2].isEnabled = true
                self.tabBar.items![2].image = UIImage(named: MyGlobalVariables.VerTodos)
                self.tabBar.items![2].selectedImage =  UIImage(named: MyGlobalVariables.VerTodos)
                self.tabBar.items![2].imageInsets.top = -20
                self.tabBar.items![2].imageInsets.bottom = 20
                self.tabBar.items![3].imageInsets.left = 0
                self.tabBar.items![3].imageInsets.right = 0
                self.tabBar.items![4].imageInsets.left = 0
                self.tabBar.items![4].imageInsets.right = 0
                
            }
        }else{
            if(array_items.count == 5 && item != (self.tabBar.items![2])){
                self.tabBar.items![1].imageInsets.left = 0
                self.tabBar.items![1].imageInsets.right = 0
                self.tabBar.items![2].isEnabled = false
                self.tabBar.items![3].imageInsets.left = 0
                self.tabBar.items![3].imageInsets.right = 0
                array_items.remove(at: index_pretened)
                self.setViewControllers(array_items, animated: false)
            }
        }
        
        if item != self.tabBar.items!.last
        {
            MyGlobalVariables.ComeFavourites = false
        }
        //ABRIR RESULTADO
        //ABRIR RESULTADO
        //ABRIR RESULTADO
        //ABRIR RESULTADO
        if(item == self.tabBar.items![2] && array_items.count == 5){
            print("PEPE SEGEUEGEUEHEHHBD")
            
            if self.dict_houses.count != 0
            {
                MyGlobalVariables.AllHouses = self.dict_houses
                item.image = nil
                self.tabBar.items![0].imageInsets.left = 10
                self.tabBar.items![0].imageInsets.right = -10
                self.tabBar.items![1].imageInsets.left = 30
                self.tabBar.items![1].imageInsets.right = -30
                self.tabBar.items![2].isEnabled = false
                self.tabBar.items![3].imageInsets.left = -30
                self.tabBar.items![3].imageInsets.right = 30
                self.tabBar.items![4].imageInsets.left = -10
                self.tabBar.items![4].imageInsets.right = 10
            }
        }
    }
    
    func PesquisaTodas(){
        
        let pagesIncrement = 0
        let itemsPerPage = 10
        
        let Q="Qualquer";
        
        let conselho = Q
        let freguesia = Q
        let tipo = Q
        let situacao = Q
        let preco_min = "0"
        let preco_max = "0"
        let quartos = Q
        
        var URL = MyGlobalVariables.baseURL + "search_ids2&min=\(preco_min)&max=\(preco_max)&page=\(pagesIncrement)&by_page=\(itemsPerPage)";
        
        if(situacao != "Qualquer"){
            URL += "&aquisition=\(situacao)"
        }
        if(tipo != "Qualquer"){
            URL += "&type=\(tipo)"
        }
        if(quartos != "Qualquer"){
            URL += "&bedrooms=\(quartos)"
        }
        if(conselho != "Qualquer"){
            URL += "&localidade=\(conselho)"
        }
        if(freguesia != "Qualquer"){
            URL += "&freguesia=\(freguesia)"
        }
        
        let url = NSURL(string: "" + URL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        print(url)
        var request = URLRequest(url : url! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in

            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
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
                        
                        self.ArrayDataSearch.add(myDictObj)
                        self.dict_houses.addEntries(from: myDictObj as [NSObject : AnyObject])
                    }
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
        task.resume()
    }
}
