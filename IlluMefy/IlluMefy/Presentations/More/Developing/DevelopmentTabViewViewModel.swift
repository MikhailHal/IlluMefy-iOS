//
//  DevelopmentTabViewViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/23.
//

import SwiftUI

/// 開発状況タブビューモデル
@MainActor
@Observable
final class DevelopmentTabViewViewModel: DevelopmentTabViewViewModelProtocol {
    var developmentStatusText: String = ""
    var isLoading: Bool = false
    
    private let getDevelopmentStatusUseCase: GetDevelopmentStatusUseCaseProtocol
    
    init(getDevelopmentStatusUseCase: GetDevelopmentStatusUseCaseProtocol) {
        self.getDevelopmentStatusUseCase = getDevelopmentStatusUseCase
    }
    
    func loadDevelopmentStatus() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let developmentStatus = try await getDevelopmentStatusUseCase.execute()
            developmentStatusText = developmentStatus.content.isEmpty ? L10n.DevelopmentTab.noStatus : developmentStatus.content
        } catch {
            developmentStatusText = L10n.DevelopmentTab.noStatus
        }
    }
}
