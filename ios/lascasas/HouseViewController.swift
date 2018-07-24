//
//  HouseViewController.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils  on 21/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import Foundation
import ImageSlideshow

class HouseViewController : UIViewController, GMSMapViewDelegate {
    
    //Variables
    let Red_Carlo:UIColor = UIColor(red: 166/255, green: 29/255, blue: 40/255, alpha: 1)
    var indexFav: Int = 0
    var Latitude: Double = 41
    var Longitude: Double = -8
    var idHouse:String!
    var titleHouse:String!
    var priceHouse:String!
    var idImage: UIImage!
    var idImages: String!
    var goBak : Bool = false
    var Image : Bool = false

    @IBOutlet weak var ImageSlideShow: ImageSlideshow!
    
    var ctr : FullScreenSlideshowViewController!
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    //http://lascasas.pt/XX/app/mobile_api.php?func=get_image_resized&image_id=1072&width=777&height=444&crop=yes
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    //Arrays
    
    var ArrayFavourites = [String]()
    var ArrayImagesID : [InputSource] = []
    var ArrayImagesIDString : [String] = []
    
    //Connections
    
    @IBOutlet weak var VIEW: UIView!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var Scroll: UIScrollView!
    @IBOutlet weak var Lbl_title: UILabel!
    @IBOutlet weak var Lbl_id: UILabel!
    @IBOutlet weak var Lbl_price: UILabel!
    @IBOutlet weak var Lbl_descricao: UILabel!

    @IBOutlet weak var Map: GMSMapView!
    @IBOutlet weak var Bt_favourites: UIButton!
    
