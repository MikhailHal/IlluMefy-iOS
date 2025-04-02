//
//  LoginViewModel.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/02.
//

import Combine
class LoginViewModel: LoginViewModelProtocol {
    var loginUseCase: any AccountLoginUseCaseProtocol
    var errorDialogMessage: String = ""
    var notificationDialogMessage: String = ""
    @Published var isShowNotificationDialog: Bool = false
    @Published var isShowErrorDialog: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isStoreLoginInformation: Bool = false
    
    init(loginUseCase: any AccountLoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    func login() async {
        return
    }
}
