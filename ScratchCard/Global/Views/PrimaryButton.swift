//
//  DashboardButton.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import SwiftUI

struct PrimaryButton: View {

    // MARK: - Properties

    private let title: String
    private let isLoading: Bool
    private let isEnabled: Bool
    private let perform: () -> Void

    // Body

    public var body: some View {
        Button(
            action: didTap,
            label: { label }
        )
        .frame(minWidth: 0.0, maxWidth: .infinity, minHeight: 50.0, maxHeight: 50.0, alignment: .center)
        .background(isEnabled ? Color.accentColor : Color.gray)
        .cornerRadius(12)
        .disabled(!isEnabled)
    }

    // Views

    private var label: some View {
        HStack {
            if isLoading {
                ActivityIndicatorView(color: .white)
            } else {
                buttonTitleText
            }
        }
        .frame(minWidth: 0.0, maxWidth: .infinity, minHeight: 0.0, maxHeight: .infinity)
    }

    private var buttonTitleText: some View {
        Text(title)
            .font(.system(size: 15.0, weight: .semibold))
            .minimumScaleFactor(0.5)
            .foregroundColor(.white)
    }

    // MARK: - Initialization

    public init(title: String, isLoading: Bool = false, isEnabled: Bool = true, perform: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.perform = perform
    }

    // MARK: - Actions

    private func didTap() {
        guard !isLoading else {
            return
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        perform()
    }
}

// MARK: - Preview

struct DashboardButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Action", perform: {})
    }
}
