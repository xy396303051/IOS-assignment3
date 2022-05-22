
import UIKit
import CoreData

class ReserveTableViewController: UIViewController {

    var strUserName:String!
    var strDate:String!
    var strTime:String!
    var marTable:[String] = NSMutableArray.init() as! [String]
    
    @IBOutlet weak var vTables: UIView!
    @IBOutlet weak var btnReserve: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Table"
        
        self.btnReserve.backgroundColor = .white
        self.btnReserve.layer.borderWidth = 1
        self.btnReserve.layer.borderColor = UIColor.red.cgColor
        self.btnReserve.layer.cornerRadius = 5
        self.btnReserve.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    func showTables(tables:Array<String>) {
        let width = self.vTables.frame.size.width
        
        let table_w = (width - 60.0) / 4.0//Four tables per row
        let table_h = table_w * 0.58//A total of 5 rows of tables
        for i in 0...19 {
            let x = (12.0+table_w)*CGFloat((i%4))+12.0
            let y = (12.0+table_h)*CGFloat((i/4))+12.0//The coordinate position of each table in the view
            let table = Table.init(frame: CGRect.init(x: x, y: y, width: table_w, height: table_h))//Create a table (button) via CGRect
            table.addTarget(self, action: #selector(tableAction), for: .touchUpInside)//Add a task to be executed after the trigger is added to the table
            table.iNumber = i+1
            if tables.contains(where: {$0==String(table.iNumber)}) {//Use the method of CGRect.contains to determine whether the table area contains the current table, and if so, disable the table.
                table.isEnabled = false
            }
            self.vTables.addSubview(table)//Create 20 tables and add them to the vTable view.
        }
    }
    
    @objc func tableAction(table:Table) {
      dismiss(animated: true, completion: nil)
        table.isSelected = !table.isSelected
        if table.isSelected {
            self.marTable.append(String(table.iNumber))
        }else {
            self.marTable.removeAll(where: {$0==String(table.iNumber)})
        }//If it is not selected, the initial value of isselected is false. If isSelected is true, the current table will be added to the marTable. Otherwise, the query will be deleted from the table that matches the current iNumber.
    }
    
    func saveData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        do {
            let newReserve = NSEntityDescription.insertNewObject(forEntityName:"Reserve", into: context) as! Reserve
            newReserve.date = self.strDate
            newReserve.time = self.strTime
            newReserve.userName = self.strUserName
            newReserve.tables = self.marTable.joined(separator: ",")//Pass in the relevant information filled in by the customer to the Reserve
            try context.save()
            let alertController = UIAlertController(title:"Tip",message:"Reserve succeeded",preferredStyle: .alert)
            let okAction = UIAlertAction(title:"Ok",style: .default) { _ in//After the reservation is successful, the relevant title information of the pop-up and the button text information will be displayed and the following settings will be triggered after the customer clicks OK.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tableVC = storyboard.instantiateViewController(withIdentifier:"ReserveListViewController") as! ReserveListViewController
                self.navigationController?.pushViewController(tableVC, animated: true)//After the reservation is successful, jump to the page of reservation information
            }
            alertController.addAction(okAction)
            self.present(alertController,animated:true,completion:nil)
        } catch {
            fatalError("error ：\(error)")
        }
    }
    
    func loadData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext//Get the delegate of the global app and get the hosting context
        let fetchRequest = NSFetchRequest<Reserve>(entityName:"Reserve")//Using the CoreData framework, create a FetchRequest that gets the request and specify "Reserve" as the object that returns matching requests

        let predicate = NSPredicate.init(format: "date = %@ AND time = %@",self.strDate,self.strTime)//Set the text format of Date and time in My reservation
        fetchRequest.predicate = predicate
        var tables = ""
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            for table in fetchedObjects{
                if tables != ""{
                    tables = String.init(format: "%@,%@", tables,table.tables!)
                }else {
                    tables = table.tables!//The initial value of tables is empty, so the first table of fetchedObjects is passed into tables through this condition
                }
            }
            let arrTable = tables.components(separatedBy: ",")//Create an ArrayList containing all the tables fetched
            self.showTables(tables:arrTable )//Pass arrTable into the tables parameter of showTables() and execute the showTbles() func
        }
        catch {
           fatalError("error \(error)")
        }
    }
    @IBAction func reserveAction(_ sender: UIButton) {
        if self.marTable.count == 0 {
            let alertController = UIAlertController(title:"Tip",message:"Please select table",preferredStyle: .alert)//Determine whether the customer has a choice of table, if not, prompt the customer "Please select a table"
            let okAction = UIAlertAction(title:"Ok",style: .default,handler: {action  in})
            alertController.addAction(okAction)
            self.present(alertController,animated:true,completion:nil)
            return
        }
        self.saveData()
    }
}
