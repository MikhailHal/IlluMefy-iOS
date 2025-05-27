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
        .background(Color("Background/Card"))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    IlluMefyCardNormal(content: {
            Text("IlluMefyCardNormal")
    })
}
