
import Foundation
import UIKit
import GoogleMaps


class Mapa_ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var ArrayData:NSMutableArray=[]
    let baseImage: String = "http://lascasas.pt/XX/app/mobile_api.php?func=get_image_resized&image_id=";
    var idHouse:String!
    var titleHouse:String!
    var priceHouse:String!
    var idImage : String!
    var idImages : String = "id default"
    var idezinho: String!
    var LatitudeHouse : Double = 41
    var LongitudeHouse : Double = -8

    @IBOutlet weak var uiview_for_map: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ArrayData = []
        DisplayMap()
        LoadHousesLocations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        CurrentPosition()
        self.uiview_for_map.settings.compassButton = true
        
    }
    
    func DisplayMap(){
        let camera : GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 41.60, longitude: -8.40, zoom: 9)
        self.uiview_for_map.camera = camera
        self.uiview_for_map.settings.myLocationButton = true
        self.uiview_for_map.settings.compassButton = true
        self.uiview_for_map.delegate = self
        
    }
    
    
    func CurrentPosition(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            uiview_for_map.isMyLocationEnabled = true
        }
        uiview_for_map.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            uiview_for_map.isMyLocationEnabled = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //uiview_for_map.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            if(LatitudeHouse == 41 && LongitudeHouse == -8)
            {
                let myLocation: CLLocation = /*locationManager.location!*/change![NSKeyValueChangeKey.newKey] as! CLLocation
                uiview_for_map.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 10.0)
            }
            else
            {
                uiview_for_map.camera = GMSCameraPosition.camera(withLatitude: LatitudeHouse, longitude: LongitudeHouse, zoom: 14)
            }
            didFindMyLocation = true
        }
    }
 
    
    func LoadHousesLocations(){
        let url = URL(string: "" + MyGlobalVariables.GetAllLocationsURL)
        var request = URLRequest(url : url!,cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                        for i in 0..<json.count{
                            let nomeC: String = "casa\(i)"
                            let casa = json[nomeC]
                            let id = casa!["ID"] as? String
                            let frontImageID = casa!["frontImageID"] as? String
                            var lat = casa!["lat"] as? String
                            if lat == nil
                            {
                                lat = "Indisponivel"
                            }
                            var long = casa!["long"] as? String
                            if long == nil
                            {
                                long = "Indisponivel"
                            }
                            let mls = casa!["mls"] as? String
                            let post_title = casa!["post_title"] as? String
                            let prince = casa!["prince"] as? String
                            
                            let myDictObj:NSDictionary = [
                                nomeC as String : ["id":  "\(id!)", "frontImageID": "\(frontImageID!)", "lat": "\(lat!)", "long": "\(long!)", "mls": "\(mls!)", "post_title": "\(post_title!)", "prince": "\(prince!)"]
                            ]
                            
                            self.ArrayData.add(myDictObj)
                            
                        }
                        
                        self.placeMarkersInMap()
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
    
    
    
    func placeMarkersInMap(){
        if (LatitudeHouse == 41 && LongitudeHouse == -8)
        {
            for i in 0..<self.ArrayData.count  {
                let CasaName = "casa\(i)"
                let casa = (self.ArrayData[i] as AnyObject).value(forKey: CasaName)
                
                
                let id = (casa! as AnyObject).value(forKey: "id")!
                let post_title = (casa! as AnyObject).value(forKey: "post_title")!
                let longitude = (casa! as AnyObject).value(forKey: "long")!
                let latitude = (casa! as AnyObject).value(forKey: "lat")!
                
                if ((longitude as? NSNull) != nil || (latitude as? NSNull) != nil ) {
                    
                }else{
                    DispatchQueue.main.async(execute: {
                        let marker:GMSMarker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake((latitude as AnyObject).doubleValue, (longitude as AnyObject).doubleValue)
                        marker.title = post_title as? String
                        marker.snippet = id as? String
                        marker.icon = UIImage(named: "gps_marker")
                        marker.infoWindowAnchor = CGPoint(x: 0.44, y: 0.45)
                        marker.accessibilityLabel = "\(i)"
                        marker.map = self.uiview_for_map
                    })
                }
            }
        }
        else
        {
            for i in 0..<self.ArrayData.count  {
                let CasaName = "casa\(i)"
                let casa = (self.ArrayData[i] as AnyObject).value(forKey: CasaName)
                let id = (casa! as AnyObject).value(forKey: "id")
                let post_title = (casa! as AnyObject).value(forKey: "post_title")
                let longitude = (casa! as AnyObject).value(forKey: "long")
                let latitude = (casa! as AnyObject).value(forKey: "lat")
                if (longitude as AnyObject).doubleValue == LongitudeHouse && (latitude as AnyObject).doubleValue == LatitudeHouse
                {
                    DispatchQueue.main.async(execute: {
                        let marker:GMSMarker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake(((latitude as AnyObject).doubleValue)!, ((longitude as AnyObject).doubleValue)!)
                        marker.title = post_title as? String
                        marker.snippet = id as? String
                        marker.icon = UIImage(named: "gps_marker")
                        marker.infoWindowAnchor = CGPoint(x: 0.44,y: 0.45)
                        marker.accessibilityLabel = "\(i)"
                        marker.map = self.uiview_for_map
                    })
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let index:Int! = Int(marker.accessibilityLabel!)
        
        if(index != nil){
            let infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?.first as! CustomInfoWindow
            let CasaName = "casa\(index!)"
            let casa = (self.ArrayData[index] as AnyObject).value(forKey: CasaName)
            let house_title = (casa! as AnyObject).value(forKey: "post_title")!
            //titleHouse = house_title
            let house_image = (casa! as AnyObject).value(forKey: "frontImageID")!
            titleHouse = house_title as? String
            idImage = house_image as! String
            idezinho = (casa! as AnyObject).value(forKey: "mls")! as! String
            priceHouse = (casa! as AnyObject).value(forKey: "prince")! as! String
            idImages = (casa! as AnyObject).value(forKey: "id")! as! String
            //let house_title = (ArrayData[index]).allValues[2]
            //let house_image = (ArrayData[index]).allValues[0]
            // idImages = (ArrayData[index]).allValues[5] as! String
            
            infoWindow.title_info_window.text = house_title as? String
            infoWindow.image_info_window.image = loadImage(startParsingImage(house_image as! String))
            return infoWindow
            
        }else{
            return nil
        } 
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let index:Int! = Int(marker.accessibilityLabel!)
        if(index != nil){
            self.performSegue(withIdentifier: "segueHouse", sender: self)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueHouse" {
            let destination = segue.destination as! HouseViewController
            destination.titleHouse = titleHouse
            
            let price:Int = Int(priceHouse as String)!
            let str = price.stringFormatedWithSepator
            MyGlobalVariables.ComeMap = true
            destination.priceHouse = (str as String) + " €"
            destination.idHouse = idezinho
            destination.idImages = idImages
        }
    }
    
    func startParsingImage(_ codigo: String) -> String
    {
        guard let myURL = URL(string: baseImage + codigo + "&width=500&height=100&crop=no") else {
            print("Error: \(baseImage) doesn't seem to be a valid URL")
            return ""
        }
        do {
            let myHTMLString = try String(contentsOf: myURL)
            let url = myHTMLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            print("HTML : \(url)")
            return url!
        } catch let error as NSError {
            print("Error: \(error)")
            return ""
        }
    }
    
    func loadImage(_ imageString: String) -> UIImage{
        let url:URL? = URL(string: imageString)
        if (url == nil)
        {
            MyGlobalVariables.ComeMapNil = true
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
