//
//  SettingViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation
import UIKit
import FirebaseAuth

/// 設定画面のViewModel
@MainActor
final class SettingViewModel: SettingViewModelProtocol {
    
    // MARK: - Published Properties
    @Published var state: SettingViewState = .idle
    @Published var isLoggingOut: Bool = false
    @Published var logoutSuccess: Bool = false
    
    // MARK: - Use Cases
    private let getOperatorMessageUseCase: GetOperatorMessageUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol
    
    // MARK: - Initialization
    init(getOperatorMessageUseCase: GetOperatorMessageUseCaseProtocol, logoutUseCase: LogoutUseCaseProtocol) {
        self.getOperatorMessageUseCase = getOperatorMessageUseCase
        self.logoutUseCase = logoutUseCase
    }
    
    // MARK: - SettingViewModelProtocol
    
    func loadOperatorMessage() async {
        // キャッシュからすぐに取得（ローディング状態を挟まない）
        let cachedMessage = getOperatorMessageUseCase.getCachedOperatorMessage()
        state = .loaded(operatorMessage: cachedMessage)
    }
    
    func navigateToNotificationSettings() {
        // 今後実装予定：通知設定画面への遷移
        showComingSoonAlert()
    }
    
    func openTermsOfService() {
        // 利用規約のURL（アカウント画面と同じものを使用）
        if let url = URL(string: "https://lying-rate-213.notion.site/IlluMefy-1fee5e0485cb80208497c1f1cca7e10b") {
            UIApplication.shared.open(url)
        }
    }
    
    func navigateToAppInfo() {
        // 今後実装予定：アプリ情報画面への遷移
        showComingSoonAlert()
    }
    
    func navigateToContactSupport() {
        // 今後実装予定：サポート画面への遷移
        showComingSoonAlert()
    }
    
    func showComingSoonAlert() {
        // アラート表示は親Viewで処理
        print("準備中の機能です")
    }
    
    func logout() async {
        isLoggingOut = true
        
        do {
            try await logoutUseCase.execute()
            logoutSuccess = true
        } catch {
            // エラーハンドリング - 現在はコンソール出力のみ
            print("ログアウトエラー: \(error.localizedDescription)")
        }
        
        isLoggingOut = false
    }
}