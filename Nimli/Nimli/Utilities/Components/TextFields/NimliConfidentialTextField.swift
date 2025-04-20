import SwiftUI

struct NimliConfidentialTextField: View {
    @Binding var text: String
    let placeHolder: String
    @State private var showPassword = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            if showPassword {
                TextField(placeHolder, text: $text)
                    .textFieldStyle(PasswordTextFieldStyle(isEnabled: true, text: $text, placeholder: placeHolder))
                    .focused($isFocused)
            } else {
                SecureField(placeHolder, text: $text)
                    .textFieldStyle(PasswordTextFieldStyle(isEnabled: true, text: $text, placeholder: placeHolder))
                    .focused($isFocused)
            }
            
            Button(action: {
                showPassword.toggle()
            }, label: {
                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(Color("Text/OnCard"))
                    .opacity(0.6)
            })
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
    }
}

#Preview {
    NimliConfidentialTextField(
        text: .constant(""),
        placeHolder: "パスワードを入力してください"
    )
    .padding()
}
