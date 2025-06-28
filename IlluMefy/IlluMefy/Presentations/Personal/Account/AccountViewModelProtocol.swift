//
//  AccountViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// アカウント画面の状態
enum AccountViewState: Equatable {
    case idle
    case loading
    case loaded(userInfo: UserInfo)
    case error(title: String, message: String)
}

/// ユーザー情報
struct UserInfo: Equatable {
    let phoneNumber: String
    let registrationDate: Date
    let userId: String
    
    /// 電話番号をマスク表示用にフォーマット
    var maskedPhoneNumber: String {
        if phoneNumber.count >= 4 {
            let prefix = String(phoneNumber.prefix(4))
            let suffix = String(phoneNumber.suffix(4))
            let masked = String(repeating: "x", count: max(0, phoneNumber.count - 8))
            return "\(prefix)\(masked)\(suffix)"
        }
        return phoneNumber
    }
    
    /// 登録日を表示用にフォーマット
    var formattedRegistrationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: registrationDate)
    }
}

/// アカウント画面ViewModelのプロトコル
@MainActor
protocol AccountViewModelProtocol: ObservableObject {
    /// 画面の状態
    var state: AccountViewState { get }
    
    /// アカウント削除処理中かどうか
    var isDeletingAccount: Bool { get }
    
    /// アカウント削除が成功したかどうか
    var deleteAccountSuccess: Bool { get }
    
    /// ユーザー情報を読み込む
    func loadUserInfo() async
    
    /// アカウント削除
    func deleteAccount() async
    
    /// アプリ情報画面への遷移
    func navigateToAppInfo()
    
    /// 利用規約をブラウザで開く
    func openTermsOfService()
    
    /// 準備中機能のアラート表示
    func showComingSoonAlert()
}
