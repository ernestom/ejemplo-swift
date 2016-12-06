
import UIKit

class NotificationViewController: UIViewController {
  
  var notificationId: String? = nil
  var notificationHasBeenRead: Bool = false
  var readItem: UIBarButtonItem? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard notificationId != nil else {
      print("notificationId debe estar definido!!!")
      return
    }
    
    notificationHasBeenRead = NotificationStore.notificationHasBeenRead(notificationId: notificationId!)
    let title = notificationHasBeenRead ? "No leída" : "Leída"
    
    readItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(toggleNotificationAsRead))
    navigationItem.rightBarButtonItem = readItem
  }
  
  func toggleNotificationAsRead() {
    print("toggle")
    var success = false
    if notificationHasBeenRead {
      notificationHasBeenRead = false
      readItem?.title = "Leída"
      success = NotificationStore.markNotificationAsUnread(notificationId: notificationId!)
    } else {
      notificationHasBeenRead = true
      readItem?.title = "No leída"
      success = NotificationStore.markNotificationAsRead(notificationId: notificationId!)
    }
    print("Notificación \(notificationId!) marcada como (no)leída con éxito? \(success ? "sí" : "no" )")
  }
  
}
