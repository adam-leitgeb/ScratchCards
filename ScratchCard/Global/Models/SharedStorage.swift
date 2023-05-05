//
//  SharedStorage.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import Foundation

public final class SharedStorage<T>: ObservableObject {
    @Published public var value: T?

    public init(_ value: T? = nil) {
        self.value = value
    }
}
