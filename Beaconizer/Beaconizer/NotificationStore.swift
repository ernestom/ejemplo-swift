
import Foundation


class NotificationStore {
  
  private static func printTotalExistingNotifications() {
    let store = UserDefaults.standard
    let count = store.array(forKey: "notifications")?.count
    print("Notificaciones encontradas localmente: \(count ?? 0)")
  }
  
  static func getAll() -> NSArray? {
    return UserDefaults.standard.array(forKey: "notifications") as NSArray?
  }
  
  static func update(notifications: NSArray?) {
    // "Asegúrate de que notifications NO sea nil, de lo contrario, si es nil,
    // imprime el mensaje y para la función."
    guard notifications != nil else {
      print("No hay notificaciones a procesar")
      return
    }
    
    printTotalExistingNotifications()
    
    // Obtenemos una instancia del almacén de datos
    let store = UserDefaults.standard
    // Obtenemos la lista de notificaciones como arreglo mutable
    let existingNotifications = store.mutableArrayValue(forKey: "notifications")
    
    // Iteramos sobre las notificaciones recibidas del webservice y ...
    for notification in notifications! {
      // vemos si la notificación ya existe,
      // en cuyo caso interrumpimos el loop y pasamos a la siguiente
      if existingNotifications.contains(notification) {
        // Ya existe
        print("La notificación \((notification as! NSDictionary)["id"]!) ya existe")
        continue
      }
      // Si no existe, la agregamos a la lista
      existingNotifications.add(notification)
    }
    
    // Guardamos la lista en la base de datos
    store.setValue(existingNotifications.copy(), forKey: "notifications")
    let syncSucceeded = store.synchronize()
    print("Sync exitoso? \(syncSucceeded)")
    
    printTotalExistingNotifications()
  }
  
  static func notificationHasBeenRead(notificationId: String) -> Bool {
    let store = UserDefaults.standard
    let readNotifications = store.array(forKey: "readNotifications") as? [String]
    if readNotifications == nil || readNotifications!.count == 0 {
      return false
    }
    return readNotifications!.contains(notificationId)
  }
  
  static func markNotificationAsRead(notificationId: String) -> Bool {
    let store = UserDefaults.standard
    let readNotifications = store.mutableArrayValue(forKey: "readNotifications")
    if !readNotifications.contains(notificationId) {
      readNotifications.add(notificationId)
    } else {
      print("La notificación ya estaba marcada como leída")
    }
    store.setValue(readNotifications.copy(), forKey: "readNotifications")
    let syncSucceeded = store.synchronize()
    return syncSucceeded
  }
  
  static func markNotificationAsUnread(notificationId: String) -> Bool {
    let store = UserDefaults.standard
    let readNotifications = store.mutableArrayValue(forKey: "readNotifications")
    if readNotifications.contains(notificationId) {
      readNotifications.remove(notificationId)
    } else {
      print("La notificación no estaba marcada como leída")
    }
    store.setValue(readNotifications.copy(), forKey: "readNotifications")
    let syncSucceeded = store.synchronize()
    return syncSucceeded
  }
}
