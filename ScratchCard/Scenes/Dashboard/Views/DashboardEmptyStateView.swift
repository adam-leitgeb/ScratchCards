//
//  DashboardEmptyStateView.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 04.05.23.
//

import SwiftUI

struct DashboardEmptyStateView: View {

    // MARK: - Properties

    // Body

    var body: some View {
        Text("No Scratch Card")
            .font(.title)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }
}

// MARK: - Preview

struct DashboardEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardEmptyStateView()
    }
}
