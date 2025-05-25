//
//  IlluMefyPlainTextField.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/25.
//

import SwiftUI

/*
 This was created for commonalizing plain text input.
 This wasn't created for secure information(e.g. password, credit card and more!).
 */
struct IlluMefyPlainTextField: View {
    @Binding var text: String
    let placeHolder: String
    let label: String?
    let isRequired: Bool
    @FocusState private var isFocused: Bool
    
    init(text: Binding<String>, placeHolder: String, label: String? = nil, isRequired: Bool = false) {
        self._text = text
        self.placeHolder = placeHolder
        self.label = label
        self.isRequired = isRequired
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let label = label {
                HStack(spacing: 4) {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                    if isRequired {
                        Text(L10n.Common.TextField.required)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            TextField("a", text: $text)
                .textFieldStyle(NormalTextFieldStyle(isEnabled: true, text: $text, placeholder: placeHolder))
                .focused($isFocused)
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = true
                }
        }
    }
}

struct IlluMefyPlainTextFieldPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            IlluMefyPlainTextField(
                text: .constant(""),
                placeHolder: "メールアドレスを入力してください"
            ).previewDisplayName("Empty TextField")
            
            IlluMefyPlainTextField(
                text: .constant(""),
                placeHolder: "電話番号を入力",
                label: "電話番号",
                isRequired: true
            ).previewDisplayName("With Label and Required")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
