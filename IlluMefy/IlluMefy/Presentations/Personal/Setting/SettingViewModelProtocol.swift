//
//  SettingViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 設定画面の状態
enum SettingViewState: Equatable {
    case idle
    case loading
    case loaded(operatorMessage: OperatorMessage?)
    case error(title: String, message: String)
}

/// 設定画面ViewModelのプロトコル
@MainActor
protocol SettingViewModelProtocol: ObservableObject {
    /// 画面の状態
    var state: SettingViewState { get }
    
    /// ログアウト処理中かどうか
    var isLoggingOut: Bool { get }
    
    /// ログアウト成功フラグ
    var logoutSuccess: Bool { get }
    
    /// 運営メッセージを読み込む
    func loadOperatorMessage() async
    
    /// 通知設定画面への遷移
    func navigateToNotificationSettings()
    
    /// 利用規約をブラウザで開く
    func openTermsOfService()
    
    /// アプリ情報画面への遷移
    func navigateToAppInfo()
    
    /// サポート・お問い合わせ画面への遷移
    func navigateToContactSupport()
    
    /// 準備中機能のアラート表示
    func showComingSoonAlert()
    
    /// ログアウト処理
    func logout() async
}