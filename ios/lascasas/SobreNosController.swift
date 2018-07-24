//
//  SobreNosController.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils on 12/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import UIKit
import KCFloatingActionButton

class SobreNosController: UIViewController {
    
    let baseURL_ = "https://lascasas.pt/XX/app/mobile_api.php?func=get_about_us"
    @IBAction func goBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var Scroll: UIScrollView!
    @IBOutlet weak var Lbl_AboutUs: UILabel!
    
    @IBOutlet weak var Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        var text = ""
        let url = URL(string: "" + baseURL_)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            DispatchQueue.main.async(execute: {
                var res = String(data: data!, encoding: String.Encoding.utf8)
                if res!.contains("<br />") {
                    res = res!.replacingOccurrences(of: "<br />", with: "")
                }
                text = res!
                let attrString = NSMutableAttributedString(string: text)
                attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                self.Lbl_AboutUs.attributedText = attrString
                self.FAB()
            })
        })
        task.resume()
//        let text = "O Las Casas é consultor Imobiliário na XX Grupo Business. Neste momento, tem já uma equipa formada com 7 elementos, sendo que, conta com três especialistas de clientes compradores e três assistentes.\n\nO Las Casas iniciou a sua actividade como consultor imobiliário em 2009. Desde aí tem somado prémios como reconhecimento do seu trabalho. Desde 2010 que é o vendedor nº1 da Cidade de Braga e foi o vendedor nº1 em Portugal (2012 e 2013) em volume de transacções.\n\nPresentemente, acaba de integrar no mais recente projecto do Grupo Business, a entrada para a Keller Williams, agência nº1 nos EUA. Neste momento a Equipa Las Casas, já conquistou o 1º Lugar a Nível Nacional em Volume de Negócios e o 1º Lugar a Nível Nacional em Número de Transacções (1º Semestre 2015)."
//        let attrString = NSMutableAttributedString(string: text)
//        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
//        Lbl_AboutUs.attributedText = attrString
//        self.FAB()
        
        if UIScreen.main.bounds.width > 500
        {
            let constraintCenter : NSLayoutConstraint = NSLayoutConstraint(item: Lbl_AboutUs, attribute: .centerX, relatedBy: .equal, toItem: Label, attribute: .centerX, multiplier: 1, constant: 0)
            let constraintWidth : NSLayoutConstraint = NSLayoutConstraint(item: Lbl_AboutUs, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: 500)
            self.view.addConstraint(constraintCenter)
            Lbl_AboutUs.addConstraint(constraintWidth)
            print(Lbl_AboutUs.frame.size.width)
        }
        else
        {
            let constraintLeading : NSLayoutConstraint = NSLayoutConstraint(item: Lbl_AboutUs, attribute: .leading, relatedBy: .equal, toItem: Label, attribute: .leadingMargin, multiplier: 1, constant: 0)
            let constraintTrailing : NSLayoutConstraint = NSLayoutConstraint(item: Lbl_AboutUs, attribute: .trailing, relatedBy: .equal, toItem: Label, attribute: .trailingMargin, multiplier: 1, constant: 0)
            
            self.view.addConstraints([constraintLeading, constraintTrailing])
        }
        Scroll.contentSize.height = Lbl_AboutUs.frame.origin.y + Lbl_AboutUs.frame.size.height + 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func FAB(){
        // LINK:        https://github.com/kciter/KCFloatingActionButton#usage
        let fab = KCFloatingActionButton()
        fab.buttonImage = UIImage(named: "xxx_logo2")!
        fab.itemButtonColor = UIColor.white
        fab.plusColor = UIColor.white
        fab.buttonColor = UIColor.white
        fab.addItem(" Contacte-nos ", icon: UIImage(named: "xxx_logo_mini_1")!, handler: { item in
            self.openDezvezsDez()
        }).titleLabel.backgroundColor = UIColor.darkGray
        fab.addItem(" Visite o nosso site ", icon: UIImage(named: "xxx_logo_mini_1")!, handler: { item in
            self.openSite()
        }).titleLabel.backgroundColor = UIColor.darkGray
    
        fab.rotationDegrees = -45
        
        self.view.addSubview(fab)
        
    }
    
    func openSite(){
        print("openSite")
        let u_r_l = URL(string: "" + "http://pepdevils.pt")!
        let request_ = URLRequest(url: u_r_l)
        UIApplication.shared.openURL(request_.url!)
    }
    
    func openDezvezsDez(){
        print("openDezvezsDez")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let uiViewController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "XXX") as! UINavigationController
        self.present(uiViewController, animated: true, completion: nil)
    }

}
