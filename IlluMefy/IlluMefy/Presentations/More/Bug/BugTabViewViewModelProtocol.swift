//
//  BugTabViewViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/24.
//

import SwiftUI

/// バグ状況タブビューモデルプロトコル
@MainActor
protocol BugTabViewViewModelProtocol {
    var bugStatusText: String { get set }
    var isLoading: Bool { get set }
    
    /// バグ状況を読み込む
    func loadBugStatus() async
}
