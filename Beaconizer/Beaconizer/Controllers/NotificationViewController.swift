
import UIKit

class NotificationViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let readItem = UIBarButtonItem()
    readItem.style = .done
    readItem.title = "Leída"
    navigationItem.rightBarButtonItem = readItem
    // TODO: marcar elemento como leído
  }
  
}
