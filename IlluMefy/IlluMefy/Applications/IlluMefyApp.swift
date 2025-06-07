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
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    #if DEBUG
      if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" &&
         ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
          FirebaseApp.configure()
      }
    #else
      FirebaseApp.configure()
    #endif
    
    // Firebase Phone Auth用の最小限の通知設定
    // テスト実行中またはプレビュー実行中は設定をスキップ
    guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil &&
          ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { 
      return true 
    }
    
    // Firebase Phone Auth用の通知設定
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()
    
    return true
  }
  
  // APNsトークンをFirebaseに登録
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // テスト実行中またはプレビュー実行中はFirebaseの呼び出しをスキップ
    guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil &&
          ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { return }
    
    // Firebase Phone Auth用にAPNsトークンを登録
    Auth.auth().setAPNSToken(deviceToken, type: .unknown)
  }
  
  // リモート通知を受信（Firebase Phone Auth専用）
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // テスト実行中またはプレビュー実行中はFirebaseの呼び出しをスキップ
    guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil &&
          ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { 
      completionHandler(.noData)
      return 
    }
    
    // Firebase Phone Authの通知のみ処理
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler(.noData)
      return
    }
    
    // その他の通知は処理しない
    completionHandler(.noData)
  }
}

// Firebase Phone Auth専用のUNUserNotificationCenterDelegate実装
extension AppDelegate: UNUserNotificationCenterDelegate {
  nonisolated func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // Firebase Phone Auth以外の通知は表示しない
    completionHandler([])
  }
  
  nonisolated func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
    // 通知タップ時の処理（Firebase Phone Authでは不要）
    completionHandler()
  }
}

@main
struct IlluMefyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = IlluMefyAppRouter()
    var body: some Scene {
        WindowGroup {
            ParentView().environmentObject(router)
        }
    }
}
