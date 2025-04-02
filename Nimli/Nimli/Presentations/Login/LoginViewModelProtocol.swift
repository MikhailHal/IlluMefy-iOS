//
//  LoginViewModelProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/02.
//

protocol LoginViewModelProtocol: ViewModelProtocol {
    var loginUseCase: any RegisterAccountUseCaseProtocol { get set }
    func login() async
}
