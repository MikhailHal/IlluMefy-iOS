//
//  ProfileCorrectionViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正ビューモデル
@MainActor
final class ProfileCorrectionViewModel: ProfileCorrectionViewModelProtocol {
    
    // MARK: - Dependencies
    
    private let submitProfileCorrectionUseCase: SubmitProfileCorrectionUseCaseProtocol
    
    // MARK: - Published Properties
    
    @Published var selectedCorrectionTypes: Set<ProfileCorrectionRequest.CorrectionType> = []
    @Published var correctionItems: [CorrectionItemInput] = []
    @Published var reason: String = ""
    @Published var referenceUrl: String = ""
    @Published var isSubmitting: Bool = false
    @Published var showingResult: Bool = false
    
    // MARK: - Private Properties
    
    let creator: Creator
    private var submitResult: SubmitProfileCorrectionUseCaseResponse?
    
    // MARK: - Computed Properties
    
    var isSubmitEnabled: Bool {
        !selectedCorrectionTypes.isEmpty &&
        !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        correctionItems.allSatisfy { $0.isValid } &&
        !isSubmitting
    }
    
    var isSuccess: Bool {
        submitResult?.isSuccess ?? false
    }
    
    var resultMessage: String {
        if let error = submitResult?.error {
            return error.localizedDescription
        } else if submitResult?.isSuccess == true {
            return "修正依頼を受け付けました。審査結果をお待ちください。"
        }
        return ""
    }
    
    var reasonCharacterCount: String {
        return "\(reason.count)/500"
    }
    
    // MARK: - Initializer
    
    init(
        creator: Creator,
        submitProfileCorrectionUseCase: SubmitProfileCorrectionUseCaseProtocol
    ) {
        self.creator = creator
        self.submitProfileCorrectionUseCase = submitProfileCorrectionUseCase
    }
    
    // MARK: - ProfileCorrectionViewModelProtocol
    
    func toggleCorrectionType(_ type: ProfileCorrectionRequest.CorrectionType) {
        if selectedCorrectionTypes.contains(type) {
            selectedCorrectionTypes.remove(type)
            correctionItems.removeAll { $0.type == type }
        } else {
            selectedCorrectionTypes.insert(type)
            let newItem = CorrectionItemInput(
                type: type,
                currentValue: getCurrentValueForType(type),
                suggestedValue: ""
            )
            correctionItems.append(newItem)
        }
    }
    
    func updateCorrectionItem(type: ProfileCorrectionRequest.CorrectionType, currentValue: String, suggestedValue: String) {
        if let index = correctionItems.firstIndex(where: { $0.type == type }) {
            correctionItems[index].currentValue = currentValue
            correctionItems[index].suggestedValue = suggestedValue
        }
    }
    
    func validateReason(_ newValue: String) -> String {
        // 最大文字数制限
        if newValue.count > 500 {
            return String(newValue.prefix(500))
        }
        return newValue
    }
    
    func submitCorrection() async {
        guard isSubmitEnabled else { return }
        
        isSubmitting = true
        
        let request = SubmitProfileCorrectionUseCaseRequest(
            creatorId: creator.id,
            requesterId: nil, // TODO: 現在のユーザーIDを設定
            correctionItems: correctionItems.map { item in
                SubmitProfileCorrectionUseCaseRequest.CorrectionItem(
                    type: item.type,
                    currentValue: item.currentValue,
                    suggestedValue: item.suggestedValue
                )
            },
            reason: reason,
            referenceUrl: referenceUrl.isEmpty ? nil : referenceUrl
        )
        
        let response = await submitProfileCorrectionUseCase.execute(request)
        
        submitResult = response
        isSubmitting = false
        showingResult = true
    }
    
    // MARK: - Private Methods
    
    private func getCurrentValueForType(_ type: ProfileCorrectionRequest.CorrectionType) -> String {
        switch type {
        case .creatorName:
            return creator.name
        case .profileImage:
            return creator.thumbnailUrl
        case .youtube:
            return creator.platform[.youtube] ?? ""
        case .twitch:
            return creator.platform[.twitch] ?? ""
        case .tiktok:
            return creator.platform[.tiktok] ?? ""
        case .twitter:
            return creator.platform[.x] ?? ""
        case .instagram:
            return creator.platform[.instagram] ?? ""
        case .otherSns:
            // その他のSNSは複数の可能性があるため、空文字を返す
            return ""
        case .tags:
            return creator.relatedTag.joined(separator: ", ")
        case .other:
            return ""
        }
    }
}