//
//  PrimaryButtonStyleModifier.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.accentColor)
            .foregroundColor(Color.white)
            .cornerRadius(8)
    }
}

// MARK: -

extension View {

    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonStyleModifier())
    }
}
