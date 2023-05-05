//
//  ScratchCardView.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import SwiftUI

struct ScratchCardView: View {

    // MARK: - Properties

    let viewModel: ScratchCardViewModel

    // Body

    var body: some View {
        ZStack(alignment: .bottom) {
            icon
            codeWrapper
        }
        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: viewModel.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .frame(width: 260, height: 440)
    }

    // Views

    private var icon: some View {
        VStack {
            Image(viewModel.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
        }
        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
    }

    @ViewBuilder
    private var codeWrapper: some View {
        if !viewModel.isCodeHidden {
            codeValue
        }
    }

    private var codeValue: some View {
        Text(viewModel.code)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(8)
            .padding([.horizontal, .bottom], 24)
    }
}

// MARK: - Preview

struct ScratchCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchCardView(viewModel: .init(scratchCard: .mockUnopened))
            .previewLayout(.fixed(width: 240, height: 240))

        ScratchCardView(viewModel: .init(scratchCard: .mockOpened))
            .previewLayout(.fixed(width: 240, height: 240))

        ScratchCardView(viewModel: .init(scratchCard: .mockActivated))
            .previewLayout(.fixed(width: 240, height: 240))
    }
}
