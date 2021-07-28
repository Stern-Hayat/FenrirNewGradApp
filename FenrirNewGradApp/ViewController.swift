import UIKit

// プロトコル
protocol getShopNameProtocol{
    func showName()
}
// 構造体
struct Shop: getShopNameProtocol{
    var shopName:String?
    var shopLogoImage: String?
    var shopAddress: String?
    var shopStationName: String?
    var shopLatitude: String?
    var shopLongitude: String?
    var shopGenreName: String?
    var shopSubGenreName: String?
    var shopOpeningTime: String?


    init(_ shopName:String?, _ shopLogoImage:String?, _ shopAddress: String?, _ shopStationName: String?, _ shopLatitude: String?, _ shopLongitude: String?, _ shopGenreName: String?, _ shopSubGenreName: String?, _ shopOpeningTime: String?){
        self.shopName = shopName
        self.shopLogoImage = shopLogoImage
        self.shopAddress = shopAddress
        self.shopStationName = shopStationName
        self.shopLatitude = shopLatitude
        self.shopLongitude = shopLongitude
        self.shopGenreName = shopGenreName
        self.shopOpeningTime = shopOpeningTime
        self.shopSubGenreName = shopSubGenreName
    }

    func showName(){
        // guardを利用したオプショナルバインディング
        // （オプショナル型のデータをアンラップする）
        guard let unwrappedName = self.shopName else{
            return
        }
        
        guard let unwrappedLogoImage = self.shopLogoImage else{
            return
        }

        guard let unwrappedAddress = self.shopAddress else{
            return
        }

        guard let unwrappedStationName = self.shopStationName else{
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
    }
}

class ViewController: UIViewController, XMLParserDelegate {

    var check_title = [String]()
    var enclosure = [String]()
    var check_element = String()
    var x = 0
    var i = 0
    var n = 1

    var product = Shop("", "", "", "", "", "","", "", "")
    var shopArray = [[String]]() //全ての合計
    var shopNameArray = [String]() //店名
    var shopNameTestArray = [String]()
    var shopDetailNameArray = [String]() //その他
    
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

        //各行の<>タグの中身を読み取ってくれるすごい関数
        if elementName == "enclosure" {
            enclosure.append(attributeDict["url"]!)
            //print(enclosure)
        }
        
        //print(check_element)
        check_element = elementName
        
    }
    

    //解析_要素内の値取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
    
            //print(string)
            switch check_element {
            case "name":
                print("name" + String(n) + "：" + string)
                n = n + 1
                
                shopNameTestArray.append(string)
//                if UserDefaults.standard.bool(forKey: "didShopNameEnd") == true {
//                    shopDetailNameArray.append(string)
//                }else{
//                    shopNameArray.append(string)
//                }
//
    
            //2番目
            case "logo_image":
                product.shopLogoImage = string
//                UserDefaults.standard.setValue(true, forKey: "didShopNameEnd")
//                UserDefaults.standard.synchronize()
                //print(string)
           //3番目
            case "address":
                product.shopAddress = string
                //print(string)
           //4番目
            case "station_name":
                product.shopStationName = string
                //print(string)
            //5/6番目
            case "lat":
                product.shopLatitude = string
                //print(string)
            case "lng":
                product.shopLongitude = string
               // print(string)
            //9番目
            case "open":
                product.shopOpeningTime = string
                
                if shopNameTestArray.count > 10 {
                    let valid = shopNameTestArray.count - 10
                    print("valid：" + String(valid))
                    for i in 0...valid{
                        if i != 0{
                            shopNameTestArray[0] =  shopNameTestArray[0] + " " + shopNameTestArray[i]
                            print(shopNameTestArray)
                        }
                    }
                    shopNameArray.append(shopNameTestArray[0])
                } else {
                    shopNameArray.append(shopNameTestArray[0])
                }
                
                shopNameTestArray.removeAll()
                
                //print(string)
                shopArray.append([product.shopName!, product.shopGenreName!, product.shopSubGenreName!, product.shopLogoImage!, product.shopLatitude!, product.shopLongitude!, product.shopAddress!, product.shopOpeningTime!, product.shopStationName!])
                print("================================")
//                UserDefaults.standard.setValue(false, forKey: "didShopNameEnd")
//                UserDefaults.standard.synchronize()
            

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
        
    
        //店名に特殊文字が含まれており改行された場合に、一つの単語に繋げるための処理
        //print(shopArray)
        for j in 0..<shopNameArray.count {
            if shopNameArray[j] != nil {
                switch shopNameArray[j] {
                case "\'":
                    shopNameArray[j] = shopNameArray[j-1] + "\'" + shopNameArray[j+1]
                    shopNameArray[j-1] = " "
                    shopNameArray[j+1] = " "
                case "&":
                    shopNameArray[j] = shopNameArray[j-1] + "&" + shopNameArray[j+1]
                    shopNameArray[j-1] = " "
                    shopNameArray[j+1] = " "
                case " ":
                    shopNameArray[j] = shopNameArray[j-1] + " " + shopNameArray[j+1]
                    shopNameArray[j-1] = " "
                    shopNameArray[j+1] = " "
                default:
                    break
                }
            }
        }
        shopNameArray.removeAll(where: {$0 == " "})

        //配列にアペンドする
        for i in 0..<shopDetailNameArray.count {
            if i % 9 == 4 {
            }else if i % 9 == 5 {
                shopArray[x][1].append(shopDetailNameArray[i])
            }else if i % 9 == 6 {
                shopArray[x][2].append(shopDetailNameArray[i])
            }else if i % 9 == 0 && i / 9 >= 1{
                x = x + 1
            }
        }
        
        

        print(shopNameArray)
        
        for i in 0..<shopNameArray.count{
            if i < shopArray.count {
                shopArray[i][0].append(shopNameArray[i])
            } else {
                return
            }
        }

        

        //
        
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
