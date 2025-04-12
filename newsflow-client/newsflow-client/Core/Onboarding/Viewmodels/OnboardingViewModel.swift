//
//  OnboardingViewModel.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import Foundation

@Observable
@MainActor
class OnboardingViewModel {
    let categoryService: CategoryService
    let userService: UserService

    var categories = [String]()

    init(categoryService: CategoryService, userService: UserService, categories: [String] = [String]()) {
        self.categoryService = categoryService
        self.userService = userService
        Task { await fetchCategories() }
    }

    func fetchCategories() async {
        let _categories = await categoryService.getCategories()
        categories = _categories.filter { $0 != "general" }
    }

    func setUserCategoryPreferences(_ selectedCategories: [String]) async throws {
        try await userService.setCategoryPreferences(categories: selectedCategories)
    }
}
