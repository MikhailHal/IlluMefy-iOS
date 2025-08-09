//
//  View+CornerRadius.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/09.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(corners: corners, radius: radius))
    }
}

struct RoundedCorner: Shape {
    var corners: UIRectCorner = .allCorners
    var radius: CGFloat = .infinity

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}