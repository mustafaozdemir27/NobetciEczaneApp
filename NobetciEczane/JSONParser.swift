import UIKit

class JSONParser: NSObject {
    
   
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
    
    var dizge : [String] = []
    weak var tableVIEW : UITableView?
    
    public func parse(url:String)   {
        
        let urlObj = URL(string: url)
        
       URLSession.shared.dataTask(with: urlObj!){(data,response,error) in
            guard let dataN  = data else{return}
            do{
                
                let eczane = try
                    JSONDecoder().decode(Title.self ,from: dataN)
                for eczaneN in eczane.result{
                    
                    self.dizge.append(eczaneN.name!)
                    
                   
                }
                DispatchQueue.main.async {
                    self.tableVIEW!.reloadData()
                }
                print(self.dizge)
            }
            catch{
                print("We got an error!!!")
            }
            }.resume()
        
       
    }
    

}
