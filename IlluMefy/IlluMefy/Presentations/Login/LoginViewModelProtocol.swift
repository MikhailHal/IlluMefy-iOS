//
//  LoginViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/02.
//

import Combine

@MainActor
protocol LoginViewModelProtocol: ObservableObject {
    var loginUseCase: any AccountLoginUseCaseProtocol { get set }
    var setStoreLoginAccountInLocalUseCase: any SetStoreLoginAccountInLocalUseCaseProtocol { get set }
    var getStoreLoginAccountInLocalUseCase: any GetStoreLoginAccountInLocalUseCaseProtocol { get set }
    var isShowErrorDialog: Bool { get set }
    var errorDialogMessage: String { get set }
    var isShowNotificationDialog: Bool { get set }
    var notificationDialogMessage: String { get set }
    func login() async
}
