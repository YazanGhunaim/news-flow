//
//  OnboardingView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(Router.self) private var router

    @State private var selectedIndices = [Int]()
    @State private var showErrorAlert: Bool = false
    @State private var viewmodel = OnboardingViewModel(categoryService: CategoryService(), userService: UserService())

    var selectedEnough: Bool {
        selectedIndices.count >= 3 && selectedIndices.count <= 5
    }

    var selectedCategories: [String] {
        selectedIndices.compactMap { index in
            viewmodel.categories[index]
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
                NewsCategorySelectionGrid(selectedIndices: $selectedIndices, categories: viewmodel.categories)

                // MARK: Submit Button
                VStack(alignment: .center, spacing: 8) {
                    if !selectedEnough {
                        Text("Please select between 3 and 5 categories.")
                            .foregroundStyle(Color.red)
                    }

                    CustomButton(enabled: selectedEnough, text: "Submit") {
                        Task {
                            do {
                                try await viewmodel.setUserCategoryPreferences(selectedCategories)
                                router.navigate(to: .tabView)
                            } catch {
                                showErrorAlert.toggle()
                            }
                        }
                    }
                    .padding()
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
    OnboardingView()
}
