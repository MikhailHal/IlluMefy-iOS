//
//  VerificationEmailAddressViewModel.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//
import Combine
import FirebaseAuth

class VerificationEmailAddressViewModel: VerificationEmailAddressViewModelProtocol {
    var verificationEmailAddressUseCase: any VerificationEmailAddressUseCaseProtocol
    @Published var isLoading: Bool = false
    @Published var isShowErrorDialog: Bool = false
    @Published var isShowNotificationDialog: Bool = false
    @Published var isEnableAuthenticationButton: Bool = false
    @Published var authenticationCode: String = ""
    internal var errorMessage: String = ""
    init(verificationEmailAddressUseCase: any VerificationEmailAddressUseCaseProtocol) {
        self.verificationEmailAddressUseCase = verificationEmailAddressUseCase
    }
    func verificationEmailAddress() async {
        await MainActor.run { isLoading = true }
        do {
            _ = try await verificationEmailAddressUseCase.execute(request: Auth.auth().currentUser)
        } catch {
            let usecaseError = error as? VerificationEmailAddressUseCaseError
            switch usecaseError {
            case .unknownUser:
                errorMessage = "再度アカウントを作り直してください。"
            case .sendError:
                errorMessage = "メールの送信に失敗しました。"
            default:
                errorMessage = "ネットワークエラーが発生しました。"
                await MainActor.run {
                    isShowErrorDialog = true
                }
            }
            await MainActor.run { isLoading = false }
            return
        }
    }
}
