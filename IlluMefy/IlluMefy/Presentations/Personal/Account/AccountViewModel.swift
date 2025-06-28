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
    @Published var isDeletingAccount = false
    @Published var deleteAccountSuccess = false
    
    // MARK: - Private Properties
    private let deleteAccountUseCase: DeleteAccountUseCaseProtocol
    
    // MARK: - Initialization
    init(deleteAccountUseCase: DeleteAccountUseCaseProtocol) {
        self.deleteAccountUseCase = deleteAccountUseCase
    }
    
    // MARK: - AccountViewModelProtocol
    
    func loadUserInfo() async {
        state = .loading
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
    }
    
    func deleteAccount() async {
        isDeletingAccount = true
        
        do {
            _ = try await deleteAccountUseCase.execute()
            deleteAccountSuccess = true
        } catch let error as DeleteAccountUseCaseError {
            state = .error(title: error.title, message: error.message)
        } catch {
            state = .error(
                title: L10n.Common.Dialog.Title.error,
                message: L10n.tryAgainLater
            )
        }
        
        isDeletingAccount = false
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
    }
}
