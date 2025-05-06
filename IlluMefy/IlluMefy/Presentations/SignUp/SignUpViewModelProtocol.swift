//
//  SignUpViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/14.
//

protocol SignUpViewModelProtocol: ViewModelProtocol {
    var registrationAccountUseCase: any RegisterAccountUseCaseProtocol { get set }
    var setStoreLoginAccountInLocalUseCase: any SetStoreLoginAccountInLocalUseCaseProtocol { get set }
    func register() async
}
