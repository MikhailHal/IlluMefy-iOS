//
//  SettingViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 設定画面ViewModelのプロトコル
@MainActor
protocol SettingTabViewModelProtocol {
    
    /// ログアウト成功フラグ
    var logoutSuccess: Bool { get }
    
    /// ログアウト処理
    func logout() async
}
