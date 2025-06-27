//
//  ContactSupportView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/27.
//

import SwiftUI

struct ContactSupportView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(ContactSupportViewModel.self)!
    @Environment(\.dismiss) private var dismiss
    @State private var showingSuccessAlert = false
    
    var body: some View {
        ZStack {
            Asset.Color.Application.Background.backgroundPrimary.swiftUIColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.unrelatedComponentDivider) {
                    // ヘッダー説明
                    headerSection
                    
                    // 報告項目選択
                    reportTypeSection
                    
                    // 詳細理由入力
                    reasonSection
                    
                    // 送信ボタン
                    submitButton
                }
                .padding(.horizontal, Spacing.screenEdgePadding)
                .padding(.top, Spacing.componentGrouping)
            }
        }
        .navigationTitle(L10n.contactSupport)
        .navigationBarTitleDisplayMode(.large)
        .alert(L10n.Common.Dialog.Title.success, isPresented: $showingSuccessAlert) {
            Button(L10n.ok) {
                dismiss()
            }
        } message: {
            Text("お問い合わせを受け付けました。不具合報告への個別返信は行っておりませんが、対応状況は「運営からのお知らせ」にて共有いたします。")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                
                Text("サポートにお問い合わせ")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                
                Spacer()
            }
            
            Text("不具合の報告や機能追加のご要望をお送りください。いただいたフィードバックは今後のアプリ改善に活用させていただきます。")
                .font(.subheadline)
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.screenEdgePadding)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .fill(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.02))
                .stroke(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.08), lineWidth: 1)
        )
    }
    
    // MARK: - Report Type Section
    private var reportTypeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            Text("報告項目")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
            
            Menu {
                ForEach(ContactSupportType.allCases, id: \.self) { type in
                    Button(action: {
                        viewModel.selectType(type)
                    }, label: {
                        HStack {
                            Text(type.displayName)
                            if viewModel.selectedType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    })
                }
            } label: {
                HStack {
                    Image(systemName: viewModel.selectedType?.icon ?? "questionmark.circle")
                        .font(.system(size: 18))
                        .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                        .frame(width: 24)
                    
                    Text(viewModel.selectedType?.displayName ?? "選択してください")
                        .font(.body)
                        .foregroundColor(viewModel.selectedType != nil ? Asset.Color.Application.textPrimary.swiftUIColor : Asset.Color.Application.textSecondary.swiftUIColor)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, Spacing.screenEdgePadding)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.medium)
                        .fill(Asset.Color.Application.textPrimary.swiftUIColor.opacity(0.02))
                        .stroke(Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.08), lineWidth: 1)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Reason Section
    private var reasonSection: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            IlluMefyMultilineTextField(
                text: $viewModel.reason,
                placeholder: viewModel.selectedType?.placeholder ?? "詳細な内容をご記入ください",
                label: "詳細内容",
                isRequired: true,
                maxLength: 500,
                minHeight: 120
            )
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Text("具体的な状況、発生タイミング、期待する動作などを詳しくお書きください。（10文字以上必須）")
                .font(.caption)
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
        }
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        VStack(spacing: Spacing.componentGrouping) {
            Button(action: {
                Task {
                    await viewModel.submitSupport()
                    if viewModel.isSubmitted {
                        showingSuccessAlert = true
                    }
                }
            }, label: {
                HStack {
                    if viewModel.isSubmitting {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                    }
                    
                    Text(viewModel.isSubmitting ? "送信中..." : "送信する")
                        .font(.system(.body, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.button)
                        .fill(
                            viewModel.isFormValid && !viewModel.isSubmitting ?
                            Asset.Color.Application.accent.swiftUIColor :
                            Asset.Color.Application.textSecondary.swiftUIColor.opacity(0.5)
                        )
                )
            })
            .disabled(!viewModel.isFormValid || viewModel.isSubmitting)
            .buttonStyle(PlainButtonStyle())
            
            Text("不具合報告については個別返信は行いませんが、対応状況は「運営からのお知らせ」で共有します。")
                .font(.caption)
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                .multilineTextAlignment(.center)
        }
    }
}


#Preview {
    ContactSupportView()
}