//
//  ProfileCorrectionViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正ビューモデルプロトコル
@MainActor
protocol ProfileCorrectionViewModelProtocol: ObservableObject {
    /// 対象クリエイター
    var creator: Creator { get }
    
    /// 選択された修正項目タイプ
    var selectedCorrectionTypes: Set<ProfileCorrectionRequest.CorrectionType> { get set }
    
    /// 修正項目の詳細
    var correctionItems: [CorrectionItemInput] { get set }
    
    /// 修正理由
    var reason: String { get set }
    
    /// 参考URL
    var referenceUrl: String { get set }
    
    /// 送信可能かどうか
    var isSubmitEnabled: Bool { get }
    
    /// 送信中かどうか
    var isSubmitting: Bool { get }
    
    /// 送信結果表示フラグ
    var showingResult: Bool { get set }
    
    /// 送信成功フラグ
    var isSuccess: Bool { get }
    
    /// 結果メッセージ
    var resultMessage: String { get }
    
    /// 修正項目を追加または削除
    /// - Parameter type: 修正項目タイプ
    func toggleCorrectionType(_ type: ProfileCorrectionRequest.CorrectionType)
    
    /// 修正項目の入力値を更新
    /// - Parameters:
    ///   - type: 修正項目タイプ
    ///   - currentValue: 現在の値
    ///   - suggestedValue: 修正後の値
    func updateCorrectionItem(type: ProfileCorrectionRequest.CorrectionType, currentValue: String, suggestedValue: String)
    
    /// 理由のバリデーション
    /// - Parameter newValue: 新しい値
    /// - Returns: バリデーション済みの値
    func validateReason(_ newValue: String) -> String
    
    /// 理由の文字数カウント
    var reasonCharacterCount: String { get }
    
    /// 修正依頼を送信
    func submitCorrection() async
}

/// 修正項目入力
struct CorrectionItemInput: Identifiable, Equatable {
    let id = UUID()
    let type: ProfileCorrectionRequest.CorrectionType
    var currentValue: String
    var suggestedValue: String
    
    var isValid: Bool {
        !currentValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !suggestedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}