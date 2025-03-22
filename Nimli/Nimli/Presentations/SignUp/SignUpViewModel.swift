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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isEnableRegisterButton: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isErrorUpperCase: Bool = false
    @Published var isErrorLowerCase: Bool = false
    @Published var isErrorNumber: Bool = false
    @Published var isErrorLength: Bool = false
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
        } catch {
            let usecaseError = error as? RegisterAccountUseCaseError
            switch usecaseError {
            case .invalidEmail:
                errorMessage = "Email is invalid"
            case .invalidPassword:
                errorMessage = "Password is invalid"
            case .alreadyRegistered:
                errorMessage = "Account already registered"
            default:
                errorMessage = "Network error"
            }
        }
    }
    func onEmailDidChange() {
        updateRegisterButtonAvailability()
    }
    func onPasswordDidChange() {
        updatePasswordAvailability(password)
        updateRegisterButtonAvailability()
    }
    private func updatePasswordAvailability(_ password: String) {
        isErrorUpperCase = !(password.contains(where: { $0.isUppercase }))
        isErrorLowerCase = !(password.contains(where: { $0.isLowercase }))
        isErrorNumber = !(password.contains(where: { $0.isNumber }))
        isErrorLength = password.count < allowedPasswordMinLength
    }
    private func updateRegisterButtonAvailability() {
        isEnableRegisterButton = isEmailValid && isPasswordValid
    }
}
