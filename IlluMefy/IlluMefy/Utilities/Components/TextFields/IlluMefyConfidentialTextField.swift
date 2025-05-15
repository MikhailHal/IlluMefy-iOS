import SwiftUI

struct IlluMefyConfidentialTextField: View {
    @Binding var text: String
    let placeHolder: String
    @State private var showPassword = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if showPassword {
            TextField("a", text: $text)
                .textFieldStyle(PasswordTextFieldStyle(
                    isEnabled: true,
                    text: $text,
                    placeholder: placeHolder,
                    showPassword: $showPassword
                ))
                .focused($isFocused)
        } else {
            SecureField("a", text: $text)
                .textFieldStyle(PasswordTextFieldStyle(
                    isEnabled: true,
                    text: $text,
                    placeholder: placeHolder,
                    showPassword: $showPassword
                ))
                .focused($isFocused)
        }
    }
}

#Preview {
    IlluMefyConfidentialTextField(
        text: .constant(""),
        placeHolder: "パスワードを入力してください"
    )
    .padding()
}
