//
//  ScratchCardDetailViewModelTests.swift
//  ScratchCardTests
//
//  Created by Adam Leitgeb on 05.05.23.
//

import XCTest
import Combine
@testable import ScratchCard

final class ScratchCardDetailViewModelTests: XCTestCase {

    // MARK: - Properties

    let code = UUID()
    var viewModel: ScratchCardDetailViewModelImp!
    var mockService: MockScratchCardDetailService!
    var serviceImp: ScratchCardDetailServiceImp!
    var scratchCardStorage: SharedStorage<ScratchCard>!
    var subscriptions: Set<AnyCancellable> = []

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        mockService = MockScratchCardDetailService()
        serviceImp = ScratchCardDetailServiceImp()
        scratchCardStorage = SharedStorage(ScratchCard.mockUnopened)
        viewModel = ScratchCardDetailViewModelImp(scratchCardStorage: scratchCardStorage, flowState: AppFlowState(), service: mockService)
        subscriptions.removeAll()
    }

    // MARK: - Initial State

    func test_viewState_whenScratchCardIsUnused_shouldBeLoadedSuccessfully() {
        // Given
        scratchCardStorage = SharedStorage(ScratchCard.mockUnopened)
        viewModel = ScratchCardDetailViewModelImp(scratchCardStorage: scratchCardStorage, flowState: AppFlowState(), service: mockService)

        // Then
        XCTAssertEqual(viewModel.primaryActionTitle, "Scratch!")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertNotNil(viewModel.scratchCardViewModel)
    }

    func test_viewState_whenScratchCardIsOpened_shouldBeLoadedSuccessfully() {
        // Given
        scratchCardStorage = SharedStorage(ScratchCard.mockOpened)
        viewModel = ScratchCardDetailViewModelImp(scratchCardStorage: scratchCardStorage, flowState: AppFlowState(), service: mockService)

        // Then
        XCTAssertEqual(viewModel.primaryActionTitle, "Activate")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertNotNil(viewModel.scratchCardViewModel)
    }

    func test_viewState_whenScratchCardIsActivated_shouldBeLoadedSuccessfully() {
        // Given
        scratchCardStorage = SharedStorage(ScratchCard.mockActivated)
        viewModel = ScratchCardDetailViewModelImp(scratchCardStorage: scratchCardStorage, flowState: AppFlowState(), service: mockService)

        // Then
        XCTAssertEqual(viewModel.primaryActionTitle, "Activated")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertNotNil(viewModel.scratchCardViewModel)
    }

    // MARK: - Error

    func test_didTapConfirm_whenScratchCardIsActivated_shouldSetError() {
        // Given
        scratchCardStorage.value = ScratchCard.mockActivated

        // When
        viewModel.didTapConfirm()

        // Then
        XCTAssertEqual(viewModel.error, "Unsupported action")
    }

    // MARK: - Actions

    func test_didTapConfirm_whenScratchCardIsUnused_shouldCallOpen() {
        // Given
        scratchCardStorage.value = ScratchCard(code: code, state: .unused)
        viewModel = ScratchCardDetailViewModelImp(scratchCardStorage: scratchCardStorage, flowState: AppFlowState(), service: mockService)

        // Setup
        let openPublisherExpectation = expectation(description: "Activate publisher emits a value")
        let openPublisher = setupPublisher(expectedScratchCardState: .opened, serviceReturnValue: &mockService.openReturnValue)

        // When
        viewModel.didTapConfirm()

        // Then
        waitForPublisherExpectation(openPublisherExpectation, publisher: openPublisher)
        XCTAssertEqual(mockService.openCallsCount, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(scratchCardStorage.value?.state, .opened)
        XCTAssertNil(viewModel.error)
    }

    func test_didTapConfirm_whenScratchCardIsOpened_shouldCallActivate() {
        // Given
        scratchCardStorage.value = ScratchCard(code: code, state: .opened)
        viewModel = ScratchCardDetailViewModelImp(scratchCardStorage: scratchCardStorage, flowState: AppFlowState(), service: mockService)

        // Setup
        let activatePublisherExpectation = expectation(description: "Activate publisher emits a value")
        let activatePublisher = setupPublisher(expectedScratchCardState: .activated, serviceReturnValue: &mockService.activateReturnValue)

        // When
        viewModel.didTapConfirm()

        // Then
        waitForPublisherExpectation(activatePublisherExpectation, publisher: activatePublisher)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(mockService.activateCallsCount, 1)
        XCTAssertEqual(scratchCardStorage.value?.state, .activated)
        XCTAssertNil(viewModel.error)
    }

    // MARK: - Utilities

    private func setupPublisher(expectedScratchCardState: ScratchCard.State, serviceReturnValue: inout AnyPublisher<ScratchCard, Error>?) -> AnyPublisher<ScratchCard, Error> {
        let publisher = Just(ScratchCard(code: code, state: expectedScratchCardState))
            .setFailureType(to: Error.self)
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .share()

        serviceReturnValue = publisher.eraseToAnyPublisher()

        return publisher.eraseToAnyPublisher()
    }

    private func waitForPublisherExpectation(_ expectation: XCTestExpectation, publisher: AnyPublisher<ScratchCard, Error>) {
        let subscription = publisher.sink(receiveCompletion: { _ in expectation.fulfill() }, receiveValue: { _ in })
        waitForExpectations(timeout: 5.0)
        subscription.cancel()
    }
}

class MockScratchCardDetailService: ScratchCardDetailService {

    var openCallsCount = 0
    var openReceivedScratchCard: ScratchCard?
    var openReturnValue: AnyPublisher<ScratchCard, Error>!

    var activateCallsCount = 0
    var activateReceivedScratchCard: ScratchCard?
    var activateReturnValue: AnyPublisher<ScratchCard, Error>!

    var cancelOpeningIfInProgressCallsCount = 0

    func open(_ scratchCard: ScratchCard) -> AnyPublisher<ScratchCard, Error> {
        openCallsCount += 1
        openReceivedScratchCard = scratchCard
        return openReturnValue
    }

    func activate(_ scratchCard: ScratchCard) -> AnyPublisher<ScratchCard, Error> {
        activateCallsCount += 1
        activateReceivedScratchCard = scratchCard
        return activateReturnValue
    }

    func cancelOpeningIfInProgress() {
        cancelOpeningIfInProgressCallsCount += 1
    }
}
