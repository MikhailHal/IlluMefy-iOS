//
//  TagApplicationViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請ViewModel 実装
@MainActor
class TagApplicationViewModel: TagApplicationViewModelProtocol {
    
    // MARK: - Dependencies
    
    let creator: Creator
    private let submitTagApplicationUseCase: SubmitTagApplicationUseCaseProtocol
    
    // MARK: - Published Properties
    
    @Published var tagName = ""
    @Published var reason = ""
    @Published var applicationType: TagApplicationRequest.ApplicationType
    @Published var isSubmitting = false
    @Published var showingResult = false
    @Published private(set) var isSuccess = false
    @Published private(set) var resultMessage = ""
    
    // MARK: - Constants
    
    private let maxTagNameLength = 50
    private let maxReasonLength = 200
    
    // MARK: - Computed Properties
    
    var isSubmitEnabled: Bool {
        !tagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSubmitting
    }
    
    var tagNameCharacterCount: String {
        L10n.TagApplication.characterCount(tagName.count)
    }
    
    var reasonCharacterCount: String {
        "\(reason.count)/\(maxReasonLength)文字"
    }
    
    // MARK: - Initializer
    
    init(
        creator: Creator,
        applicationType: TagApplicationRequest.ApplicationType,
        submitTagApplicationUseCase: SubmitTagApplicationUseCaseProtocol
    ) {
        self.creator = creator
        self.applicationType = applicationType
        self.submitTagApplicationUseCase = submitTagApplicationUseCase
    }
    
    // MARK: - Methods
    
    func submitApplication() async {
        guard isSubmitEnabled else { return }
        
        isSubmitting = true
        
        do {
            let request = SubmitTagApplicationUseCaseRequest(
                creatorId: creator.id,
                tagName: tagName,
                reason: reason.isEmpty ? nil : reason,
                applicationType: applicationType
            )
            
            let response = try await submitTagApplicationUseCase.execute(request)
            
            isSuccess = true
            resultMessage = response.message
            showingResult = true
            
        } catch {
            isSuccess = false
            resultMessage = error.localizedDescription
            showingResult = true
        }
        
        isSubmitting = false
    }
    
    func validateTagName(_ value: String) -> String {
        if value.count > maxTagNameLength {
            return String(value.prefix(maxTagNameLength))
        }
        return value
    }
    
    func validateReason(_ value: String) -> String {
        if value.count > maxReasonLength {
            return String(value.prefix(maxReasonLength))
        }
        return value
    }
    
    func resetFormData() {
        tagName = ""
        reason = ""
        isSuccess = false
        resultMessage = ""
    }
}
