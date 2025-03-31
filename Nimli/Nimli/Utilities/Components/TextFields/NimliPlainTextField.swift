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
    @Binding var text: String
    @FocusState var isTyping: Bool
    init(
        text: Binding<String>,
        title: String,
        placeHolder: String,
        placeHolderColor: Color = .screenBackground,
        onTextChange: ((String) -> Void)? = nil) {
            self._text = text
            self.title = title
            self.placeHolder = placeHolder
            self.placeHolderColor = placeHolderColor
    }
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text).padding(.leading)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .focused($isTyping)
                .foregroundColor(Color.textForeground)
                .background(isTyping ? .main : Color.textBorderNoneFocused,
                            in: RoundedRectangle(cornerRadius: 12).stroke(style: StrokeStyle(lineWidth: 2)))
            Text(isTyping || !text.isEmpty ? title : placeHolder).padding(.horizontal, 10)
                .background(placeHolderColor.opacity(isTyping || !text.isEmpty ? 1 : 0))
                .foregroundStyle(isTyping ? .main : Color.textForeground)
                .padding(.leading).offset(y: isTyping || !text.isEmpty ? -27 : 0)
                .onTapGesture { isTyping.toggle() }
        }
        .animation(.linear(duration: 0.2), value: isTyping)
    }
}

struct NimliPlainTextFieldPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // Empty state preview
            NimliPlainTextField(text: .constant("text"), title: "Email Address", placeHolder: "プレースホルダー")
                .previewDisplayName("Empty TextField")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
