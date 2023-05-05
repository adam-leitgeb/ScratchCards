//
//  NewScratchCardStateView.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import SwiftUI

struct DashboardContentStateView: View {

    // MARK: - Properties

    let viewModel: DashboardContentStateViewModel

    // Body

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center, spacing: 56) {
                title
                ScratchCardView(viewModel: ScratchCardViewModel(scratchCard: viewModel.scratchCard))
            }
            .frame(minHeight: .zero, maxHeight: .infinity)
            bottomButtonStack
        }
    }

    // Views

    private var title: some View {
        Text("Scratch Card")
            .font(.title)
            .bold()
    }

    private var bottomButtonStack: some View {
        HStack {
            PrimaryButton(title: "Scratch", isEnabled: viewModel.isScratchEnabled, perform: viewModel.didTapScratch)
            PrimaryButton(title: "Activate", isEnabled: viewModel.isActivateEnabled, perform: viewModel.didTapActivate)
        }
        .bottomStackStyle()
    }
}

// MARK: - Preview

struct NewScratchCardStateView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContentStateView(viewModel: .makeMock(for: .mockUnopened))
        DashboardContentStateView(viewModel: .makeMock(for: .mockOpened))
        DashboardContentStateView(viewModel: .makeMock(for: .mockActivated))
    }
}
