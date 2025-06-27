//
//  AccountViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation
import FirebaseAuth
import UIKit

/// アカウント画面のViewModel
@MainActor
final class AccountViewModel: AccountViewModelProtocol {
    
    // MARK: - Published Properties
    @Published var state: AccountViewState = .idle
    
    // MARK: - Initialization
    init() {
        // RouterはEnvironmentObjectで管理されるため、ここでは不要
    }
    
    // MARK: - AccountViewModelProtocol
    
    func loadUserInfo() async {
        state = .loading
        
        do {
            guard let currentUser = Auth.auth().currentUser else {
                state = .error(
                    title: L10n.authenticationRequired,
                    message: L10n.pleaseLoginAgain
                )
                return
            }
            
            let userInfo = UserInfo(
                phoneNumber: currentUser.phoneNumber ?? L10n.unknown,
                registrationDate: currentUser.metadata.creationDate ?? Date(),
                userId: currentUser.uid
            )
            
            state = .loaded(userInfo: userInfo)
            
        } catch {
            state = .error(
                title: L10n.loadingFailed,
                message: L10n.tryAgainLater
            )
        }
    }
    
    func navigateToFavorites() {
        // タブ切り替えは親のHomeBaseViewで処理されるため、
        // ここでは特別な処理は不要（タップ自体でタブが切り替わる）
        print("お気に入り画面への遷移")
    }
    
    func navigateToAppInfo() {
        // 今後実装予定：アプリ情報画面への遷移
        showComingSoonAlert()
    }
    
    func openTermsOfService() {
        // 利用規約のURL（電話番号登録画面と同じものを使用）
        if let url = URL(string: "https://lying-rate-213.notion.site/IlluMefy-1fee5e0485cb80208497c1f1cca7e10b") {
            UIApplication.shared.open(url)
        }
    }
    
    func showComingSoonAlert() {
        // TODO: アラート表示の実装
        print("準備中の機能です")
    }
}