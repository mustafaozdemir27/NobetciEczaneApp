import UIKit
import MapKit
class PharmacyViewController: UIViewController , UITabBarDelegate,UITableViewDataSource {
  
    
    struct Title : Decodable{
        
        let success :Bool?
        let result :[Result]
        
        enum CodingKeys : String ,CodingKey{
            case success
            case result    = "result"
        }
    }
    struct Result:Decodable {
        
        let name:String?
        let dist:String?
        let address:String?
        let phone:String?
        let loc:String?
    }
   
    
   
    var discrit = String()
    @IBOutlet weak var tableview : UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var pharmaciesName:[String] = []
    var pharmaciesAddress : [String] = []
    var pharmaciesDist: [String] = []
    var pharmaciesPhone: [String] = []
    var pharmaciesLoc: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        activityIndicator.startAnimating()
        JsonParse()
        tableview.rowHeight = 225
        
        
        
    }
    

    
    func JsonParse(){
        let url = "https://api.collectapi.com/health/dutyPharmacy?il=Edirne&ilce="+discrit+"&apiKey=1awOoE9cVzGqDsKMtUxRxX:1BmPEGCefdrSiVRiIBFFtW"
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!){(data,response,error) in
            guard let dataN  = data else{return}
            do{
                
                let pharmacy = try
                    JSONDecoder().decode(Title.self ,from: dataN)
                for pharmacyN in pharmacy.result{
                    
                    
                    self.pharmaciesName.append(pharmacyN.name!)
                    self.pharmaciesAddress.append(pharmacyN.address!)
                    self.pharmaciesLoc.append(pharmacyN.loc!)
                    
                   
                    
                    if(pharmacyN.dist == "Semt Bulunamadı"){
                        
                        self.pharmaciesDist.append(self.discrit)
                    }
                    else{
                        self.pharmaciesDist.append(pharmacyN.dist!)
                    }
                    self.pharmaciesPhone.append(pharmacyN.phone!)
                    
                    
                    DispatchQueue.main.async {
                      
                        self.tableview?.reloadData()
                    }
                }
                
          
            }
            catch{
                print("Data is not found!")
            }
            }.resume()
        
        
    }
    




    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        return pharmaciesName.count
        
        
    }
   

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.name?.text = pharmaciesName[indexPath.row]
        cell.adress?.text = pharmaciesAddress[indexPath.row]
        cell.phone?.text = pharmaciesPhone[indexPath.row]
        cell.dist?.text = pharmaciesDist[indexPath.row]
        cell.loc?.text = pharmaciesLoc[indexPath.row]

   
        activityIndicator.stopAnimating()
    
        activityIndicator.isHidden = true
    
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedTableViewCell = sender as? UITableViewCell,
              let indexPath = tableview.indexPath(for: selectedTableViewCell)
            else { preconditionFailure("Expected sender to be a valid table view cell") }

        guard let mapViewController = segue.destination as? MapViewController
            else { preconditionFailure("Expected a MapViewController") }

        mapViewController.pharmacyLocation = pharmaciesLoc[indexPath.row]
        mapViewController.pharmacyName=pharmaciesName[indexPath.row]
    }
    
}
