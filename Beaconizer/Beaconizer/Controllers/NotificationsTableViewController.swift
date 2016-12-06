
import UIKit
import PKHUD


extension CGRect {
  init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
    self.init(x:x, y:y, width:w, height:h)
  }
}


class NotificationsTableViewController: UIViewController, UITableViewDataSource  {

  @IBOutlet weak var tableView: UITableView!
  var notifications: NSArray = []
  
  func requestNotifications() {
    
    HUD.show(.progress)
    
    
    // Solicitar las notificaciones especificando el ID de la última notificación,
    // y un completionHandler para procesar la respuesta o error cuando se complete la petición
    Webservice.requestNotifications(lastNotificationId: nil) { response, error in
      
      self.dismiss(animated: false, completion: nil)
      
      // Si el error NO es nil, se muestra una alerta y se da la opción al usuario de reintentar
      guard error == nil else {
        let alert = UIAlertController(title: "Error",
                                      message: error?.localizedDescription,
                                      preferredStyle: .alert)
        // Agregar un botón de reintentar que ejecuta este mismo método si se oprime
        alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: { action in
          self.requestNotifications()
        }))
        // Mostrar la alerta
        self.present(alert, animated: true, completion: nil)
        
        return
      }
      
      // Procesar las notificaciones recibidas
      let notifications = response?.value(forKey: "notifications") as! NSArray
      
      // Si no hay notificaciones
      print("OKOK")
      if notifications.count == 0 {
        print("No hay notificaciones nuevas")
      }
      
      NotificationStore.update(notifications: notifications)
      self.notifications = NotificationStore.getAll() ?? []
      self.tableView.reloadData()
      HUD.hide(afterDelay: 1.0)
    }
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Notificaciones"
    requestNotifications()
    notifications = NotificationStore.getAll() ?? []
  }
  
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notifications.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
   
    guard let notification = notifications.object(at: indexPath.row) as? NSDictionary else {
      return cell
    }
    debugPrint("Notificación para la fila \(indexPath.row): \(notification)")
    
    let notificationId = notification.object(forKey: "id") as! String
    let title = notification.object(forKey: "title") as! String
    
    cell.notificationId.text = notificationId
    cell.title.text = title
    
    if NotificationStore.notificationHasBeenRead(notificationId: notificationId) {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .disclosureIndicator
    }
    return cell
  }
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    debugPrint("OK")
    let backItem = UIBarButtonItem()
    backItem.title = "Atrás"
    navigationItem.backBarButtonItem = backItem
    segue.destination.title = (sender as! NotificationCell).title.text
  }
  
}
