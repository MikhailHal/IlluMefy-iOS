//
//  BugTabView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

import SwiftUI
import Shimmer

struct BugTabView: View {
    @State private var viewModel: BugTabViewViewModelProtocol = DependencyContainer.shared.resolve(BugTabViewViewModelProtocol.self)!
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                loadingView
            } else {
                Text(viewModel.bugStatusText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.screenEdgePadding)
            }
        }.onAppear {
            Task {
                await viewModel.loadBugStatus()
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

#Preview {
    BugTabView()
}
