
import Alamofire

let webserviceURL = "http://marce.emb.mx/beaconizer/webservice.php"


class Webservice {
  
  static func requestNotifications(lastNotificationId: String?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    var parameters: Parameters = [:]
    
    if lastNotificationId != nil {
      parameters.updateValue(lastNotificationId!, forKey: "lastNotificationId")
    }
    
    Alamofire.request(webserviceURL, parameters: parameters).responseJSON { response in
      switch response.result {
      case .success(let value):
        completionHandler(value as? NSDictionary, nil)
      case .failure(let error):
        completionHandler(nil, error as NSError?)
      }
    }
    
  }
}

