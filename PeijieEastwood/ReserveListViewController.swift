
import UIKit
import CoreData

class ReserveListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayData = Array<Reserve>()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My reservation"//Set the current page navigation bar title
        self.navigationController!.navigationBar.tintColor = UIColor.white//title font color
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.downLoad()
    }
    
    func downLoad() {
        self.arrayData = []
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Reserve>(entityName:"Reserve")//Extract parameters saved by user in ReserveTableViewController
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"//Set the display format of the date
        let date = NSDate.now//Extract the current system date
        let strDate:String = formatter.string(for:date)!
        let predicate = NSPredicate.init(format: "date >= %@",strDate)//Set only dates equal to or greater than the current date. Customers cannot select a previous date
        fetchRequest.predicate = predicate
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            self.arrayData = fetchedObjects
            self.tableView.reloadData()//Put all the values of the fetched fetchedObjects into arrayData
        }
        catch {
            fatalError("error ：\(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "RESERVECELLID") ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "RESERVECELLID")) as UITableViewCell
        let model = self.arrayData[indexPath.row]
        cell.textLabel?.text = String.init(format: "Date: %@ Time: %@", model.date!,model.time!)
        cell.detailTextLabel?.text = String.init(format: "Tables: %@ \nUser name: %@", model.tables!,model.userName!)//Use the cell of the prototype Content of Table View to display the relevant reservation information
        cell.detailTextLabel?.numberOfLines = 0;
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .normal, title: "Cancel") { _, _,  complete in//Set left swipe to appear Cancle function
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            context.delete(self.arrayData[indexPath.row])//Delete current appointment information
            self.downLoad()
            complete(true)
        }
        deleteAction.backgroundColor = .red//Set the background color of Cancle display to red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
