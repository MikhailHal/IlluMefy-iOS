//
//  ContactSupportViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/27.
//

import Foundation
import FirebaseAuth

@MainActor
class ContactSupportViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var selectedType: ContactSupportType?
    @Published var reason: String = ""
    @Published var isSubmitting: Bool = false
    @Published var isSubmitted: Bool = false
    @Published var showValidationErrors: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let submitContactSupportUseCase: SubmitContactSupportUseCaseProtocol
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        guard selectedType != nil,
              !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        
        let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedReason.count >= 10 && trimmedReason.count <= 500
    }
    
    var characterCount: Int {
        reason.count
    }
    
    var isCharacterCountValid: Bool {
        characterCount <= 500
    }
    
    var isContentLengthValid: Bool {
        let trimmedContent = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedContent.count >= 10
    }
    
    // MARK: - Initializer
    init(submitContactSupportUseCase: SubmitContactSupportUseCaseProtocol) {
        self.submitContactSupportUseCase = submitContactSupportUseCase
    }
    
    // MARK: - Public Methods
    func submitSupport() async {
        showValidationErrors = true
        errorMessage = nil
        
        // バリデーションチェック
        guard isFormValid else {
            if selectedType == nil {
                errorMessage = "報告項目を選択してください"
            } else if !isContentLengthValid {
                errorMessage = "詳細内容は10文字以上入力してください"
            } else if !isCharacterCountValid {
                errorMessage = "詳細内容は500文字以内で入力してください"
            }
            return
        }
        
        guard let selectedType = selectedType else { return }
        
        isSubmitting = true
        
        do {
            // 現在のユーザーIDを取得
            guard let currentUser = Auth.auth().currentUser else {
                errorMessage = "認証が必要です。再度ログインしてください。"
                return
            }
            
            // お問い合わせを送信
            _ = try await submitContactSupportUseCase.execute(
                type: selectedType,
                content: reason,
                userId: currentUser.uid
            )
            
            isSubmitted = true
            
        } catch let error as ContactSupportError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "送信に失敗しました。もう一度お試しください。"
        }
        
        isSubmitting = false
    }
    
    func resetForm() {
        selectedType = nil
        reason = ""
        isSubmitting = false
        isSubmitted = false
        showValidationErrors = false
        errorMessage = nil
    }
    
    func updateReason(_ newValue: String) {
        // IlluMefyMultilineTextFieldが文字数制限を処理するため、ここでは不要
        reason = newValue
        
        // エラーメッセージをクリア
        if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = nil
        }
    }
    
    func selectType(_ type: ContactSupportType) {
        selectedType = type
        // エラーメッセージをクリア
        errorMessage = nil
    }
}