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

    func showName(){
        // guardを利用したオプショナルバインディング（オプショナル型のデータをアンラップする）
        
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

extension UIColor {
    static let startColor = #colorLiteral(red: 0, green: 0.1107608194, blue: 1, alpha: 1)
    static let endColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
}

//ud

class ViewController: UIViewController, XMLParserDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    var check_title = [String]()
    var enclosure = [String]()
    var check_element = String()
    var product = Shop("", "", "", "", "", "","", "", "","", "", "", "", "","", "")
    var shopArray = [[String]]() //全ての合計
    var shopNameTestArray = [String]()//店名検証配列
    var range: Int!
    
    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var locationManager: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var my_latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var my_longitude: CLLocationDegrees!
    
    @IBOutlet var goSearchButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var pickerView = UIPickerView()
    var data = ["300m", "500m", "1000m", "2000m", "3000m"]
    
    override func viewDidLoad() {

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        createPickerView()
            
        // 角丸で親しみやすく
        goSearchButton.layer.cornerRadius = goSearchButton.bounds.midY
        // 押せそうにみえる影
        goSearchButton.layer.shadowColor = UIColor.startColor.cgColor
        goSearchButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        goSearchButton.layer.shadowOpacity = 0.7
        goSearchButton.layer.shadowRadius = 10
        
        // グラデーションで強めのアピール (リサイズ非対応！）
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = goSearchButton.bounds
        gradientLayer.cornerRadius = goSearchButton.bounds.midY
        gradientLayer.colors = [UIColor.startColor.cgColor, UIColor.endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        goSearchButton.layer.insertSublayer(gradientLayer, at: 0)

    }
    
    @IBAction func pushedSearchButton(){
        
        
        let searchDistance = UserDefaults.standard.value(forKey: "saveSearchFieldDistance") as? String
    
            switch searchDistance {
                case "300m":
                    range = 1
                case "500m":
                    range = 2
                case "1000m":
                    range = 3
                case "2000m":
                    range = 4
                case "3000m":
                    range = 5
                default:
                    break
            }
        
            //To-do：環境変数にキーを保存しておく
            let url: URL = URL(string:"https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=dd12dcd9670620eb&lat=" + String(my_latitude) + "&lng=" + String(my_longitude) + "&range=" + String(range) + "&order=4")!
            
            print(url)
        
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if data != nil {
                    let parser: XMLParser? = XMLParser(data: data!)
                    parser!.delegate = self
                    parser!.parse()
                    print("parse finished")
                }else{
                    //インターネットエラーを出力
                    print("parse error")
                }
            })
            //タスク開始
            task.resume()
    }
    
    //解析_開始時
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Started xml Reading")

    }

    //解析_要素の開始時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

        if elementName == "enclosure" {
            enclosure.append(attributeDict["url"]!)
        }
        
        check_element = elementName
        
    }
    

    //解析_要素内の値取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
    
            //print(string)
            switch check_element {
            
            case "id":
                product.shopid = string
                
            case "name":
                shopNameTestArray.append(string)

            case "address":
                product.shopAddress = string

            case "capacity":
                product.shopCapacity = string
                
            case "mobile_access":
                product.shopMobileAccess = string

            case "lat":
                product.shopLatitude = string
                
            case "lng":
                product.shopLongitude = string
                
            case "pc":
                if UserDefaults.standard.bool(forKey: "skipCouponPcUrl") == true {
                    UserDefaults.standard.setValue(false, forKey: "skipCouponPcUrl")
                } else {
                    product.shopWebsiteUrl = string
                    UserDefaults.standard.setValue(true, forKey: "skipCouponPcUrl")
                }
                UserDefaults.standard.synchronize()

            case "open":
                product.shopOpeningTime = string
                
            case "close":
                product.shopClosingTime = string
              
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
                
                if shopNameTestArray.count != 0 {
                    shopArray.append([shopNameTestArray[0], shopNameTestArray[6], shopNameTestArray[7], product.shopMobileImage!, product.shopLatitude!, product.shopLongitude!, product.shopAddress!, product.shopOpeningTime!, product.shopMobileAccess!, product.shopClosingTime!, shopNameTestArray[8], product.shopCapacity!, product.shopWebsiteUrl!, product.shopid!, "",])
                }
                //閉店時間，予算，収容人数，キャッツ，Web，id，電話番号
                shopNameTestArray.removeAll()
                print("================================")
                
            case "s":
                product.shopMobileImage = string
                
            default:
                break
            }
           
            product.showName()
        }
    

    //解析_要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }

    //解析_終了時
    func parserDidEndDocument(_ parser: XMLParser) {
        UserDefaults.standard.set(shopArray, forKey: "shopArray")
        UserDefaults.standard.synchronize()

        DispatchQueue.main.async {
            print("presentation completed")
            self.performSegue(withIdentifier: "goShopListSegue", sender: nil)
        }
        print("Ended Xml Reading")
    }
    
    //解析_エラー発生時
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
        textField.text = data[row]
    }

    func createPickerView() {
        pickerView.delegate = self
        textField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        textField.inputAccessoryView = toolbar
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
        textField.endEditing(true)
        UserDefaults.standard.set(textField.text, forKey: "saveSearchFieldDistance")
        UserDefaults.standard.synchronize()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.endEditing(true)
        UserDefaults.standard.set(textField.text, forKey: "saveSearchFieldDistance")
        UserDefaults.standard.synchronize()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        my_latitude = locationManager.location?.coordinate.latitude
        my_longitude = locationManager.location?.coordinate.longitude
    }
    
}
