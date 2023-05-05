//
//  AppState.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import Combine
import Foundation

final class AppState: ObservableObject {

    // MARK: - Properties

    let scratchCardStorage = SharedStorage<ScratchCard>()
}
