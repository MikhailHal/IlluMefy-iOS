//
//  PhoneNumberRegistrationViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/03.
//
import Combine

@MainActor
class PhoneNumberRegistrationViewModel: PhoneNumberRegistrationViewModelProtocol {
    // MARK: - Properties
    
    var errorDialogMessage: String = ""
    var notificationDialogMessage: String = ""
    var verificationID: String?
    
    // UseCases
    var sendPhoneVerificationUseCase: any SendPhoneVerificationUseCaseProtocol
    
    // Published properties
    @Published var isShowErrorDialog: Bool = false
    @Published var isShowNotificationDialog: Bool = false
    @Published var isEnableRegisterButton: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var phoneNumber: String = ""
    @Published var isShowTermsOfServiceBottomSheet: Bool = false
    @Published var isShowPrivacyPolicyBottomSheet: Bool = false
    @Published var isAgreedTermsOfService: Bool = false
    
    let allowedPasswordMinLength = 6
    
    // MARK: - Initialization
    
    init(
        sendPhoneVerificationUseCase: any SendPhoneVerificationUseCaseProtocol
    ) {
        self.sendPhoneVerificationUseCase = sendPhoneVerificationUseCase
    }
    // MARK: - Methods
    
    /// 認証コードを送信
    func sendVerificationCode(phoneNumber: String? = nil) async {
        do {
            let targetPhoneNumber = phoneNumber ?? self.phoneNumber
            let request = SendPhoneVerificationUseCaseRequest(phoneNumber: targetPhoneNumber)
            let response = try await sendPhoneVerificationUseCase.execute(request: request)
            
            // verificationIDを保存
            self.verificationID = response.verificationID
            notificationDialogMessage = L10n.PhoneNumberRegistration.Message.verificationCodeSent
            isShowNotificationDialog = true
        } catch let error as SendPhoneVerificationUseCaseError {
            errorDialogMessage = error.errorDescription ?? L10n.PhoneAuth.Error.unknownError
            isShowErrorDialog = true
        } catch {
            errorDialogMessage = L10n.PhoneAuth.Error.unknownError
            isShowErrorDialog = true
        }
    }
    
    /// 認証コード送信
    func sendAuthenticationCode(phoneNumber: String? = nil) async {
        await sendVerificationCode(phoneNumber: phoneNumber)
    }
}
