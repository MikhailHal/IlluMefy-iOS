//
//  ProfileCorrectionView.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import SwiftUI

/// プロフィール修正依頼ビュー
struct ProfileCorrectionView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: ProfileCorrectionViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Initializer
    
    init(creator: Creator) {
        let container = DependencyContainer.shared
        guard let viewModel = container.container.resolve(ProfileCorrectionViewModel.self, argument: creator) else {
            fatalError("Failed to resolve ProfileCorrectionViewModel")
        }
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    creatorInfoSection
                    correctionTypeSection
                    correctionDetailsSection
                    reasonSection
                    referenceUrlSection
                    infoSection
                }
                
                submitSection
                    .padding(.top, Spacing.relatedComponentDivider)
                    .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
            }
            .navigationTitle("プロフィール修正依頼")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
            .alert(viewModel.isSuccess ? "送信完了" : "送信エラー",
                   isPresented: $viewModel.showingResult) {
                Button("OK") {
                    if viewModel.isSuccess {
                        dismiss()
                    }
                }
            } message: {
                Text(viewModel.resultMessage)
            }
        }
    }
    
    // MARK: - View Components
    
    private var creatorInfoSection: some View {
        Section {
            HStack {
                AsyncImage(url: URL(string: viewModel.creator.thumbnailUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(Opacity.glow))
                        .overlay {
                            ProgressView()
                        }
                }
                .frame(width: Size.smallImageSize, height: Size.smallImageSize)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                    Text(viewModel.creator.name)
                        .font(.headline)
                    Text("ID: \\(viewModel.creator.id)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, Spacing.extraSmall)
        } header: {
            Text("対象クリエイター")
        }
    }
    
    private var correctionTypeSection: some View {
        Section {
            IlluMefySelectionCheckbox(
                title: "",
                items: ProfileCorrectionRequest.CorrectionType.allCases.map { type in
                    .init(value: type, label: type.displayName, icon: type.icon)
                },
                selectedItems: $viewModel.selectedCorrectionTypes,
                columns: 1
            )
        } header: {
            Text("修正したい項目")
        } footer: {
            Text("修正したい項目を選択してください。複数選択が可能です。")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var correctionDetailsSection: some View {
        Group {
            if !viewModel.selectedCorrectionTypes.isEmpty {
                Section {
                    ForEach(viewModel.correctionItems) { item in
                        correctionItemDetail(for: item)
                    }
                } header: {
                    Text("修正内容")
                }
            }
        }
    }
    
    private func correctionItemDetail(for item: CorrectionItemInput) -> some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            HStack {
                if let icon = item.type.icon {
                    Image(systemName: icon)
                        .font(.system(size: Typography.bodyRegular))
                        .foregroundColor(.primary)
                }
                Text(item.type.displayName)
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: Spacing.smallMedium) {
                VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                    Text("現在の値")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("現在の値が表示されます", text: .constant(item.currentValue))
                        .textFieldStyle(.plain)
                        .disabled(true)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                    Text("修正後の値")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("修正後の値を入力してください", text: Binding(
                        get: { item.suggestedValue },
                        set: { newValue in
                            viewModel.updateCorrectionItem(
                                type: item.type,
                                currentValue: item.currentValue,
                                suggestedValue: newValue
                            )
                        }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
            }
        }
        .padding(.vertical, Spacing.extraSmall)
    }
    
    private var reasonSection: some View {
        Section {
            TextField("修正が必要な理由を詳しく説明してください", text: $viewModel.reason, axis: .vertical)
                .lineLimit(3...6)
                .onChange(of: viewModel.reason) { _, newValue in
                    viewModel.reason = viewModel.validateReason(newValue)
                }
            
            HStack {
                Spacer()
                Text(viewModel.reasonCharacterCount)
                    .font(.caption)
                    .foregroundColor(viewModel.reason.count > 450 ? .orange : .secondary)
            }
        } header: {
            Text("修正理由")
        } footer: {
            Text("修正の理由を具体的に記載することで審査がスムーズになります。")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var referenceUrlSection: some View {
        Section {
            TextField("修正内容の根拠となるURL", text: $viewModel.referenceUrl)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .autocorrectionDisabled()
        } header: {
            Text("参考URL（任意）")
        } footer: {
            Text("修正内容を裏付ける公式情報やSNSのURLがあれば入力してください。")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var submitSection: some View {
        Button(action: {
            Task {
                await viewModel.submitCorrection()
            }
        }, label: {
            HStack {
                if viewModel.isSubmitting {
                    ProgressView()
                        .controlSize(.small)
                    Text("送信中...")
                } else {
                    Text("修正依頼を送信")
                }
            }
        })
        .illuMefyButtonStyle(isEnabled: viewModel.isSubmitEnabled)
        .disabled(!viewModel.isSubmitEnabled)
        .padding(.horizontal, Spacing.screenEdgePadding)
    }
    
    private var infoSection: some View {
        Section {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Label("ご注意", systemImage: "info.circle")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text("送信された修正依頼は運営チームが確認し、適切と判断された場合に反映されます。虚偽の情報や不適切な内容の場合は却下される可能性があります。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let mockCreator = Creator(
        id: "creator_001",
        name: "ゲーム実況者A",
        thumbnailUrl: "https://picsum.photos/200/200?random=1",
        viewCount: 5000,
        socialLinkClickCount: 1500,
        platformClickRatio: [
            .youtube: 0.3,
            .twitch: 0.2,
            .tiktok: 0.5
        ],
        relatedTag: ["fps", "apex-legends", "valorant"],
        description: "FPSゲームをメインに実況しています。毎日20時から配信！",
        platform: [
            .youtube: "https://youtube.com/@gameplayerA",
            .twitch: "https://twitch.tv/gameplayerA",
            .tiktok: "https://tiktok.com/gameplayerA"
        ],
        createdAt: Date().addingTimeInterval(-86400 * 30),
        updatedAt: Date().addingTimeInterval(-3600),
        isActive: true,
        favoriteCount: 100
    )
    
    ProfileCorrectionView(creator: mockCreator)
}
