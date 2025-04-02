//
//  SignUpViewModel.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/03.
//
import Combine
import FirebaseAuth

class SignUpViewModel: SignUpViewModelProtocol {
    var registrationAccountUseCase: any RegisterAccountUseCaseProtocol
    @Published var isShowErrorDialog: Bool = false
    @Published var isShowNotificationDialog: Bool = false
    @Published var isEnableRegisterButton: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isErrorUpperCase: Bool = true
    @Published var isErrorLowerCase: Bool = true
    @Published var isErrorNumber: Bool = true
    @Published var isErrorLength: Bool = true
    @Published var isShowTermsOfServiceBottomSheet: Bool = false
    @Published var isShowPrivacyPolicyBottomSheet: Bool = false
    @Published var isAgreedTermsOfService: Bool = false
    internal var errorMessage: String = ""
    let allowedPasswordMinLength = 6
    init(registrationAccountUseCase: any RegisterAccountUseCaseProtocol) {
        self.registrationAccountUseCase = registrationAccountUseCase
    }
    var isEmailValid: Bool {
        return email.isValidEmail()
    }
    var isPasswordValid: Bool {
        return !password.isEmpty && !isErrorUpperCase && !isErrorLowerCase && !isErrorNumber && !isErrorLength
    }
    func register() async {
        do {
            _ = try await registrationAccountUseCase.execute(
                request: RegistrationAccount(
                    email: email,
                    password: password
                )
            )
            await MainActor.run {
                isShowNotificationDialog = true
            }
        } catch {
            let usecaseError = error as? RegisterAccountUseCaseError
            switch usecaseError {
            case .invalidEmail:
                errorMessage = "メールアドレスが無効です"
            case .invalidPassword:
                errorMessage = "パスワードが無効です"
            case .alreadyRegistered:
                errorMessage = "入力されたメールアドレスは既に使用されています"
            default:
                errorMessage = "ネットワーク回線状況をお確かめください"
            }
            await MainActor.run {
                isShowErrorDialog = true
            }
        }
    }
    func onEmailDidChange() {
        isEnableRegisterButton = isEmailValid && isPasswordValid
    }
    func onPasswordDidChange() {
        updatePasswordAvailability(password)
        isEnableRegisterButton = isEmailValid && isPasswordValid
    }
    private func updatePasswordAvailability(_ password: String) {
        isErrorUpperCase = !(password.contains(where: { $0.isUppercase }))
        isErrorLowerCase = !(password.contains(where: { $0.isLowercase }))
        isErrorNumber = !(password.contains(where: { $0.isNumber }))
        isErrorLength = password.count < allowedPasswordMinLength
    }
}
