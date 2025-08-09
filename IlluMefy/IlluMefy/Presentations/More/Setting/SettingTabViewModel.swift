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
@Observable
final class SettingTabViewModel: SettingTabViewModelProtocol {
    var logoutSuccess: Bool = false
    var deleteSuccess: Bool = false
    
    // MARK: - Use Cases
    private let logoutUseCase: LogoutUseCaseProtocol
    private let deleteUseCase: DeleteAccountUseCaseProtocol
    
    // MARK: - Initialization
    init(logoutUseCase: LogoutUseCaseProtocol, deleteUseCase: DeleteAccountUseCaseProtocol) {
        self.logoutUseCase = logoutUseCase
        self.deleteUseCase = deleteUseCase
    }
    
    // MARK: - SettingViewModelProtocol
    
    func logout() async {
        
        do {
            try await logoutUseCase.execute()
            logoutSuccess = true
        } catch {
            print("ログアウトエラー: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        do {
            try _ = await deleteUseCase.execute()
            deleteSuccess = true
        } catch {
            print("削除エラー: \(error.localizedDescription)")
        }
    }
}
