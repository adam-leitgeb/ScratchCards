//
//  OpenScratchCardService.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 05.05.23.
//

import Combine
import Foundation

protocol ScratchCardDetailService {
    func open(_ scratchCard: ScratchCard) -> AnyPublisher<ScratchCard, Error>
    func activate(_ scratchCard: ScratchCard) -> AnyPublisher<ScratchCard, Error>
    func cancelOpeningIfInProgress()
}

final class ScratchCardDetailServiceImp: ScratchCardDetailService {

    // MARK: - Properties

    private var openScratchCardSubscription: AnyCancellable?

    // MARK: - Actions

    func open(_ scratchCard: ScratchCard) -> AnyPublisher<ScratchCard, Error> {
        let publisher = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .tryMap { _ in try scratchCard.scratched() }
            .eraseToAnyPublisher()

        openScratchCardSubscription = publisher
            .sink(
                receiveCompletion: { [weak self] _ in self?.openScratchCardSubscription = nil },
                receiveValue: { _ in }
            )

        return publisher
    }

    func activate(_ scratchCard: ScratchCard) -> AnyPublisher<ScratchCard, Error> {
        URLSession.shared.dataTaskPublisher(for: "https://api.o2.sk/version")
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ActivateScratchCardResponse.self, decoder: JSONDecoder())
            .tryMap { [weak self] result in
                guard let self, self.isVersion(result.ios, >, than: "6.1") else {
                    throw "Unable to activate card"
                }
                return try scratchCard.activated()
            }
            .eraseToAnyPublisher()
    }

    func cancelOpeningIfInProgress() {
        openScratchCardSubscription?.cancel()
        openScratchCardSubscription = nil
    }

    // MARK: - Utilities

    private func isVersion(_ lhs: String, _ operation: (Int, Int) -> Bool, than rhs: String) -> Bool {
        let lhsComponents = lhs.split(separator: ".").compactMap { Int($0) }
        let rhsComponents = rhs.split(separator: ".").compactMap { Int($0) }

        for i in 0..<max(lhsComponents.count, rhsComponents.count) {
            let lhsComponent = lhsComponents.element(at: i) ?? 0
            let rhsComponent = rhsComponents.element(at: i) ?? 0
            if lhsComponent != rhsComponent {
                return operation(lhsComponent, rhsComponent)
            }
        }

        return operation(lhsComponents.last ?? 0, rhsComponents.last ?? 0)
    }
}

// MARK: - Utilities

fileprivate extension Array {

    func element(at index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
