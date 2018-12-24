
import UIKit

class PatientListCell: UITableViewCell {

   
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblPName: UILabel!
    
    @IBOutlet weak var lblPproblems: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
