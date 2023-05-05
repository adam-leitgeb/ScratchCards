//
//  ScratchCardDetailServiceTests.swift
//  ScratchCardTests
//
//  Created by Adam Leitgeb on 05.05.23.
//

import XCTest
import Combine
@testable import ScratchCard

final class ScratchCardDetailServiceTests: XCTestCase {

    // MARK: - Properties

    let code = UUID()
    var sut: ScratchCardDetailServiceImp!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        sut = ScratchCardDetailServiceImp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func testOpenScratchCard_success() {
        // Given
        let scratchCard = ScratchCard(code: code, state: .unused)
        let expectation = XCTestExpectation(description: "Open scratch card expectation")
        var result: ScratchCard?

        // When
        let cancellable = sut.open(scratchCard)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { value in
                    result = value
                    expectation.fulfill()
                }
            )

        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(result?.state, .opened)
        XCTAssertEqual(result?.code, scratchCard.code)
        XCTAssertNotNil(cancellable)
    }

    func testActivateScratchCard_success() {
        // Given
        let scratchCard = ScratchCard.mockOpened
        let expectation = XCTestExpectation(description: "Activate scratch card expectation")
        var result: ScratchCard?

        // When
        let cancellable = sut.activate(scratchCard)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { value in
                    result = value
                    expectation.fulfill()
                }
            )

        // Then
        wait(for: [expectation], timeout: 4)
        XCTAssertEqual(result?.state, .activated)
        XCTAssertEqual(result?.code, scratchCard.code)
        XCTAssertNotNil(cancellable)
    }
}
