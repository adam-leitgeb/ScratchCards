//
//  URL+StringLiteral.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 05.05.23.
//

import Foundation

extension URL: ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {
        guard let url = URL(string: value) else {
            fatalError("Invalid URL string: \(value)")
        }
        self = url
    }
}
