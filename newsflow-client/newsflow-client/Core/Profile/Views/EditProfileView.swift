//
//  EditProfileView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import SwiftUI

struct EditProfileView: View {
    @State private var selectedIndices = [Int]()
    @State private var showErrorAlert: Bool = false
    @State private var viewmodel = EditProfileViewModel(categoryService: CategoryService(), userService: UserService())

    @Environment(Router.self) private var router

    var selectedEnough: Bool {
        selectedIndices.count >= 3 && selectedIndices.count <= 5
    }

    var selectedCategories: [String] {
        selectedIndices.compactMap { index in
            viewmodel.categories[index]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // MARK: Selections
            NewsCategorySelectionGrid(selectedIndices: $selectedIndices, categories: viewmodel.categories)

            // MARK: Update Button
            VStack(alignment: .center, spacing: 8) {
                if !selectedEnough {
                    Text("Please select between 3 and 5 categories.")
                        .foregroundStyle(Color.red)
                }

                CustomButton(enabled: selectedEnough, text: "Update") {
                    Task {
                        do {
                            try await viewmodel.updateUserCategoryPreferences(selectedCategories)
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
        .navigationTitle("Edit profile preferences")
        .alert("Error occurred, please try again", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    EditProfileView()
}
