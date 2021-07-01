import UIKit

class DistrictViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
  
    var discrit : [String] = ["Merkez","Havsa","Ke%C5%9Fan","Enez","%C4%B0psala","Lalapa%C5%9Fa","Meri%C3%A7","S%C3%BClo%C4%9Flu","Uzunk%C3%B6pr%C3%BC"]
    
    var discritDisplay : [String] = ["Merkez","Havsa","Keşan","Enez","İpsala","Lalapaşa","Meriç","Süloğlu","Uzunköprü"]
    @IBOutlet weak var tableview:UITableView?
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discrit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = (self.tableview?.dequeueReusableCell(withIdentifier:  "cell")!)!
        cell.textLabel?.text = discritDisplay[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = self.tableview?.indexPathForSelectedRow
        let itemName = discrit[indexPath!.row]
        
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = StoryBoard.instantiateViewController(withIdentifier: "PharmacyViewController") as? PharmacyViewController
        viewController?.discrit=itemName
        self.navigationController?.pushViewController(viewController!, animated: true)
        
      
    }
    

}
