
import UIKit

class PatientListCell: UITableViewCell {

   
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblPName: UILabel!
    
    @IBOutlet weak var lblPproblems: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        backView.layer.cornerRadius = 10.0
//        backView.layer.borderWidth = 1.0
//        backView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
