//
//  PreferenceSelectionView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct PreferenceSelectionView: View {
    @Environment(Router.self) private var router

    @State private var viewmodel = OnboardingViewModel()
    @State private var selectedIndices = [Int]()

    @State private var showErrorAlert: Bool = false

    let categories = ["business", "entertainment", "health", "science", "technology", "general", "sports"]  // TODO: backedn

    var selectedEnough: Bool {
        selectedIndices.count >= 3
    }

    var selectedCategories: [String] {
        selectedIndices.compactMap { index in
            categories[index]
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            // MARK: Header view
            OnboardingHeaderView(text: "Say Hello To Your Personal\nAI News Assistant")

            VStack(alignment: .leading, spacing: 32) {
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
                    CustomButton(enabled: selectedEnough, text: "Submit") {
                        Task {
                            do {
                                try await viewmodel.setCategoryPreferences(categories: selectedCategories)
                                router.navigate(to: .home)
                            } catch {
                                showErrorAlert.toggle()
                            }
                        }
                    }
                }

                // push stuff up
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .alert("Error occurred, please try again", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    PreferenceSelectionView()
}
