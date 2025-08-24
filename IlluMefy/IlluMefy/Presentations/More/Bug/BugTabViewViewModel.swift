//
//  BugTabViewViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/24.
//

import SwiftUI

/// バグ状況タブビューモデル
@Observable
final class BugTabViewViewModel: BugTabViewViewModelProtocol {
    var bugStatusText: String = ""
    var isLoading: Bool = false
    
    private let getBugStatusUseCase: GetBugStatusUseCaseProtocol
    
    init(getBugStatusUseCase: GetBugStatusUseCaseProtocol) {
        self.getBugStatusUseCase = getBugStatusUseCase
    }
    
    func loadBugStatus() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let bugStatus = try await getBugStatusUseCase.execute()
            bugStatusText = bugStatus.content.isEmpty ? L10n.BugTab.noStatus : bugStatus.content
        } catch {
            bugStatusText = L10n.BugTab.noStatus
        }
    }
}
