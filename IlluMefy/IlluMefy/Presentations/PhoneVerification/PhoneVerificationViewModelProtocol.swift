//
//  PhoneVerificationViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//

import Foundation

/// 電話番号認証画面のViewModelプロトコル
@MainActor
protocol PhoneVerificationViewModelProtocol: ObservableObject {
    // MARK: - Properties
    
    /// 認証番号の入力値
    var verificationCode: String { get set }
    
    /// エラーダイアログの表示フラグ
    var isShowErrorDialog: Bool { get set }
    
    /// エラーダイアログメッセージ
    var errorDialogMessage: String { get set }
    
    /// 成功ダイアログの表示フラグ
    var isShowNotificationDialog: Bool { get set }
    
    /// 成功ダイアログメッセージ
    var notificationDialogMessage: String { get set }
    
    /// ローディング状態
    var isLoading: Bool { get set }
    
    /// 認証番号再送信のクールダウン秒数
    var resendCooldownSeconds: Int { get set }
    
    /// 登録ボタンの有効/無効状態
    var isRegisterButtonEnabled: Bool { get }
    
    /// 再送信ボタンの有効/無効状態
    var isResendButtonEnabled: Bool { get }
    
    // MARK: - Methods
    
    /// アカウント登録処理
    func registerAccount() async
    
    /// 認証番号再送信処理
    func resendVerificationCode() async
}
