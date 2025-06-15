//
//  StringExtension.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/09.
//
import Foundation
extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        // 日本の電話番号形式の基本的なバリデーション
        let phoneRegex = "^[0-9]{10,11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self.replacingOccurrences(of: "-", with: ""))
    }
}
