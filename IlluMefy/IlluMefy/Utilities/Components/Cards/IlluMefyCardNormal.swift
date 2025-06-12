//
//  IlluMefyCardNormal.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/20.
//

import SwiftUI

struct IlluMefyCardNormal<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack(spacing: Spacing.relatedComponentDivider) {
            content
        }
        .padding(Spacing.cardEdgePadding)
        .background(Asset.Color.Application.Background.background.swiftUIColor)
        .cornerRadius(CornerRadius.card)
        .shadow(color: Color.black.opacity(Opacity.shadow), radius: Shadow.radiusSmall, x: 0, y: Shadow.offsetYSmall)
    }
}

#Preview {
    IlluMefyCardNormal(content: {
            Text(L10n.Common.hello)
    })
}
