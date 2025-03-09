//
//  SignUpViewModel.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/03.
//
import Combine
import FirebaseAuth

/*
 TODO:
 1. add error cases
 2. change to clean architecture
 */
class SignUpViewModel: ViewModelProtocol, ObservableObject {
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
    var isEmailValid: Bool {
        return email.isValidEmail()
    }
    var isPasswordValid: Bool {
        return !password.isEmpty && !isErrorUpperCase && !isErrorLowerCase && !isErrorNumber && !isErrorLength
    }
    func getErrorMessage() -> String {
        return ""
    }
    func sendEmailAuthentucationCode() {
        Auth.auth().createUser(
            withEmail: "xx@gmail.com",
            password: "Abcde12345!"
        )
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
