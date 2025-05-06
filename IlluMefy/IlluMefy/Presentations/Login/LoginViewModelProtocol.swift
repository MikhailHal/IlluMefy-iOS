//
//  LoginViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/02.
//

protocol LoginViewModelProtocol: ViewModelProtocol {
    var loginUseCase: any AccountLoginUseCaseProtocol { get set }
    var setStoreLoginAccountInLocalUseCase: any SetStoreLoginAccountInLocalUseCaseProtocol { get set }
    var getStoreLoginAccountInLocalUseCase: any GetStoreLoginAccountInLocalUseCaseProtocol { get set }
    func login() async
}
