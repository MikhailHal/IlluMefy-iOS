//
//  Spacing.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/24.
//

import CoreGraphics
enum Spacing {
    // doesn't divide
    static let none: CGFloat = 0
    // very small spacing for tight layouts
    static let extraSmall: CGFloat = 2
    // small spacing for compact components
    static let small: CGFloat = 4
    // small-medium spacing for tag padding
    static let smallMedium: CGFloat = 6
    // group related components together.
    // e.g. labels that tell what is this form and actual fields
    static let componentGrouping: CGFloat = 8
    // divide related components with different functions.
    // e.g. email fields and password fields.
    static let relatedComponentDivider: CGFloat = 12
    // medium spacing for button padding
    static let medium: CGFloat = 16
    // screen content padding(from edges)
    static let screenEdgePadding: CGFloat = 20
    // card content padding(from edges)
    static let cardEdgePadding: CGFloat = 12
    // divide unrelated components with different functions.
    // e.g. email fields and login button.
    static let unrelatedComponentDivider: CGFloat = 32
}
