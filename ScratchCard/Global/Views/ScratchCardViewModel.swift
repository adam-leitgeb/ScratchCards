//
//  ScratchCardViewModel.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import Foundation
import SwiftUI

struct ScratchCardViewModel {

    // MARK: - Properties

    private let cardState: ScratchCard.State
    let code: String
    let imageName: String
    let gradientColors: [Color]

    // Helpers

    var isCodeHidden: Bool {
        if case .unused = cardState {
            return true
        }
        return false
    }
}

// MARK: - Initialization

extension ScratchCardViewModel {

    init(scratchCard: ScratchCard) {
        code = scratchCard.code.uuidString
        cardState = scratchCard.state

        switch scratchCard.state {
        case .unused:
            imageName = "Ticket"
            gradientColors = [.blue.opacity(0.6), .blue]
        case .opened:
            imageName = "Diamond"
            gradientColors = [.yellow, .orange]
        case .activated:
            imageName = "Checkmark"
            gradientColors = [.green.opacity(0.6), .green]
        }
    }
}
