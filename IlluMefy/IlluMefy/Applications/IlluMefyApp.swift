//
//  IlluMefyApp.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/09.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    #if DEBUG
      if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
          FirebaseApp.configure()
      }
    #else
      FirebaseApp.configure()
    #endif
    
    // Push通知の登録
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    
    application.registerForRemoteNotifications()
    
    return true
  }
  
  // APNsトークンをFirebaseに登録
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Auth.auth().setAPNSToken(deviceToken, type: .unknown)
  }
  
  // リモート通知を受信（Firebase Phone Auth用）
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler(.noData)
      return
    }
    // その他の通知処理
    completionHandler(.noData)
  }
}

// UNUserNotificationCenterDelegateの実装
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    // Firebase Phone Authの通知かチェック
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler([])
      return
    }
    
    // その他の通知は表示
    completionHandler([[.banner, .badge, .sound]])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    // Firebase Phone Authの通知かチェック
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler()
      return
    }
    
    completionHandler()
  }
}

@main
struct IlluMefyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = IlluMefyAppRouter()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(router)
        }
    }
}
