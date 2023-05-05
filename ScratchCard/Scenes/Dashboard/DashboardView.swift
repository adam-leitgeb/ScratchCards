// 
//  DashboardView.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import SwiftUI

struct DashboardView<ViewModel: DashboardViewModel>: View {

    // MARK: - Properties

    @StateObject var viewModel: ViewModel

    // Body

    var body: some View {
        NavigationView {
            switch viewModel.viewState {
            case .empty:
                DashboardEmptyStateView()
            case let .content(contentModel):
                DashboardContentStateView(viewModel: contentModel)
            }
        }
    }
}

// MARK: - Preview

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: MockViewModel(viewState: .empty))
        DashboardView(viewModel: MockViewModel(viewState: .content(.makeMock(for: .mockUnopened))))
    }
}

extension DashboardView_Previews {

    private final class MockViewModel: DashboardViewModel {
        var isScratchButtonEnabled: Bool = true
        var isActivateButtonEnabled: Bool = false
        var viewState: DashboardViewState

        init(viewState: DashboardViewState) { self.viewState = viewState }
        func didTapScratch() {}
        func didTapActivation() {}
    }
}