    @IBAction func goBack(_ sender: AnyObject) {
        if MyGlobalVariables.ComeFavourites == true
        {
            let _ = self.navigationController?.popViewController(animated: true)
            MyGlobalVariables.ComeSearchtoResult = true
            goBak = true
            //MyGlobalVariables.ComeFavourites = false
        }
        else if MyGlobalVariables.ComeMap == true
        {
            print("dismissed")
            let _ = self.navigationController?.popViewController(animated: true)
            goBak = true
            MyGlobalVariables.ComeMap = false
            MyGlobalVariables.ComeMapNil = false
        }
        else
        {
            var array_items: Array = (tabBarController?.customizableViewControllers)!
            
            if array_items.count != 5
            {
                if !MyGlobalVariables.ComeSearch{
                    let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let nav1 = UINavigationController()
                    let controller = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                    nav1.viewControllers = [controller]
                    let item1 = UITabBarItem(title: "", image: UIImage(named: MyGlobalVariables.VerTodos), selectedImage: UIImage(named: MyGlobalVariables.VerTodos))
                    item1.imageInsets.top = -10
                    item1.imageInsets.bottom = 10
                    nav1.tabBarItem = item1
                    nav1.isNavigationBarHidden = true
                    array_items.insert(nav1, at: 2)
                    tabBarController?.setViewControllers(array_items, animated: false)
                    tabBarController?.tabBar.items![0].imageInsets.left = 0
                    tabBarController?.tabBar.items![0].imageInsets.right = 0
                    tabBarController?.tabBar.items![1].imageInsets.left = 0
                    tabBarController?.tabBar.items![1].imageInsets.right = 0
                    tabBarController?.tabBar.items![2].imageInsets.top = -20
                    tabBarController?.tabBar.items![2].imageInsets.bottom = 20
                    tabBarController?.tabBar.items![3].imageInsets.left = 0
                    tabBarController?.tabBar.items![3].imageInsets.right = 0
                    tabBarController?.tabBar.items![4].imageInsets.left = 0
                    tabBarController?.tabBar.items![4].imageInsets.right = 0
                    
                }
                else
                {
                    MyGlobalVariables.ComeSearchtoResult = true
                }
            }
            else
            {
                if MyGlobalVariables.ComeDestaques
                {
                    self.tabBarController?.tabBar.items![2].image = UIImage(named: MyGlobalVariables.VerTodos)
                    self.tabBarController?.tabBar.items![2].selectedImage = UIImage(named: MyGlobalVariables.VerTodos)
                    //item.image = nil
                    tabBarController?.tabBar.items![0].imageInsets.left = 0
                    tabBarController?.tabBar.items![0].imageInsets.right = 0
                    tabBarController?.tabBar.items![1].imageInsets.left = 0
                    tabBarController?.tabBar.items![1].imageInsets.right = 0
                    self.tabBarController?.tabBar.items![2].isEnabled = true
                    tabBarController?.tabBar.items![2].imageInsets.top = -20
                    tabBarController?.tabBar.items![2].imageInsets.bottom = 20
                    tabBarController?.tabBar.items![3].imageInsets.left = 0
                    tabBarController?.tabBar.items![3].imageInsets.right = 0
                    tabBarController?.tabBar.items![4].imageInsets.left = 0
                    tabBarController?.tabBar.items![4].imageInsets.right = 0
                    MyGlobalVariables.ComeDestaques = false
                }
            }
            
            goBak = true
            let _ = self.navigationController?.popViewController(animated: true)
            

        }
    }
    @IBAction func Bt_Favourites(_ sender: AnyObject) {
        if MyGlobalVariables.isLoginIn == false{
            let alertController = UIAlertController(title: "Favoritos", message: "Precisa de ter sessão iniciada para efetuar esta operação", preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if MyGlobalVariables.isLoginIn == true{
            if indexFav == 0{
                AddFavourite(idImages)
                indexFav = 1
            }
            else
            {
                RemoveFavourite(idImages)
                indexFav = 0
            }
        }
    }
    @IBOutlet weak var Bt_CallUs: UIButton!
    
    
    @IBAction func Bt_CallUs(_ sender: AnyObject) {
        let phone = "tel://+351961385433"
        let url:URL = URL(string:phone)!
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
        {
            UIApplication.shared.openURL(url)
        }
        else
        {
            let alertController = UIAlertController(title: "O seu dispositivo não permite efetuar chamadas", message: "", preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var Bt_Rota: UIButton!
    
    @IBAction func Bt_Rota(_ sender: AnyObject) {
        let query = "?daddr=\(Latitude),\(Longitude)&dirflg=d&t=k"
        let path = "http://maps.apple.com/" + query
        if let url = URL(string: path) {
            UIApplication.shared.openURL(url)
        }
    }
    
    //override func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let array_items: Array = (tabBarController?.customizableViewControllers)!
        
        
        
        if MyGlobalVariables.ComeDestaques == true && array_items.count == 5
        {
            self.tabBarController?.tabBar.items![2].image = nil
            //item.image = nil
            self.tabBarController?.tabBar.items![0].imageInsets.left = 10
            self.tabBarController?.tabBar.items![0].imageInsets.right = -10
            self.tabBarController?.tabBar.items![1].imageInsets.left = 30
            self.tabBarController?.tabBar.items![1].imageInsets.right = -30
            self.tabBarController?.tabBar.items![2].isEnabled = false
            self.tabBarController?.tabBar.items![3].imageInsets.left = -30
            self.tabBarController?.tabBar.items![3].imageInsets.right = 30
            self.tabBarController?.tabBar.items![4].imageInsets.left = -10
            self.tabBarController?.tabBar.items![4].imageInsets.right = 10
        }
        if MyGlobalVariables.isLoginIn == true
        {
            GetFavourite(idImages)
        }
        Loader.startAnimating()
        ImageSlideShow.isUserInteractionEnabled = false
        goBak = false
        Lbl_title.text = titleHouse
        Lbl_id.text = "ID: " + idHouse
        Lbl_price.text = priceHouse
        Bt_CallUs.layer.cornerRadius = 4
        Bt_CallUs.layer.borderWidth = 2
        Bt_CallUs.layer.borderColor = UIColor.darkGray.cgColor
        
        Bt_Rota.layer.cornerRadius = 4
        Bt_Rota.layer.borderWidth = 2
        Bt_Rota.layer.borderColor = UIColor.darkGray.cgColor
        getDescricao()
        getLocations()
        getImagesID(idImages)
        ImageSlideShow.pageControlPosition = PageControlPosition.insideScrollView
        ImageSlideShow.pageControl.currentPageIndicatorTintColor = Red_Carlo
        ImageSlideShow.pageControl.pageIndicatorTintColor = UIColor.white
        ImageSlideShow.pageControl.isUserInteractionEnabled = false
        ImageSlideShow.addSubview(ImageSlideShow.activityView)
        ImageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(HouseViewController.click))
        ImageSlideShow.addGestureRecognizer(recognizer)
        self.Scroll.contentSize.height = self.VIEW.frame.origin.y + self.VIEW.frame.size.height + 150
    }
    
    func click() {
        ctr = FullScreenSlideshowViewController()
        ctr.pageSelected = {(page: Int) in
            self.ImageSlideShow.setScrollViewPage(page, animated: false)
        }
        Image = true
        ctr.initialImageIndex = ImageSlideShow.scrollViewPage
        ctr.inputs = ImageSlideShow.images
        ctr.slideshow.ID(HouseIDs: self.ArrayImagesIDString)
        slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: ImageSlideShow, slideshowController: ctr)
        ctr.transitioningDelegate = slideshowTransitioningDelegate
        self.present(ctr, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        goBak = false
        Image = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
//        var array_items : Array = (tabBarController?.customizableViewControllers)!
//        if (array_items.count == 5)
//        {
//            array_items.remove(at: 2)
//            tabBarController?.setViewControllers(array_items, animated: false)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if goBak == false && Image == false
        {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //funcs
    
    func AddFavourite(_ HouseID : String)
    {
        let url = URL(string: "" + MyGlobalVariables.baseURL + "set_user_favorite&user_mail=" + MyGlobalVariables.client_email + "&casa=" + HouseID)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                let dict = String(data: data!, encoding: String.Encoding.utf8)
                
                if dict == "Got it!"{
                    self.Bt_favourites.setImage(UIImage(named: "coracao_in_love"), for: UIControlState())
                }
            })
        })
        
        task.resume()
    }
    
    func RemoveFavourite(_ HouseID : String)
    {
        let url = URL(string: "" + MyGlobalVariables.baseURL + "remove_user_favorite&user_mail=" + MyGlobalVariables.client_email + "&casa=" + HouseID)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                let dict = String(data: data!, encoding: String.Encoding.utf8)
                
                if dict == "Got it!"{
                    self.Bt_favourites.setImage(UIImage(named: "coracao"), for: UIControlState())
                }
            })
        })
        task.resume()
    }

    func GetFavourite(_ HouseID : String)
    {
        let url = URL(string: "" + MyGlobalVariables.baseURL + "get_user_favorites&user_mail=" + MyGlobalVariables.client_email)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                let res = String(data: data!, encoding: String.Encoding.utf8)
                self.ArrayFavourites = (res?.components(separatedBy: ","))!
                
                for i in 0..<self.ArrayFavourites.count
                {
                    if self.ArrayFavourites[i] == HouseID{
                        self.Bt_favourites.setImage(UIImage(named: "coracao_in_love"), for: UIControlState())
                        self.indexFav = 1
                    }
                }
            })
        })
        task.resume()
    }
    
    func DisplayMap(){
        let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: Latitude, longitude: Longitude, zoom: 18)
        self.Map.camera = camera
        self.Map.settings.scrollGestures = false;
        self.Map.settings.zoomGestures = false;
        self.Map.isUserInteractionEnabled = false
        self.Map.mapType = GoogleMaps.kGMSTypeHybrid
        self.Map.delegate = self
        let marker:GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(Latitude, Longitude)
        marker.icon = UIImage(named: "gps_marker")
        marker.map = self.Map
        marker.accessibilityLabel = "0"
    }
    
    func getLocations() {
        let url = URL(string: "" + MyGlobalVariables.GetLocationsURL + idImages)
        var request = URLRequest(url : url!,cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                let res = String(data: data!, encoding: String.Encoding.utf8)
                
                if res?.components(separatedBy: ",")[0] == "" || res?.components(separatedBy: ",")[1] == ""
                {
                    self.Latitude = 0
                    self.Longitude = 0
                    
                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.Map.layer.frame.width, height: self.Map.layer.frame.height))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 10
                    
                    let text = "     Localização indisponível"
                    let attrString = NSMutableAttributedString(string: text)
                    attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                    
                    label.attributedText = attrString
                    label.font = UIFont(name: "CooperHewitt-Semibold", size: 20)
                    label.textColor = self.Red_Carlo
                    self.Map.isUserInteractionEnabled = false
                    
                    
                    //label.text = "     Localização indisponível"
                    self.Map.addSubview(label)
                }
                else
                {
                    self.Latitude = Double((res?.components(separatedBy: ",")[0])!)!
                    self.Longitude = Double((res?.components(separatedBy: ",")[1])!)!
                    self.DisplayMap()
                }
                
