//
//  NimliPlainTextField.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/25.
//

import SwiftUI

/*
 This was created for commonalizing plain text input.
 This wasn't created for secure information(e.g. password, credit card and more!).
 */
struct NimliPlainTextField: View {
    @Binding var text: String
    let placeHolder: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField(placeHolder, text: $text)
            .textFieldStyle(LoginTextFieldStyle(isEnabled: true, text: $text, placeholder: placeHolder))
            .focused($isFocused)
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
    }
}

struct NimliPlainTextFieldPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            NimliPlainTextField(
                text: .constant(""),
                placeHolder: "メールアドレスを入力してください"
            ).previewDisplayName("Empty TextField")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
