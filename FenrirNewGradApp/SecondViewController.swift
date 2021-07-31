import UIKit
import Alamofire
import AlamofireImage

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var shopList = [[String]]()
    
    @IBOutlet var shopListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        shopListTableView.delegate = self
        shopListTableView.dataSource = self
        shopList = UserDefaults.standard.value(forKey: "shopArray") as! [[String]]
        print(shopList)
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
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        cell.textLabel?.text = shopList[indexPath.row][0]
//        cell.detailTextLabel?.text = shopList[indexPath.row][1]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
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
