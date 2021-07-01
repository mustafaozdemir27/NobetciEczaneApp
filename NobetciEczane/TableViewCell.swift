import UIKit

class TableViewCell: UITableViewCell {

   
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var adress: UILabel?
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var dist: UILabel!
    @IBOutlet weak var loc: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
