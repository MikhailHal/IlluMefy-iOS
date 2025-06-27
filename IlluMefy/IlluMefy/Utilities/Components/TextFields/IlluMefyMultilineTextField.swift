//
//  IlluMefyMultilineTextField.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/28.
//

import SwiftUI

struct IlluMefyMultilineTextField: View {
    @Binding var text: String
    let placeholder: String
    let label: String?
    let isRequired: Bool
    let maxLength: Int?
    let minHeight: CGFloat
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        label: String? = nil,
        isRequired: Bool = false,
        maxLength: Int? = nil,
        minHeight: CGFloat = 120
    ) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.isRequired = isRequired
        self.maxLength = maxLength
        self.minHeight = minHeight
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            if let label = label {
                HStack(spacing: Spacing.componentGrouping / 2) {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                    if isRequired {
                        Text(L10n.Common.TextField.required)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    if let maxLength = maxLength {
                        Text("\(text.count)/\(maxLength)文字")
                            .font(.caption)
                            .foregroundColor(
                                text.count > maxLength ? .red : Asset.Color.Application.textSecondary.swiftUIColor
                            )
                    }
                }
            }
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.02))
                    .stroke(
                        isFocused ? Asset.Color.Application.accent.swiftUIColor :
                        Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.08),
                        lineWidth: 1
                    )
                    .frame(minHeight: minHeight)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.body)
                        .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.7))
                        .padding(.horizontal, Spacing.screenEdgePadding)
                        .padding(.top, 12)
                }
                
                TextEditor(text: $text)
                    .font(.body)
                    .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .focused($isFocused)
                    .onChange(of: text) { _, newValue in
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        IlluMefyMultilineTextField(
            text: .constant(""),
            placeholder: "詳細な内容をご記入ください",
            label: "詳細内容",
            isRequired: true,
            maxLength: 500
        )
        
        IlluMefyMultilineTextField(
            text: .constant("これはサンプルテキストです。複数行に対応しています。"),
            placeholder: "詳細な内容をご記入ください",
            label: "詳細内容",
            isRequired: true,
            maxLength: 500
        )
    }
    .padding()
    .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
}