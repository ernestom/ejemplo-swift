
import UIKit
import UserNotifications


enum NotificationActions: String {
  case OpenApp = "openAppIdentifier"
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?

  let beaconManager = ESTBeaconManager()


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    UserDefaults.standard.removeObject(forKey: "notifications")
    // Fetch notifications
    UIApplication.shared.setMinimumBackgroundFetchInterval(10)
    
    // Solicitar permiso para mostrar notificaciones locales de sistema
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
      if error != nil {
        print("EL PERMISO DE ENVIAR NOTIFICACIONES LOCALES FUE DENEGADO!!!")
      }
    }
    
    let estimoteUUID = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
    let region = CLBeaconRegion(proximityUUID: estimoteUUID, identifier: "Región monitoreada")
    beaconManager.delegate = self
    beaconManager.requestAlwaysAuthorization()
    beaconManager.startMonitoring(for: region)
    return true
  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("Ejecutando background fetch...")
    // Obtenemos el controlador raíz
    if let rootViewController = window?.rootViewController {
      // Buscamos el controlador de tabla de notificaciones entre los controladores hijos del raíz
      for childVC in rootViewController.childViewControllers {
        // Si la asignación funciona, significa que childVC sí se identificó como
        // NotificationsTableViewController mediante el casting
        if let notificationsTableVC = childVC as? NotificationsTableViewController {
          notificationsTableVC.requestNotifications() {
            print("Notificaciones cargadas exitosamente desde background")
            // Avisar al OS que la carga regresó datos
            completionHandler(.newData)
            return
          }
        }
      }
    }
    completionHandler(.noData)
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  // MARK: - Estimote SDK
  
  func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
    print("Saliendo de la región!!")
  }
  
  func beaconManager(_ manager: Any, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
    print("CLRegionState \(state.rawValue) \(region.identifier)")
  }
  
  func beaconManager(_ manager: Any, didFailWithError error: Error) {
    print("ERROR: \(error)")
  }
  
  func beaconManager(_ manager: Any, monitoringDidFailFor region: CLBeaconRegion?, withError error: Error) {
    print("ERROR: \(error)")
  }
  
  func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
    print("Entrando en la región!!")
    let openAppAction = UNNotificationAction(identifier: NotificationActions.OpenApp.rawValue, title: "Abrir App", options: .foreground)
    let category = UNNotificationCategory(identifier: "Abrir App", actions: [openAppAction], intentIdentifiers: ["openApp"], options: .customDismissAction)
    UNUserNotificationCenter.current().setNotificationCategories([category])
    
    let openAppActionContent = UNMutableNotificationContent()
    openAppActionContent.title = "Hola!"
    openAppActionContent.body = "Ahora que estás cerca, entérate de las nuevas notificaciones disponibles"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
    
    let openAppRequestIdentifier = "openAppAction"
    let openAppRequest = UNNotificationRequest(identifier: openAppRequestIdentifier, content: openAppActionContent, trigger: trigger)
    UNUserNotificationCenter.current().add(openAppRequest) { (error) in
      print(error ?? "Todo bien al mostrar la notificación local")
    }
  }
  
  
  func beaconManager(_ manager: Any, didStartMonitoringFor region: CLBeaconRegion) {
    print("Monitoreo empezado")
  }
  
  func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {
    print("Cambio de autorización! \(status)")
  }
  
  // MARK: - User Notifications
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    switch response.actionIdentifier {
    case NotificationActions.OpenApp.rawValue:
      print("Abrir App!!!!")
    default:
      print("Otra notificación local... no es la nuestra")
    }
  }

}

