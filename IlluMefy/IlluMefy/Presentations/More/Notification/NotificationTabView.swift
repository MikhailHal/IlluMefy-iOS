//
//  NotificationTabView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

import SwiftUI
import Shimmer

struct NotificationTabView: View {
    @State private var isLoading = false
    @State private var viewModel: NotificationTabViewViewModelProtocol = DependencyContainer.shared.resolve(NotificationTabViewViewModelProtocol.self)!
    @State private var content: String = ""
    
    var body: some View {
        ScrollView {
            if isLoading {
                loadingView
            } else {
                Text(content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.screenEdgePadding)
            }
        }.onAppear {
            Task {
                try content = await viewModel.getNotification()
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            ForEach(0..<8, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(Opacity.glow))
                    .frame(height: 16)
                    .shimmering()
            }
        }
        .padding(Spacing.screenEdgePadding)
    }
}
