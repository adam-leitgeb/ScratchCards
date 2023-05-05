//
//  String+Error.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import Foundation

extension String: LocalizedError {

    public var errorDescription: String? {
        self
    }
}
