import UIKit
import CoreLocation


// プロトコル
protocol getShopNameProtocol{
    func showName()
}
// 構造体
struct Shop: getShopNameProtocol{
    var shopName:String?
    var shopMobileImage: String?
    var shopAddress: String?
    var shopMobileAccess: String?
    var shopLatitude: String?
    var shopLongitude: String?
    var shopGenreName: String?
    var shopSubGenreName: String?
    var shopOpeningTime: String?
    
    var shopClosingTime: String?
    var shopBudgetAmount: String?
    var shopCapacity: String?
    var shopCatchStatement: String?
    var shopWebsiteUrl: String?
    var shopid: String?
    var shopTelephoneNumber: String?
    //初期化
    init(_ shopName:String?, _ shopMobileImage:String?, _ shopAddress: String?, _ shopMobileAccess: String?, _ shopLatitude: String?, _ shopLongitude: String?, _ shopGenreName: String?, _ shopSubGenreName: String?, _ shopOpeningTime: String?, _ shopClosingTime: String?, _ shopBudgetAmount: String?, _ shopCapacity: String?, _ shopCatchStatement: String?, _ shopWebsiteUrl: String?, _ shopid: String?, _ shopTelephoneNumber: String?){
        self.shopName = shopName
        self.shopMobileImage = shopMobileImage
        self.shopAddress = shopAddress
        self.shopMobileAccess = shopMobileAccess
        self.shopLatitude = shopLatitude
        self.shopLongitude = shopLongitude
        self.shopGenreName = shopGenreName
        self.shopOpeningTime = shopOpeningTime
        self.shopSubGenreName = shopSubGenreName
        
        self.shopClosingTime = shopClosingTime
        self.shopBudgetAmount = shopBudgetAmount
        self.shopCapacity = shopCapacity
        self.shopCatchStatement = shopCatchStatement
        self.shopWebsiteUrl = shopWebsiteUrl
        self.shopid = shopid
        self.shopTelephoneNumber = shopTelephoneNumber
    }

    //オプショナルバインディング
    func showName(){
        guard let unwrappedName = self.shopName else{
            return
        }
        
        guard let unwrappedLogoImage = self.shopMobileImage else{
            return
        }

        guard let unwrappedAddress = self.shopAddress else{
            return
        }

        guard let unwrappedMobileAccess = self.shopMobileAccess else{
            return
        }
        
        guard let unwrappedLatitude = self.shopLatitude else{
            return
        }

        guard let unwrappedLongitude = self.shopLongitude else{
            return
        }
        
        guard let unwrappedShopSubGenreName = self.shopSubGenreName else{
            return
        }
        
        guard let unwrappedShopGenreName = self.shopGenreName else{
            return
        }

        guard let unwrappedShopOpeningTime = self.shopOpeningTime else{
            return
        }
        
        guard let unwrappedCatchStatement = self.shopCatchStatement else{
            return
        }
        
        guard let unwrappedWebSiteUrl = self.shopWebsiteUrl else{
            return
        }
        
        guard let unwrappedid = self.shopid else{
            return
        }
        
        guard let unwrappedTelephoneNumber = self.shopTelephoneNumber else{
            return
        }
        
        
        guard let unwrappedClosingTime = self.shopClosingTime else{
            return
        }
        
        guard let unwrappedBudgetAmount = self.shopBudgetAmount else{
            return
        }
        
        guard let unwrappedCapacity = self.shopCapacity else{
            return
        }
    }
}
//ボタンの色決め
extension UIColor {
    static let startColor = #colorLiteral(red: 0, green: 0.1107608194, blue: 1, alpha: 1)
    static let endColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
}

