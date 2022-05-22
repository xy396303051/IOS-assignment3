
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnReserve: UIButton!
    @IBOutlet weak var btnMyReservation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"//Set the homepage navigation bar title to Home
        
//        self.btnReserve.setTitleColor(.white, for: .normal)
        self.btnReserve.backgroundColor = .white//Set the background color of the Reserve button to white
        self.btnReserve.layer.borderWidth = 1
        self.btnReserve.layer.borderColor = UIColor.red.cgColor
        self.btnReserve.layer.cornerRadius = 5//Set the four corners to have a certain radian
        self.btnReserve.layer.masksToBounds = true
        
        self.btnMyReservation.setTitleColor(.white, for: .normal)//Set the title of the My reservation button
        self.btnMyReservation.backgroundColor = .red
        self.btnMyReservation.layer.cornerRadius = 5
        self.btnMyReservation.layer.masksToBounds = true
    }

    @IBAction func telPhoneAction(_ sender: UIButton) {
        let tempPhone = "0298599937"//Set the displayed restaurant reservation phone number
        let phone = "telprompt://" + tempPhone
        if UIApplication.shared.canOpenURL(URL(string: phone)!) {
            UIApplication.shared.open(URL(string: phone)!, options: [:], completionHandler: nil)//Set up the function that customers can call on their mobile phones with one click
        }
    }
    
    @IBAction func reserveAction(_ sender: UIButton) {
        
    }
    
    @IBAction func myReservationAction(_ sender: UIButton) {
    }
}


