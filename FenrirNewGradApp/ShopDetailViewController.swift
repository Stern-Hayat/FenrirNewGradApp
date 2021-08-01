
import UIKit
import SafariServices

class ShopDetailViewController: UIViewController {
    //詳細画面のパーツ
    @IBOutlet var shopImageView: UIImageView!
    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var shopGenreLabel: UILabel!
    @IBOutlet var shopAddressLabel: UILabel!
    @IBOutlet var shopAccessLabel: UILabel!
    @IBOutlet var shopOpeningTimeLibel: UILabel!
    @IBOutlet var shopClosingTimeLabel: UILabel!
    @IBOutlet var shopBudgetLabel :UILabel!
    @IBOutlet var shopCapacitiyLabel: UILabel!
    
    var shopArray = [String]()
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopArray = ud.value(forKey: "selectedShopDetail") as! [String]
        //詳細画面のパーツ
        shopNameLabel.text = shopArray[0]
        shopGenreLabel.text = shopArray[1]
        shopAddressLabel.text = shopArray[6]
        shopOpeningTimeLibel.text = shopArray[7]
        shopAccessLabel.text = shopArray[8]
        shopClosingTimeLabel.text = shopArray[9]
        shopBudgetLabel.text = shopArray[2] + shopArray[10]
        shopCapacitiyLabel.text = "(定員数：" + shopArray[11] + "席)"
        shopImageView.image = getImageByUrl(url: shopArray[3])
    }
    
    //詳細ページからWebページを呼び出された時の機能
    @IBAction func loadSafari(){
        let url = URL(string: shopArray[12])
        if let url = url {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    //画像呼び出し関数
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
        let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}