class ViewController: UIViewController, XMLParserDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    //XML関係
    var check_title = [String]()
    var enclosure = [String]()
    var check_element = String()
    //使用する配列
    var product = Shop("", "", "", "", "", "","", "", "","", "", "", "", "","", "")//レストラン構造体
    var shopArray = [[String]]() //レストラン店舗データ
    var shopNameTestArray = [String]()//elnclosure:<name>用検証配列
    //CLLocationManager関係
    var locationManager: CLLocationManager!
    var my_latitude: CLLocationDegrees!
    var my_longitude: CLLocationDegrees!
    //検索関係
    @IBOutlet var goSearchButton: UIButton! //検索ボタン
    @IBOutlet weak var searchForTextField: UITextField! //検索用入力欄
    var pickerView = UIPickerView()
    var data = ["300m", "500m", "1000m", "2000m", "3000m"] //検索picker用配列

    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        //CLLocationManager関係
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //PickerViewを作成
        createPickerView()
        //検索ボタンの装飾
        goSearchButton.layer.cornerRadius = goSearchButton.bounds.midY
        goSearchButton.layer.shadowColor = UIColor.startColor.cgColor
        goSearchButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        goSearchButton.layer.shadowOpacity = 0.7
        goSearchButton.layer.shadowRadius = 10
        //検索ボタンのグラデーション
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = goSearchButton.bounds
        gradientLayer.cornerRadius = goSearchButton.bounds.midY
        gradientLayer.colors = [UIColor.startColor.cgColor, UIColor.endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        goSearchButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func pushedSearchButton(){
        //検索配列の初期化
        if ud.value(forKey: "shopArray") != nil {
            shopArray.removeAll()
            ud.set(nil, forKey: "shopArray")
            ud.synchronize()
        }
        //検索文字列による条件分岐
        let searchDistance = ud.value(forKey: "saveSearchFieldDistance") as? String
            switch searchDistance {
                case "300m":
                    searchShopData(range: 1)
                case "500m":
                    searchShopData(range: 2)
                case "1000m":
                    searchShopData(range: 3)
                case "2000m":
                    searchShopData(range: 4)
                case "3000m":
                    searchShopData(range: 5)
                default:
                    let alert: UIAlertController = UIAlertController(title: "エラー", message: "検索範囲を指定してください", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:{(action: UIAlertAction!) -> Void in
                        return;
                    })
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
            }
    }
    
    //検索関数
    func searchShopData(range: Int){
        //補足：本来であればAPIキーは環境変数に保存するのが通例ですが，今回は便宜上ソースファイルに直書きしています。
        //let env = ProcessInfo.processInfo.environment
        //if let value = env["APIKey"] {
            let url: URL = URL(string:"https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=" + "dd12dcd9670620eb" + "&lat=" + String(my_latitude) + "&lng=" + String(my_longitude) + "&range=" + String(range) + "&order=4")!
            print(url)
        
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if data != nil {
                    let parser: XMLParser? = XMLParser(data: data!)
                    parser!.delegate = self
                    parser!.parse()
                    print("parse finished")
                }else{
                    print("parse error")
                }
            })
            task.resume()
        //} else {
        //    print("APIKey error")
        //}
        
        ud.set(nil, forKey: "saveSearchFieldDistance")
        ud.synchronize()
    }
    
    //解析開始時
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Started xml Reading")

    }

    //解析要素の開始時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "enclosure" {
            enclosure.append(attributeDict["url"]!)
        }
        check_element = elementName
    }
    

    //解析要素内の値取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
            switch check_element {
                //idの抽出
                case "id":
                    product.shopid = string
                //<name>の抽出
                case "name":
                    if string != nil {
                        shopNameTestArray.append(string)
                    } else {
                        //未設定なら「未設定」を格納
                        shopNameTestArray.append("未設定")
                    }
                //住所の抽出
                case "address":
                    product.shopAddress = string
                //座席人数の抽出
                case "capacity":
                    product.shopCapacity = string
                //モバイル用アクセス情報の抽出
                case "mobile_access":
                    product.shopMobileAccess = string
                //緯度の抽出
                case "lat":
                    product.shopLatitude = string
                //軽度の抽出
                case "lng":
                    product.shopLongitude = string
                //URLの抽出
                case "pc":
                    //クーポン用URLも同じenclosureなので除外するためにif条件分岐
                    if ud.bool(forKey: "skipCouponPcUrl") == true {
                        ud.setValue(false, forKey: "skipCouponPcUrl")
                    } else {
                        product.shopWebsiteUrl = string
                        ud.setValue(true, forKey: "skipCouponPcUrl")
                    }
                    ud.synchronize()
                //開店日情報
                case "open":
                    product.shopOpeningTime = string
                //閉店日情報
                case "close":
                    product.shopClosingTime = string
                //画像の抽出
                case "l":
                    product.shopMobileImage = string
                    print("shopnameArray:" + String(shopNameTestArray.count))
                    //店名改行バグへの対応
                    if shopNameTestArray.count > 9 {
                        let valid = shopNameTestArray.count - 9
                        print("valid：" + String(valid))
                        for i in 0...valid{
                            if i != 0{
                                shopNameTestArray[0] =  shopNameTestArray[0] + " " + shopNameTestArray[1]
                                shopNameTestArray.remove(at: 1)
                            }
                        }
                    }
                    //パラメーター未設定バグへの対応
                    if shopNameTestArray.count < 9 && shopNameTestArray.count != 0{
                        let valid = 9 - shopNameTestArray.count
                        for i in 0...valid{
                            if i != 0{
                                print("i=" + String(i))
                                shopNameTestArray.append("未設定")
                            }
                        }
                    } else if shopNameTestArray.count == 0 {
                        //do nothing
                    }
                    
                    //配列に格納
                    if shopNameTestArray.count != 0 {
                        print(shopNameTestArray)
                        shopArray.append([shopNameTestArray[0], shopNameTestArray[6], shopNameTestArray[7], product.shopMobileImage!, product.shopLatitude!, product.shopLongitude!, product.shopAddress!, product.shopOpeningTime!, product.shopMobileAccess!, product.shopClosingTime!, shopNameTestArray[8], product.shopCapacity!, product.shopWebsiteUrl!, product.shopid!, "",])
                    }
                    //閉店時間，予算，収容人数，キャッツ，Web，id，電話番号
                    shopNameTestArray.removeAll()
                    print("================================")
                default:
                    break
                }
            product.showName()
        }
    

    //解析要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }

    //解析終了時
    func parserDidEndDocument(_ parser: XMLParser) {
        if shopArray.count != 0 {
            ud.set(shopArray, forKey: "shopArray")
            ud.synchronize()
        }
        DispatchQueue.main.async {
            print("presentation completed")
            self.performSegue(withIdentifier: "goShopListSegue", sender: nil)
        }
        print("Ended Xml Reading")
    }
    
    //解析エラー発生時
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:" + parseError.localizedDescription)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchForTextField.text = data[row]
    }
    
    //PickerViewのコード
    func createPickerView() {
        pickerView.delegate = self
        searchForTextField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        searchForTextField.inputAccessoryView = toolbar
    }
    
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
                case .notDetermined:// 許可されてない場合
                    manager.requestWhenInUseAuthorization()// 許可を求める
                    my_latitude = locationManager.location?.coordinate.latitude
                    my_longitude = locationManager.location?.coordinate.longitude
                case .restricted, .denied:// 拒否されてる場合
                    my_latitude = locationManager.location?.coordinate.latitude
                    my_longitude = locationManager.location?.coordinate.longitude
                    break// 何もしない
                case .authorizedAlways, .authorizedWhenInUse: // 許可されている場合
                    manager.startUpdatingLocation()// 現在地の取得を開始
                    my_latitude = locationManager.location?.coordinate.latitude
                    my_longitude = locationManager.location?.coordinate.longitude
                    break
                default:
                    break
            }
        }

    @objc func donePicker() {
        searchForTextField.endEditing(true)
        ud.set(searchForTextField.text, forKey: "saveSearchFieldDistance")
        ud.synchronize()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchForTextField.endEditing(true)
        ud.set(searchForTextField.text, forKey: "saveSearchFieldDistance")
        ud.synchronize()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        my_latitude = locationManager.location?.coordinate.latitude
        my_longitude = locationManager.location?.coordinate.longitude
    }
    
}
