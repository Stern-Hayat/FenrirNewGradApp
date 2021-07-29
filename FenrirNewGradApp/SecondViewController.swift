import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var shopList = [[String]]()
    
    @IBOutlet var shopListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        shopListTableView.delegate = self
        shopListTableView.dataSource = self
        shopList = UserDefaults.standard.value(forKey: "shopArray") as! [[String]]
        print(shopList)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = shopList[indexPath.row][0]
        cell.detailTextLabel?.text = shopList[indexPath.row][1]
        return cell
    }
    
    
    

 
}
