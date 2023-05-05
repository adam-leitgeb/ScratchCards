//
//  DashboardContentStateViewModel.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 05.05.23.
//

import Foundation

struct DashboardContentStateViewModel {
    let scratchCard: ScratchCard
    let isScratchEnabled: Bool
    let isActivateEnabled: Bool
    let didTapScratch: () -> Void
    let didTapActivate: () -> Void
}

// MARK: - Initialization

extension DashboardContentStateViewModel {

    init(scratchCard: ScratchCard, didTapScratch: @escaping () -> Void, didTapActivate: @escaping () -> Void) {
        self.scratchCard = scratchCard
        self.didTapScratch = didTapScratch
        self.didTapActivate = didTapActivate

        switch scratchCard.state {
        case .unused:
            isScratchEnabled = true
            isActivateEnabled = false
        case .opened:
            isScratchEnabled = false
            isActivateEnabled = true
        case .activated:
            isScratchEnabled = false
            isActivateEnabled = false
        }
    }
}

// MARK: - Mock

extension DashboardContentStateViewModel {

    static func makeMock(for scratchCard: ScratchCard) -> DashboardContentStateViewModel {
        DashboardContentStateViewModel(
            scratchCard: scratchCard,
            didTapScratch: {},
            didTapActivate: {}
        )
    }
}
