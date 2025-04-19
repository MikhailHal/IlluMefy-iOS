//
//  Spacing.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/24.
//

import CoreGraphics
enum Spacing {
    // doesn't divide
    static let none: CGFloat = 0
    // group related components together.
    // e.g. labels that tell what is this form and actual fields
    static let componentGrouping: CGFloat = 8
    // divide related components with different functions.
    // e.g. email fields and password fields.
    static let relatedComponentDivider: CGFloat = 12
    // screen content padding(from edges)
    static let screenEdgePadding: CGFloat = 20
    // card content padding(from edges)
    static let cardEdgePadding: CGFloat = 12
    // divide unrelated components with different functions.
    // e.g. email fields and login button.
    static let unrelatedComponentDivider: CGFloat = 32
}
