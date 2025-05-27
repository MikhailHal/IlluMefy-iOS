//
//  IlluMefyCheckbox.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/30.
//

import SwiftUI

struct IlluMefyCheckbox: View {
    // MARK: - Constants
    private enum Constants {
        static let checkboxSize: CGFloat = 20
        static let cornerRadius: CGFloat = 4
        static let borderWidth: CGFloat = 1.5
        static let spacing: CGFloat = 12
        static let checkmarkFontSize: CGFloat = 14
    }
    
    @Binding var isChecked: Bool
    let title: String
    let isEnabled: Bool
    
    init(isChecked: Binding<Bool>, title: String, isEnabled: Bool = true) {
        self._isChecked = isChecked
        self.title = title
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        Button(action: {
            if isEnabled {
                isChecked.toggle()
            }
        }, label: {
            HStack(spacing: Constants.spacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .fill(checkboxBackgroundColor)
                        .frame(width: Constants.checkboxSize, height: Constants.checkboxSize)
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: Constants.checkmarkFontSize, weight: .bold))
                            .foregroundColor(checkmarkColor)
                    }
                }
                
                Text(title)
                    .font(.body)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
                
            }
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
    
    private var checkboxBackgroundColor: Color {
        if !isEnabled {
            return Asset.Color.Checkbox.checkboxBackgroundDisabled.swiftUIColor
        }
        return isChecked ?
        Asset.Color.Checkbox.checkboxBackgroundFilled.swiftUIColor
        :Asset.Color.Checkbox.checkboxBackgroundNotFilled.swiftUIColor
    }
    
    private var checkboxBorderColor: Color {
        if !isEnabled {
            return Asset.Color.Checkbox.checkboxForegroundDisabled.swiftUIColor
        }
        return isChecked ?
        Asset.Color.Checkbox.checkboxForegroundFilled.swiftUIColor
        :Asset.Color.Checkbox.checkboxForegroundNotFilled.swiftUIColor
    }
    
    private var checkmarkColor: Color {
        if !isEnabled {
            return Asset.Color.Checkbox.checkboxForegroundDisabled.swiftUIColor
        }
        return .white
    }
    
    private var textColor: Color {
        if !isEnabled {
            return Asset.Color.Checkbox.checkboxForegroundDisabled.swiftUIColor
        }
        return Asset.Color.Checkbox.checkboxForegroundFilled.swiftUIColor
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        // Preview with checkbox unchecked
        IlluMefyCheckbox(isChecked: .constant(false), title: "プライバシーポリシーに同意します")
        
        // Preview with checkbox checked
        IlluMefyCheckbox(isChecked: .constant(true), title: "プライバシーポリシーに同意します")
        
        // Preview with disabled state
        IlluMefyCheckbox(isChecked: .constant(false), title: "無効化されたチェックボックス", isEnabled: false)
        
        // Preview with longer text
        IlluMefyCheckbox(isChecked: .constant(true),
                         title: "これは複数行にわたる可能性がある長いチェックボックスラベルです")
    }
    .padding()
    .background(Asset.Color.Application.Background.background.swiftUIColor)
}
