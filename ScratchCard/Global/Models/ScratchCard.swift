//
//  ScratchCard.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import Foundation

struct ScratchCard {

    // MARK: - Types

    enum State {
        case unused
        case opened
        case activated
    }

    // MARK: - Properties

    var code: UUID
    var state: State

    // MARK: - Initialization

    init(code: UUID, state: State = .unused) {
        self.code = code
        self.state = state
    }

    // MARK: - Actions

    func scratched() throws -> ScratchCard {
        guard case .unused = state else {
            throw "Able to scratch only unused card"
        }
        return ScratchCard(code: code, state: .opened)
    }

    func activated() throws -> ScratchCard {
        guard case .opened = state else {
            throw "Able to activate only opened card"
        }
        return ScratchCard(code: code, state: .activated)
    }

    mutating func scratch() {
        guard case .unused = state else {
            return
        }
        state = .opened
    }

    mutating func activate() {
        guard case .opened = state else {
            return
        }
        state = .activated
    }
}

// MARK: - Mock

extension ScratchCard {

    static let mockUnopened = ScratchCard(code: UUID(), state: .unused)
    static let mockOpened = ScratchCard(code: UUID(), state: .opened)
    static let mockActivated = ScratchCard(code: UUID(), state: .activated)
}
