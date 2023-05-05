// 
//  DashboardViewModel.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import Combine
import Foundation
import UserNotifications

protocol DashboardViewModel: ObservableObject {
    var viewState: DashboardViewState { get }
    var isScratchButtonEnabled: Bool { get }
    var isActivateButtonEnabled: Bool { get }

    func didTapScratch()
    func didTapActivation()
}

final class DashboardViewModelImp: DashboardViewModel {

    // MARK: - Properties

    private let flowState: AppFlowState
    private let scratchCardStorage: SharedStorage<ScratchCard>

    // State

    @Published var viewState: DashboardViewState = .empty
    @Published var isScratchButtonEnabled: Bool = false
    @Published var isActivateButtonEnabled: Bool = false

    // MARK: - Initialization

    init(scratchCardStorage: SharedStorage<ScratchCard>, flowState: AppFlowState) {
        self.scratchCardStorage = scratchCardStorage
        self.flowState = flowState
        setupSubscriptions()
        requestNotificationPermission()
        loadData()
    }

    // MARK: - Subscriptions

    func setupSubscriptions() {
        scratchCardStorage.$value
            .compactMap { [weak self] in self?.makeState(for: $0) }
            .assign(to: &$viewState)

        scratchCardStorage.$value
            .map { $0?.state == .unused }
            .assign(to: &$isScratchButtonEnabled)

        scratchCardStorage.$value
            .map { $0?.state == .opened }
            .assign(to: &$isActivateButtonEnabled)
    }

    // MARK: - Actions

    func didTapScratch() {
        flowState.showScratchCardDetail = true
    }

    func didTapActivation() {
        flowState.showScratchCardDetail = true
    }

    // MARK: - Utilities

    private func loadData() {
        guard scratchCardStorage.value == nil else {
            return
        }
        scratchCardStorage.value = ScratchCard(code: UUID())
    }

    // MARK: - Factory

    private func makeState(for scratchCard: ScratchCard?) -> DashboardViewState {
        guard let scratchCard else {
            return .empty
        }
        let contentModel = DashboardContentStateViewModel(
            scratchCard: scratchCard,
            didTapScratch: { [weak self] in self?.didTapScratch() },
            didTapActivate: { [weak self] in self?.didTapActivation() }
        )
        return .content(contentModel)
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            // Do nothing
        }
    }
}
