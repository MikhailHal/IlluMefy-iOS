//
//  SignUpViewModel.swift
//  Pencula
//
//  Created by Haruto K. on 2025/03/03.
//
import Combine

class SignUpViewModel: ViewModelProtocol, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var email: String = ""
    func getErrorMessage() -> String {
        return ""
    }
    func sendEmailAuthentucationCode() {
    }
}
