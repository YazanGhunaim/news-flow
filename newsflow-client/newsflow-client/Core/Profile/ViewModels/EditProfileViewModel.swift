//
//  EditProfileViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/11/25.
//

import Foundation

@Observable
@MainActor
class EditProfileViewModel: ObservableObject {
    let categoryService: CategoryService
    let userService: UserService

    var categories = [String]()

    init(categoryService: CategoryService, userService: UserService, categories: [String] = [String]()) {
        self.categoryService = categoryService
        self.userService = userService
        Task { await fetchCategories() }
    }

    func fetchCategories() async {
        categories = await categoryService.getCategories()
    }

    func updateUserCategoryPreferences(_ selectedCategories: [String]) async throws {
        try await userService.updateCategoryPreferences(categories: selectedCategories)
    }
}
