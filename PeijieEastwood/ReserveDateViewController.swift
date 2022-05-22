
import UIKit

class ReserveDateViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tfUserName: UITextField!
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    let arrTime = ["10Am ~ 11Am","11Am ~ 12Pm","12Pm ~ 01Pm","02Pm ~ 03Pm","03Pm ~ 04Pm","04Pm ~ 05Pm","06Pm ~ 07Pm","08Pm ~ 09Pm","09Pm ~ 10Pm"]//Provides a user-selectable time range
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Reserve Date"
        self.navigationController!.navigationBar.tintColor = UIColor.white//Set the title and font color of the navigation bar
        
        let secondsPerDay = TimeInterval.init(86400)
        self.datePicker.minimumDate = Date.init(timeIntervalSinceNow: secondsPerDay)//Set the time of day, a total of 86400 seconds in 24 hours a day
        
        self.btnNext.backgroundColor = .white//set background color
        self.btnNext.layer.borderWidth = 1 //Set the width of the border (navigation bar)
        self.btnNext.layer.borderColor = UIColor.red.cgColor//Set the color of the navigation bar
        self.btnNext.layer.cornerRadius = 5//Set the box with the four corners of the angle
        self.btnNext.layer.masksToBounds = true
        
        tfUserName.delegate = self
        tfPhoneNumber.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func timeAction(_ sender: UIButton) {
        let  alertController =  UIAlertController (title:"Time",message:nil,preferredStyle: .actionSheet )//Set the title and style of the current time
        for t in arrTime {
            let  timeAction =  UIAlertAction (title:t, style: .default,
             handler: {
                 action  in
                self.btnTime.setTitle(t, for: .normal)
            })
            alertController.addAction(timeAction)//Add the time in arrTime to the alertController
        }
        self.present(alertController, animated:  true , completion:  nil )//Add the alertController to self and start the animation that presents the event
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        var message = ""
        if self.tfUserName.text == "" {
            message = "Please enter UserName"
        }
        
        if self.tfPhoneNumber.text == "" {
            message = "Please enter Phone number"//When the user clicks Nect, check whether the name and phoneNumber are empty. If they are empty, the user will be prompted for relevant information. The specific rendering method is shown in the code below
        }
        if self.tfPhoneNumber.text != ""  {
            if self.tfPhoneNumber.text!.count != 10 || Array(self.tfPhoneNumber.text!)[0] != "0" {
                message = "Phone number format error"//Check whether the mobile phone number has ten digits and whether the first digit is 0. If the conditions are not met, the customer will be prompted with an error message. The specific rendering method is shown in the code below
            }
        }
        
        if message != "" {
            let alertController = UIAlertController(title:"Tip",message:message,preferredStyle: .alert)
            let okAction = UIAlertAction(title:"Ok",style: .default,handler: {action  in})
            alertController.addAction(okAction)
            self.present(alertController,animated:true,completion:nil)//If it is detected that the message is not empty, the following condition is triggered. If the customer does not fill in the relevant information, after clicking Next, a prompt box will pop up with a related message error prompt.
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tableVC = storyboard.instantiateViewController(withIdentifier:"ReserveTableViewController") as! ReserveTableViewController
        tableVC.strUserName = self.tfUserName.text!
        tableVC.strTime = self.btnTime.titleLabel?.text!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"//Format the date when showing appointment information
        let strDate = formatter.string(for: self.datePicker.date)
        tableVC.strDate = strDate
        self.navigationController?.pushViewController(tableVC, animated: true)//Instantiate and present relevant parameters in ReserveTableViewController
    }
    
}
