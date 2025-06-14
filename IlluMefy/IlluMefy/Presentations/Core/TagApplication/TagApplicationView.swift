//
//  TagApplicationView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import SwiftUI

struct TagApplicationView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel: TagApplicationViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    init(creator: Creator, applicationType: TagApplicationRequest.ApplicationType = .add) {
        let container = DependencyContainer.shared
        guard let viewModel = container.container.resolve(TagApplicationViewModel.self, arguments: creator, applicationType) else {
            fatalError("Failed to resolve TagApplicationViewModel")
        }
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    creatorInfoSection
                    applicationTypeSection
                    tagInputSection
                    reasonSection
                    infoSection
                }
                
                submitSection
                    .padding(.top, Spacing.relatedComponentDivider)
                    .background(Asset.Color.Application.Background.background.swiftUIColor)
            }
            .navigationTitle(L10n.TagApplication.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.Common.cancel) {
                        dismiss()
                    }
                }
            }
            .alert(viewModel.isSuccess ? L10n.TagApplication.success : L10n.TagApplication.error, 
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
                    Text("ID: \(viewModel.creator.id)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, Spacing.extraSmall)
        }
    }
    
    private var applicationTypeSection: some View {
        Section {
            Picker("申請タイプ", selection: $viewModel.applicationType) {
                ForEach(TagApplicationRequest.ApplicationType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.applicationType) { _, _ in
                viewModel.resetFormData()
            }
        }
    }
    
    private var tagInputSection: some View {
        Section {
            if viewModel.applicationType == .add {
                TextField(L10n.TagApplication.tagName, text: $viewModel.tagName)
                    .onChange(of: viewModel.tagName) { _, newValue in
                        viewModel.tagName = viewModel.validateTagName(newValue)
                    }
                
                HStack {
                    Spacer()
                    Text(viewModel.tagNameCharacterCount)
                        .font(.caption)
                        .foregroundColor(viewModel.tagName.count > 40 ? .orange : .secondary)
                }
            } else {
                // 削除の場合は既存タグから選択
                if viewModel.creator.relatedTag.isEmpty {
                    Text("このクリエイターにはタグが設定されていません")
                        .foregroundColor(.secondary)
                        .font(.caption)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.creator.relatedTag, id: \.self) { tag in
                                Button(action: {
                                    viewModel.tagName = tag
                                }, label: {
                                    Text("#\(tag)")
                                        .font(.caption)
                                        .padding(.horizontal, Spacing.relatedComponentDivider)
                                        .padding(.vertical, Spacing.smallMedium)
                                        .background(
                                            RoundedRectangle(cornerRadius: CornerRadius.extraLarge)
                                                .fill(viewModel.tagName == tag ? .blue : .gray.opacity(Opacity.overlayMedium))
                                        )
                                        .foregroundColor(viewModel.tagName == tag ? .white : .primary)
                                })
                            }
                        }
                        .padding(.horizontal, Spacing.screenEdgePadding)
                    }
                    
                    if !viewModel.tagName.isEmpty {
                        Text("選択中: #\(viewModel.tagName)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        } header: {
            Text(viewModel.applicationType == .add ? L10n.TagApplication.addTag : L10n.CreatorDetail.tagDeleteApplication)
        }
    }
    
    private var reasonSection: some View {
        Section {
            TextField(L10n.TagApplication.reasonPlaceholder, text: $viewModel.reason, axis: .vertical)
                .lineLimit(3...6)
                .onChange(of: viewModel.reason) { _, newValue in
                    viewModel.reason = viewModel.validateReason(newValue)
                }
            
            HStack {
                Spacer()
                Text(viewModel.reasonCharacterCount)
                    .font(.caption)
                    .foregroundColor(viewModel.reason.count > 180 ? .orange : .secondary)
            }
        } header: {
            Text(L10n.TagApplication.reason)
        }
    }
    
    private var submitSection: some View {
        Button(action: {
            Task {
                await viewModel.submitApplication()
            }
        }, label: {
            HStack {
                if viewModel.isSubmitting {
                    ProgressView()
                        .controlSize(.small)
                    Text(L10n.TagApplication.submitting)
                } else {
                    Text(L10n.TagApplication.submit)
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
                Label(L10n.TagApplication.info, systemImage: "info.circle")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text(L10n.TagApplication.infoDescription)
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
        isActive: true
    )
    
    TagApplicationView(creator: mockCreator, applicationType: .add)
}
