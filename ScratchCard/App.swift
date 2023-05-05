import SwiftUI

@main
struct ScratchCardApp: App {

    // MARK: - Properties

    @StateObject var flowState = AppFlowState()
    let appState = AppState()

    // Body

    var body: some Scene {
        WindowGroup {
            makeDashboard(scratchCardStorage: appState.scratchCardStorage, flowState: flowState)
                .sheet(isPresented: $flowState.showScratchCardDetail) {
                    makeScratchDetail(scratchCardStorage: appState.scratchCardStorage, flowState: flowState)
                }
        }
    }
}

// MARK: - Utilities

extension ScratchCardApp {

    func makeDashboard(scratchCardStorage: SharedStorage<ScratchCard>, flowState: AppFlowState) -> some View {
        DashboardView(
            viewModel: DashboardViewModelImp(scratchCardStorage: scratchCardStorage, flowState: flowState)
        )
    }

    func makeScratchDetail(scratchCardStorage: SharedStorage<ScratchCard>, flowState: AppFlowState) -> some View {
        ScratchCardDetailView(
            viewModel: ScratchCardDetailViewModelImp(
                scratchCardStorage: scratchCardStorage,
                flowState: flowState,
                service: ScratchCardDetailServiceImp()
            )
        )
    }
}
