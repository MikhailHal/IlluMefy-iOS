//
//  DevelopmentTabViewViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/23.
//

import SwiftUI

/// 開発状況タブビューモデルプロトコル
@MainActor
protocol DevelopmentTabViewViewModelProtocol {
    var developmentStatusText: String { get set }
    var isLoading: Bool { get set }
    
    /// 開発状況を読み込む
    func loadDevelopmentStatus() async
}
