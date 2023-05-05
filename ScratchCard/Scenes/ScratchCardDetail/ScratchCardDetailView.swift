// 
//  ScratchCardDetailView.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 05.05.23.
//

import SwiftUI

struct ScratchCardDetailView<ViewModel: ScratchCardDetailViewModel>: View {

    // MARK: - Properties

    @StateObject var viewModel: ViewModel

    // Body

    var body: some View {
        VStack {
            VStack {
                viewModel.scratchCardViewModel.map {
                    ScratchCardView(viewModel: $0)
                        .rotationShakeAnimation()
                }
            }
            .frame(minHeight: .zero, maxHeight: .infinity)
            primaryAction
        }
        .alert(item: $viewModel.error) { Alert(title: Text($0)) }
        .interactiveDismissDisabled(viewModel.interactiveDismissDisabled)
    }

    // Views

    private var primaryAction: some View {
        PrimaryButton(
            title: viewModel.primaryActionTitle,
            isLoading: viewModel.isLoading,
            perform: viewModel.didTapConfirm
        )
        .bottomStackStyle()
    }
}

// MARK: - Preview

struct ScratchCardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Color.black
            .sheet(isPresented: .constant(true)) {
                ScratchCardDetailView(viewModel: MockViewModel())
            }
    }
}

extension ScratchCardDetailView_Previews {

    private final class MockViewModel: ScratchCardDetailViewModel {
        var isLoading: Bool = false
        var error: String?
        var primaryActionTitle: String = "Scratch!"
        var scratchCardViewModel: ScratchCardViewModel? = ScratchCardViewModel(scratchCard: .mockUnopened)
        var interactiveDismissDisabled: Bool = false

        func didTapConfirm() {}
    }
}
