import UIKit

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

class ViewController: UIViewController, XMLParserDelegate {

    var check_title = [String]()
    var enclosure = [String]()
    var check_element = String()
    var product = Shop("", "", "", "", "", "","", "", "","", "", "", "", "","", "")
    var shopArray = [[String]]() //全ての合計
    var shopNameTestArray = [String]()//店名検証配列
    
    override func viewDidLoad() {

        let url: URL = URL(string:"https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=dd12dcd9670620eb&lat=34.67&lng=135.52&range=5&order=4")!

        //Debi's Kitchenテスト用URL(本来は記述しない)
       // let url: URL = URL(string:"https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=dd12dcd9670620eb&name_kana=%E3%83%87%E3%83%93%E3%82%BA%E3%82%AD%E3%83%83%E3%83%81%E3%83%B3")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if data != nil {
                let parser: XMLParser? = XMLParser(data: data!)
                parser!.delegate = self
                parser!.parse()
            }else{
                //インターネットエラーを出力
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
                if shopNameTestArray.count > 10 {
                    let valid = shopNameTestArray.count - 10
                    print("valid：" + String(valid))
                    for i in 0...valid{
                        if i != 0{
                            shopNameTestArray[0] =  shopNameTestArray[0] + " " + shopNameTestArray[i]
                            shopNameTestArray.remove(at: i)
                        }
                    }
                }
                
                shopArray.append([shopNameTestArray[0], shopNameTestArray[6], shopNameTestArray[7], product.shopMobileImage!, product.shopLatitude!, product.shopLongitude!, product.shopAddress!, product.shopOpeningTime!, product.shopMobileAccess!, product.shopClosingTime!, shopNameTestArray[8], product.shopCapacity!, product.shopWebsiteUrl!, product.shopid!, "",])
                //閉店時間，予算，収容人数，キャッツ，Web，id，電話番号
                shopNameTestArray.removeAll()
                print(shopArray)
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

        print("Ended Xml Reading")
    }
    
    //解析_エラー発生時
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:" + parseError.localizedDescription)
    }

    @IBAction func goNext(){
        UserDefaults.standard.set(shopArray, forKey: "shopArray")
        UserDefaults.standard.synchronize()
    }
    
}