//                if res?.components(separatedBy: ",")[1] == ""
//                {
//                    
//                }
//                else
//                {
//                    self.Longitude = Double((res?.components(separatedBy: ",")[1])!)!
//                    self.DisplayMap()
//                }
            })
        })
        task.resume()
    }
    
    func getDescricao() {
        let url = URL(string: "" + MyGlobalVariables.GetDescricaoURL + idImages)
        var request = URLRequest(url : url!,cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                let res = String(data: data!, encoding: String.Encoding.utf8)
                var string = res!
                string = string.replacingOccurrences(of: "&nbsp;", with: " ")
                //string = string.replacingOccurrences(of: "nbsp;", with: "")
                string = string.replacingOccurrences(of: "\\\\n", with: "\n")
                string = string.replacingOccurrences(of: "\n", with: "<div>")
                string = string.replacingOccurrences(of: "<strong>", with: "<strong><b>")
                string = string.replacingOccurrences(of: "</strong>", with: "</b></strong>")
                string = string.replacingOccurrences(of: "&amp;", with: "")
                
                let str = String(htmlEncodedString: string)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 10
                
                let attrString = NSMutableAttributedString(string: str)
                attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                self.Lbl_descricao.attributedText = attrString
            })
        })
        task.resume()
    }
    
    func getImagesID(_ HouseID: String){
        
        let url = URL(string: "" + MyGlobalVariables.baseURL + "get_images&casa=" + HouseID)
        
        var request = URLRequest(url: url!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.global().async(execute: {
                
                let res = String(data: data!, encoding: String.Encoding.utf8)
                self.ArrayImagesIDString = (res?.components(separatedBy: ","))!
                
                for i in 0..<self.ArrayImagesIDString.count
                {
                    //if i < 5
                    //{
                        if self.ArrayImagesIDString[i] == "" {
                            self.ArrayImagesIDString.remove(at: i)
                        }
                        else {
                            self.ArrayImagesID.append(SDWebImageSource(url: self.startParsingImages(self.ArrayImagesIDString[i]), placeholder: UIImage(named: "example_270x220")!))
                        }
                    //}
                }

                DispatchQueue.main.async(execute: {
                    self.ImageSlideShow.ID(HouseIDs: self.ArrayImagesIDString)
                    self.ImageSlideShow.setImageInputs(self.ArrayImagesID)
                    self.VIEW.frame.size.height = self.Bt_Rota.frame.origin.y + self.Bt_Rota.frame.size.height
                    
                    self.Scroll.contentSize.height = self.VIEW.frame.origin.y + self.VIEW.frame.size.height + 50
                    
                    self.Loader.stopAnimating()
                    self.ImageSlideShow.isUserInteractionEnabled = true
                })
                
            })
        })
        task.resume()
    }
    
    func startParsingImages(_ codigo: String) -> URL
    {
        //let screenHeight = UIScreen.main.bounds.width * 0.58
        var width = 0
        if Int(UIScreen.main.bounds.width) > 500
        {
            width = 1000
        }
        else
        {
            width = 700
        }
        guard let myURL = URL(string: MyGlobalVariables.baseURL + "get_image_resized&image_id=" + codigo + "&width=\(width)&height=\(512)&crop=no") else {
            print("Error: \(MyGlobalVariables.baseImage) doesn't seem to be a valid URL")
            return URL(string: "wwws.pepdevils.pt")!
        }
        do {
            let myHTMLString = try String(contentsOf: myURL)
            let url = myHTMLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print("HTML : \(url)")
            let myHTMLurl = URL(string: url!)
            return myHTMLurl!
        } catch let error as NSError {
            print("Error: \(error)")
            return URL(string: "www.pepdevils.pt")!
        }
    }
    
    func startParsingImagesString(_ codigo: String) -> String
    {
        //let screenHeight = UIScreen.main.bounds.width * 0.58

        guard let myURL = URL(string: MyGlobalVariables.baseURL + "get_image&image_id=" + codigo /*+ "&width=\(Int(UIScreen.main.bounds.width))&height=\(512/*screenHeight*/)"*/) else {
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
        let url:URL? = URL(string: imageString)
        if (url == nil)
        {
            let image = UIImage(named: "example_270x220")
            return image!
        }
        else
        {
            let data:Data? = try? Data(contentsOf: url!)
            var image = UIImage(named: "example_270x220")
            if data != nil
            {
                image = UIImage(data: data!)
            }
            return image!
        }
    }
}
