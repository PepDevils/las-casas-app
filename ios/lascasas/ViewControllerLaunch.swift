 //
//  ViewControllerLaunch.swift
//  
//
//  Created by pepdevils  on 03/10/16.
//
//

import UIKit

class ViewControllerLaunch : UIViewController {
    
    @IBOutlet weak var rotator: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }

    override open var prefersStatusBarHidden: Bool
    {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
//        if MyGlobalVariables.NotifData != nil
//        {
//            let alertController = UIAlertController(title: "Conexão internet", message: "\(MyGlobalVariables.NotifData)", preferredStyle: .alert)
//            let CancelAction = UIAlertAction(title: "Volte a tentar mais tarde", style: .cancel,  handler: { _ in
//                exit(0)
//            })
//            alertController.addAction(CancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        else
//        {
            let url = NSURL(string: "http://lascasas.pt/XX/app/wp-content/uploads/2016/09/11-180x100.jpg".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            let request = NSMutableURLRequest(url : url! as URL,cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            let session = URLSession.shared
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                if data == nil
                {
                    let alertController = UIAlertController(title: "Conexão internet", message: "Necessita de ter conexão à internet", preferredStyle: .alert)
                    let CancelAction = UIAlertAction(title: "Volte a tentar mais tarde", style: .cancel,  handler: { _ in
                        exit(0)
                    })
                    alertController.addAction(CancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else
                {
                    self.refresh()
                    self.OpenNextView()
                }
            })
            task.resume()
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func OpenNextView(){
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabMenuController") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func refresh() {
        self.rotator.rotate360Degrees()
    }
}
