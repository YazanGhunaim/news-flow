//
//  PreferenceSelectionView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct PreferenceSelectionView: View {
    @State private var selectedIndices = [Int]()
    let categories = ["Business", "Entertainment", "Health", "Science", "Technology", "General", "Sports"]  // TODO: backedn

    var selectedEnough: Bool {
        selectedIndices.count >= 3
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("Follow up on:")
                .font(.title.bold())
                .foregroundStyle(Color.NFPrimary)

            // MARK: Selections
            NewsCategorySelectionGrid(selectedIndices: $selectedIndices, categories: categories)

            // MARK: Button
            VStack(alignment: .center, spacing: 8) {
                if !selectedEnough {
                    Text("Please select at least 3 categories.")
                        .foregroundStyle(Color.red)
                }
                CustomButton(disabled: selectedEnough, text: "Submit") {
                    // TODO: logic
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PreferenceSelectionView()
}
