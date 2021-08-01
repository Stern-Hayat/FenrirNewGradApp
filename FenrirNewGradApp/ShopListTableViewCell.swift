import UIKit

class ShopListTableViewCell: UITableViewCell {

    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var shopAccessLabel: UILabel!
    @IBOutlet var shopImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
