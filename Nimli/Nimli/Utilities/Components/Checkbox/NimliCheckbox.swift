//
//  NimliCheclbox.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/30.
//

import SwiftUI
struct NimliCheckboxView: View {
    @Binding var isChecked: Bool
    var title: String
    var body: some View {
        Toggle(isOn: $isChecked) {
            Text(title)
        }
        .toggleStyle(CheckboxToggleStyle())
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        // Preview with checkbox unchecked
        NimliCheckboxView(isChecked: .constant(false), title: "Unchecked Option")
        // Preview with checkbox checked
        NimliCheckboxView(isChecked: .constant(true), title: "Checked Option")
        // Preview with longer text
        NimliCheckboxView(isChecked: .constant(true),
                          title: "This is a longer checkbox label that might wrap to multiple lines")
    }
    .padding()
}
