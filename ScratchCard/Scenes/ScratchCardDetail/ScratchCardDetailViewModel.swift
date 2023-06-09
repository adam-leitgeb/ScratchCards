// 
//  ScratchCardDetailViewModel.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 05.05.23.
//

import Combine
import Foundation
import SwiftUI
import UIKit
import UserNotifications

protocol ScratchCardDetailViewModel: ObservableObject {
    var scratchCardViewModel: ScratchCardViewModel? { get }
    var primaryActionTitle: String { get }
    var error: String? { get set }
    var isLoading: Bool { get }
    var interactiveDismissDisabled: Bool { get }

    func didTapConfirm()
}

final class ScratchCardDetailViewModelImp: ScratchCardDetailViewModel {

    // MARK: - Properties

    private let scratchCardStorage: SharedStorage<ScratchCard>
    private let flowState: AppFlowState
    private let service: ScratchCardDetailService
    private let notificationDelegate = NotificationDelegate()
    private var subscriptions: Set<AnyCancellable> = []

    // State

    @Published var isLoading: Bool = false
    @Published var scratchCardViewModel: ScratchCardViewModel?
    @Published var primaryActionTitle: String = ""
    @Published var error: String?
    @Published var interactiveDismissDisabled: Bool = false

    // MARK: - Initialization

    init(scratchCardStorage: SharedStorage<ScratchCard>, flowState: AppFlowState, service: ScratchCardDetailService) {
        self.scratchCardStorage = scratchCardStorage
        self.flowState = flowState
        self.service = service
        loadData()
    }

    // MARK: - View Lifecycle

    deinit {
        service.cancelOpeningIfInProgress()
    }

    // MARK: - Actions

    func didTapConfirm() {
        guard let scratchCard = scratchCardStorage.value else {
            return
        }
        switch scratchCard.state {
        case .unused:
            openScratchCard()
        case .opened:
            activateScratchCard()
        case .activated:
            error = "Unsupported action"
        }
    }

    // MARK: - Data

    private func loadData() {
        guard let scratchCard = scratchCardStorage.value else {
            return
        }
        scratchCardViewModel = ScratchCardViewModel(scratchCard: scratchCard)
        primaryActionTitle = scratchCard.state.buttonTitle
    }

    private func openScratchCard() {
        guard let scratchCard =  scratchCardStorage.value else {
            return
        }
        isLoading = true

        service.open(scratchCard)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] in self?.process($0) },
                receiveValue: { [weak self] in self?.process($0) }
            )
            .store(in: &subscriptions)
    }

    private func activateScratchCard() {
        guard let scratchCard =  scratchCardStorage.value else {
            return
        }
        isLoading = true
        interactiveDismissDisabled = true

        service.activate(scratchCard)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] in self?.process($0) },
                receiveValue: { [weak self] in self?.process($0) }
            )
            .store(in: &subscriptions)
    }

    // MARK: - Processing

    private func process(_ completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            self.error = error.localizedDescription
            displayNotification(for: error)
        }
        isLoading = false
        interactiveDismissDisabled = false
    }

    private func process(_ value: ScratchCard) {
        scratchCardStorage.value = value
        flowState.showScratchCardDetail = false
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    private func displayNotification(for error: Error) {
        let content = UNMutableNotificationContent()
        content.title = "Error"
        content.subtitle = error.localizedDescription
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest( identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().delegate = notificationDelegate
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Utilities

extension ScratchCard.State {

    var buttonTitle: String {
        switch self {
        case .unused:
            return "Scratch!"
        case .opened:
            return "Activate"
        case .activated:
            return "Activated"
        }
    }
}
