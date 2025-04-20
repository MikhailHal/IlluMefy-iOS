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
    let placeHolder: String
    let isEnabled: Bool
    @Binding var text: String
    @FocusState var isTyping: Bool
    init(
        text: Binding<String>,
        placeHolder: String,
        isEnabled: Bool = true,
        onTextChange: ((String) -> Void)? = nil) {
            self._text = text
            self.placeHolder = placeHolder
            self.isEnabled = isEnabled
    }
    var body: some View {
        TextField("", text: self.$text)
            .textFieldStyle(
                LoginTextFieldStyle(
                    isEnabled: isEnabled,
                    text: $text,
                    placeholder: placeHolder
                )
            )
    }
}

struct NimliPlainTextFieldPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            NimliPlainTextField(
                text: .constant(""),
                placeHolder: "プレースホルダー"
            ).previewDisplayName("Empty TextField")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
