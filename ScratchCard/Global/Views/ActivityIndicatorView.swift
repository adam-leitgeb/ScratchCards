//
//  ScratchCardView.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import SwiftUI

public struct ActivityIndicatorView {

    // MARK: - Properties

    @State private var isAnimating: Bool
    private let color: UIColor
    private let style: UIActivityIndicatorView.Style

    // MARK: - Object Lifecycle

    public init(color: UIColor = .label, style: UIActivityIndicatorView.Style = .medium, isAnimating: Bool = true) {
        self.color = color
        self.style = style
        _isAnimating = .init(initialValue: isAnimating)
    }
}

// MARK: - UIViewRepresentable

extension ActivityIndicatorView: UIViewRepresentable {

    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.color = color
        activityIndicator.style = style

        return activityIndicator
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

// MARK: - Preview

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView(color: .black, isAnimating: true)
    }
}
