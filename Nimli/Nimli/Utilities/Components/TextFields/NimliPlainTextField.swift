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
    let title: String
    let placeHolder: String
    let placeHolderColor: Color
    let isEnabled: Bool
    @Binding var text: String
    @FocusState var isTyping: Bool
    init(
        text: Binding<String>,
        title: String,
        placeHolder: String,
        placeHolderColor: Color = .screenBackground,
        isEnabled: Bool = true,
        onTextChange: ((String) -> Void)? = nil) {
            self._text = text
            self.title = title
            self.placeHolder = placeHolder
            self.placeHolderColor = placeHolderColor
            self.isEnabled = isEnabled
    }
    var body: some View {
        TextField("", text: self.$text)
            .textFieldStyle(LoginTextFieldStyle(
                isEnabled: isEnabled,
                text: $text,
                placeholder: placeHolder
            ))
    }
}

struct LoginTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    private var isEnabled: Bool
    @Binding var text: String
    private var placeholder: String
    
    init (isEnabled: Bool, text: Binding<String>, placeholder: String) {
        self.isEnabled = isEnabled
        self._text = text
        self.placeholder = placeholder
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack(alignment: .leading) {
            configuration
                .focused($isFocused)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .foregroundColor(getForegroundColor(isEnabled))
                .background(getBackgroundColor(isEnabled))
                .autocapitalization(.none)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            getBorderColor(isFocused: isFocused, isEnabled: isEnabled),
                            lineWidth: isFocused ? 1.5 : 0.5
                        )
                )
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(getPlaceHolderColor(isEnabled))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
            }
        }
    }
}

private func getForegroundColor(_ isEnabled: Bool) -> Color {
    if !isEnabled {
        return Color("TextField/ForegroundForDisabled")
    }
    return Color("TextField/ForegroundForEnabled")
}

private func getBackgroundColor(_ isEnabled: Bool) -> Color {
    if !isEnabled {
        return Color("TextField/BackgroundForDisabled")
    }
    return Color("TextField/BackgroundForEnabled")
}

private func getBorderColor(isFocused: Bool, isEnabled: Bool) -> Color {
    if !isEnabled {
        return Color("TextField/BorderForDisabled")
    }
    return if isFocused {
        Color("TextField/BorderForFocusing")
    } else {
        Color("TextField/BorderForEnabled")
    }
}

private func getPlaceHolderColor(_ isEnabled: Bool) -> Color {
    if !isEnabled {
        return Color("TextField/PlaceholderForDisabled")
    }
    return Color("TextField/PlaceholderForEnabled")
}
struct NimliPlainTextFieldPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            NimliPlainTextField(text: .constant(""), title: "Email Address", placeHolder: "プレースホルダー")
                .previewDisplayName("Empty TextField")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
