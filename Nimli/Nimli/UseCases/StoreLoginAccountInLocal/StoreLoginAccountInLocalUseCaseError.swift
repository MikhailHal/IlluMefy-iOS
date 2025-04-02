//
//  StoreLoginAccounInLocaltUseCaseError.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

enum StoreLoginAccountInLocalUseCaseError: UseCaseErrorProtocol {
    case success
    case readError
    case invalidFormat
}
