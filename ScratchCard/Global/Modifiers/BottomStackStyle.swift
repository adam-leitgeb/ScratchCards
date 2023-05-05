//
//  BottomStackStyle.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 05.05.23.
//

import Foundation
import SwiftUI

struct BottomStackStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                Color(UIColor.systemBackground)
                    .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 8)
                    .ignoresSafeArea()
            )
    }
}

// MARK: -

extension View {

    func bottomStackStyle() -> some View {
        self.modifier(BottomStackStyle())
    }
}
