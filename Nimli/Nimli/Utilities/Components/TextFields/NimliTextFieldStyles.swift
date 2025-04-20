//
//  NimliTextFieldStyles.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/20.
//

import SwiftUI

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

struct PasswordTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    private var isEnabled: Bool
    @Binding var text: String
    private var placeholder: String
    @Binding var showPassword: Bool
    
    init (isEnabled: Bool, text: Binding<String>, placeholder: String, showPassword: Binding<Bool>) {
        self.isEnabled = isEnabled
        self._text = text
        self.placeholder = placeholder
        self._showPassword = showPassword
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack(alignment: .trailing) {
            configuration
                .focused($isFocused)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .textContentType(.password)
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
            
            Button(action: {
                showPassword.toggle()
            }, label: {
                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(Color("Text/OnCard"))
                    .opacity(0.6)
                    .frame(width: 24, height: 24)
            })
            .frame(width: 44, height: 44)
            .padding(.trailing, 16)
        }
        .overlay(
            Group {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(getPlaceHolderColor(isEnabled))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        )
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
