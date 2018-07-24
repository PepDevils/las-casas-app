

import Foundation

class XXXViewController : UIViewController{
    
    @IBOutlet weak var XXXLabel: UILabel!
    
    @IBOutlet weak var Scroll: UIScrollView!
    
    @IBOutlet weak var XXXSinceLabel: UILabel!
    
    var i = 0
    @IBAction func goBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var cat_x: UIImageView!
    @IBOutlet weak var cat_dez: UIImageView!
    @IBAction func bt_XXX_cats(_ sender: AnyObject) {

        if cat_dez.frame.origin.y == -self.cat_dez.frame.size.height {
            cat_dez.frame.origin.y = XXXSinceLabel.frame.origin.y + XXXSinceLabel.frame.size.height + 300
        }
        
        if cat_x.frame.origin.y == -self.cat_x.frame.size.height {
            cat_x.frame.origin.y = XXXSinceLabel.frame.origin.y + XXXSinceLabel.frame.size.height + 10
        }

        UIView.animate(withDuration: 5.0, animations: {
            self.cat_x.frame = CGRect(x: self.cat_x.frame.origin.x, y: -self.cat_x.frame.size.height, width: self.cat_x.frame.size.width, height: self.cat_x.frame.size.height)
        })

        UIView.animate(withDuration: 8.0, animations: {
            self.cat_dez.frame = CGRect(x: self.cat_dez.frame.origin.x, y: -self.cat_dez.frame.size.height, width: self.cat_dez.frame.size.width, height: self.cat_dez.frame.size.height)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Scroll.contentSize.height = XXXLabel.frame.origin.y + XXXLabel.frame.size.height
        XXXLabel.text = "Geral. 253 331 170\n\nDesign. 918 887 384\n\nMarketing. 918 887 370\n\nGeral. geral@pepdevils.pt\n\nMiguel. pepdevils@me.com\n\n\npepdevils Sociedade\nAvenida Cidade do Porto, nº12\n4705-084 Maximinos_Braga_Portugal"
        XXXLabel.textColor = UIColor.gray
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.component(.year, from: date as Date)
        
        let year = components
        XXXSinceLabel.text = "pepdevils _ making you linked since\n2008 _ ©\(year)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
}
