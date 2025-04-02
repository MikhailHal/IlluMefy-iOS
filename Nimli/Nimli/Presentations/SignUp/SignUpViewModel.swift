//
//  SignUpViewModel.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/03.
//
import Combine
import FirebaseAuth

class SignUpViewModel: SignUpViewModelProtocol {
    var errorDialogMessage: String = ""
    var notificationDialogMessage: String = ""
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
                notificationDialogMessage = "新規アカウントの仮登録に成功しました。\n次画面にてメールアドレスの認証をしてください。"
                isShowNotificationDialog = true
            }
        } catch {
            let usecaseError = error as? RegisterAccountUseCaseError
            switch usecaseError {
            case .invalidEmail:
                errorDialogMessage = "メールアドレスが無効です"
            case .invalidPassword:
                errorDialogMessage = "パスワードが無効です"
            case .alreadyRegistered:
                errorDialogMessage = "入力されたメールアドレスは既に使用されています"
            default:
                errorDialogMessage = "ネットワーク回線状況をお確かめください"
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
