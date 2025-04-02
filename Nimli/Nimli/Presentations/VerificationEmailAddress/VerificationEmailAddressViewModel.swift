//
//  VerificationEmailAddressViewModel.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/25.
//
//  MEMO:
//    DON'T USE.
//    This screen is WIP.
//
import Combine
import FirebaseAuth

class VerificationEmailAddressViewModel: VerificationEmailAddressViewModelProtocol {
    var isShowErrorDialog: Bool = false
    var errorDialogMessage: String = ""
    var isShowNotificationDialog: Bool = false
    var notificationDialogMessage: String = ""
    var verificationEmailAddressUseCase: any VerificationEmailAddressUseCaseProtocol
    @Published var isShowDialog: Bool = false
    @Published var dialogTitle: String = ""
    @Published var dialogMessage: String = ""
    internal var errorMessage: String = ""
    init(verificationEmailAddressUseCase: any VerificationEmailAddressUseCaseProtocol) {
        self.verificationEmailAddressUseCase = verificationEmailAddressUseCase
    }
    ///
    /// send link to specific email-address for authenticating it
    ///
    func sendVerificationEmailLink() async -> (title: String, message: String) {
        do {
            _ = try await verificationEmailAddressUseCase.execute(request: Auth.auth().currentUser)
            return ("メール送信完了", "認証リンクを送信しました。\nメール内のリンクをタップしてください。")
        } catch {
            let usecaseError = error as? VerificationEmailAddressUseCaseError
            switch usecaseError {
            case .unknownUser:
                return ("メール送信失敗", "再度アカウントを作り直してください。")
            case .sendError:
                return ("メール送信失敗", "メールの送信に失敗しました。")
            default:
                return ("メール送信失敗", "ネットワークエラーが発生しました。")
            }
        }
    }
}
