//
//  RotationShakeAnimation.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 05.05.23.
//

import Foundation
import SwiftUI

struct RotationShakeAnimation {

    // MARK: - Properties

    @State private var isAnimating = false
}

// MARK: - ViewModifier

extension RotationShakeAnimation: ViewModifier {

    func body(content: Content) -> some View {
        content
            .rotationEffect(isAnimating ? Angle.degrees(-1) : Angle.degrees(1))
            .animation(Animation.easeInOut(duration: 0.2).repeatForever(autoreverses: true))
            .onAppear() {
                isAnimating = true
            }
    }
}

// MARK: - COnvenience

extension View {

    func rotationShakeAnimation() -> some View {
        modifier(RotationShakeAnimation())
    }
}
