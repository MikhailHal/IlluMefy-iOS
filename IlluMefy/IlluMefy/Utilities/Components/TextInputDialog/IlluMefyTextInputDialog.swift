//
//  IlluMefyTextInputDialog.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import SwiftUI

struct IlluMefyTextInputDialog: View {
    @State var isPresented: Bool = false
    let title: String
    let message: String
    let placeholder: String
    let onSubmit: (String) -> Void
    let onCancel: () -> Void
    
    @State private var inputText: String = ""
    
    var body: some View {
        ZStack {
            // 背景のフェードイン
            Asset.Color.ConfirmationDialog.confirmationDialogOverlay.swiftUIColor
                .ignoresSafeArea()
                .ignoresSafeArea(.keyboard)
                .opacity(isPresented ? 1.0 : 0)
                .animation(.easeOut(duration: 0.3), value: isPresented)
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                        isPresented = false
                    }
                    onCancel()
                }
            
            // ダイアログ本体
            GeometryReader { geometry in
                let width = min(geometry.size.width * 0.85, 400)
                // キーボードに関係なく固定サイズにする
                let fixedHeight: CGFloat = 300
                let headerHeight: CGFloat = 60
                let contentHeight = fixedHeight - headerHeight
                
                VStack(spacing: 0) {
                    header(width: width, height: headerHeight, title: title)
                    content(width: width, height: contentHeight)
                }
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .scaleEffect(isPresented ? 1.0 : 0.8)
            .opacity(isPresented ? 1.0 : 0)
            .blur(radius: isPresented ? 0 : 3)
            .animation(.spring(response: 0.55, dampingFraction: 0.85, blendDuration: 0), value: isPresented)
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                isPresented = true
            }
        }
    }
    
    private func header(width: CGFloat, height: CGFloat, title: String) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#00A3B5"),
                    Color(hex: "#00C2D6")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack(spacing: 12) {
                Spacer()
                Text(title)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .tracking(-0.5)
                    
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .frame(width: width, height: height)
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
    
    private func content(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Rectangle()
                .fill(Asset.Color.ConfirmationDialog.confirmationDialogContentsBackground.swiftUIColor)
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                
                if !message.isEmpty {
                    Text(message)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Asset.Color.ConfirmationDialog.confirmationDialogContentsForeground.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                }
                
                // テキスト入力フィールド
                TextField(placeholder, text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)
                
                Spacer(minLength: 0)
                
                HStack(spacing: 16) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        onCancel()
                    }, label: {
                        Text(L10n.Common.cancel)
                            .font(.body.weight(.semibold))
                            .foregroundColor(Asset.Color.ConfirmationDialog.confirmationDialogNegativeButtonForeground.swiftUIColor)
                            .frame(width: 100, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Asset.Color.ConfirmationDialog.confirmationDialogNegativeButtonForeground.swiftUIColor.opacity(0.3), lineWidth: 1)
                            )
                    })
                    
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        onSubmit(inputText)
                    }, label: {
                        Text(L10n.Common.ok)
                            .font(.body.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#00C2D6"),
                                        Color(hex: "#33DFEF")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            ).cornerRadius(12)
                    })
                    .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.bottom, 24)
            }
        }.frame(width: width, height: height)
    }
}

#Preview {
    IlluMefyTextInputDialog(
        title: "タグを追加",
        message: "追加したいタグ名を入力してください",
        placeholder: "タグ名",
        onSubmit: { text in print("Submitted: \(text)") },
        onCancel: { print("Cancelled") }
    )
}