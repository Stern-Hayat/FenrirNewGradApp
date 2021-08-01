import UIKit
import Alamofire
import AlamofireImage

class ShopListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shopList = [[String]]()
    let ud = UserDefaults.standard
    @IBOutlet var shopListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        shopListTableView.delegate = self
        shopListTableView.dataSource = self
        
        if shopList != [[]]{
            shopList.removeAll()
        }
        //全画面で取得したデータをダウンロード。データ件数が0ならお詫びAlert。
        if ud.value(forKey: "shopArray") != nil{
            shopList = ud.value(forKey: "shopArray") as! [[String]]
        }else{
            let alert: UIAlertController = UIAlertController(title: "お詫び", message: "該当するデータがございませんでした。", preferredStyle: UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) -> Void in
                
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        shopListTableView.register(UINib(nibName: "ShopListTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shopListTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ShopListTableViewCell
        cell.shopNameLabel.text = shopList[indexPath.row][0]
        cell.shopAccessLabel.text = shopList[indexPath.row][8]
        let imageURL = shopList[indexPath.row][3]
        if imageURL != "" {
            cell.shopImageView.image = getImageByUrl(url: imageURL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    //選ばれたセルの詳細ページへ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ud.set(shopList[indexPath.row], forKey: "selectedShopDetail")
        ud.synchronize()
        performSegue(withIdentifier: "goDetailPage", sender: nil)
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
