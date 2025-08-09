//
//  IlluMefyConfirmationDialog.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

import SwiftUI

struct IlluMefyConfirmationDialog: View {
    @State var isPresented: Bool = false
    let title: String
    let message: String
    let onClickOk: () -> Void
    let onClickCancel: () -> Void
    
    var body: some View {
        ZStack {
            // 背景のフェードイン
            Asset.Color.ConfirmationDialog.confirmationDialogOverlay.swiftUIColor
                .ignoresSafeArea()
                .opacity(isPresented ? 1.0 : 0)
                .animation(.easeOut(duration: 0.3), value: isPresented)
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                        isPresented = false
                    }
                    onClickCancel()
                }
            
            // ダイアログ本体
            GeometryReader { geometry in
                let width = min(geometry.size.width * 0.85, 400)
                let maxHeight = min(geometry.size.height * 0.4, 500)
                let headerHeight = maxHeight * 0.2
                let contentHeight = maxHeight - headerHeight
                
                VStack(spacing: 0) {
                    header(width: width, height: headerHeight, title: title)
                    content(width: width, height: contentHeight, title: title)
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
    
    private func content(width: CGFloat, height: CGFloat, title: String) -> some View {
        ZStack {
            Rectangle()
                .fill(Asset.Color.ConfirmationDialog.confirmationDialogContentsBackground.swiftUIColor)
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                
                Text(message)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Asset.Color.ConfirmationDialog.confirmationDialogContentsForeground.swiftUIColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
                
                Spacer(minLength: 0)
                
                HStack(spacing: 16) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                        onClickCancel()
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
                        onClickOk()
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
                }
                .padding(.bottom, 24)
            }
        }.frame(width: width, height: height)
    }
}

#Preview {
    IlluMefyConfirmationDialog(title: "テストタイトル", message: "テストだよ", onClickOk: {}, onClickCancel: {})
}
